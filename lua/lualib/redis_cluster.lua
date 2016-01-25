local redis = require ("resty.redis")
local stringy = require "stringy" 
local constants = require "constants" 
local cfg   = require ("init_cfg")
local json_parser = require "json_parser"
local json     = require ("cjson")

local _M = {}
local redis_pool = { };
    _M.prefix = "zjex.session.id";
    _M.redis_pool = redis_pool;
local function isClusterChanged(ok,err)
    if not ok and err then
       local got = string.find(err,"MOVED") 
       local errs = stringy.split(err," ")
       local infos = errs[3]
       if infos then
          ngx.log(ngx.WARN,"<br> redis moved to "..(infos or "nil ").." <br>")
          --ngx.say(iipp)
          local ip_port = stringy.split(infos,":")
          local ip = ip_port[1]
          local port = ip_port[2] 
          return true,ip,port
       end
    end
    return false,nil,nil
end

 

function redis_pool_get_redis_conf(redis_name)
    local redis_config = cfg.redis_config;    
    local redis_host = "127.0.0.1"
    local redis_port = 6379
    local redis_timeout = 10000
    local redis_poolsize= 2000
    if redis_config and type(redis_config.host) == "string" then
        redis_host = redis_config.host
    end
    
    if redis_config and type(redis_config.port) == "number" then
        redis_port = redis_config.port
    end

    if redis_config and type(redis_config.timeout) == "number" then
        redis_timeout= redis_config.timeout
    end
    
    if redis_config and type(redis_config.poolsize) == "number" then
        redis_poolsize= redis_config.poolsize
    end
    ngx.log(ngx.INFO,redis_host..":"..tostring(redis_port).."  "..tostring(redis_timeout).."  "..tostring(redis_poolsize))
    return redis_host,redis_port,redis_timeout,redis_poolsize
end

function redis_pool_get_redis_conn(red_name) 	
    local app_name = ngx.ctx.APP_NAME
    local redis_name= red_name or 'redis'
    local pool_name= redis_name..redis_name
    local red_pool = ngx.ctx[_M.redis_pool]
    if red_pool and red_pool[pool_name] then
         return  red_pool[pool_name]
    end
    if not red_pool then
        red_pool = {}
    end 
    local red = redis:new()
    local redis_host,redis_port,redis_timeout,redis_poolsize= redis_pool_get_redis_conf(redis_name)
    local ok, err = red:connect(redis_host,redis_port)
    if not ok then
        ngx.log(ngx.ERR,"failed to connect: "..err)
        return nil, err
    end
    ngx.log(ngx.INFO,"connect redis completed!")
    red:set_timeout(redis_timeout) 
    red_pool[pool_name] = red
    --ngx.log(ngx.DEBUG,"ngx.ctx[redis_pool] ".. type(ngx.ctx))
    ngx.ctx[_M.redis_pool] = red_pool 
    return  red  -- ngx.ctx[redis_pool]
end

function redis_pool_close(red_name)
    local app_name = ngx.ctx.APP_NAME
    local redis_name= red_name or 'redis'
    local pool_name= redis_name..redis_name
    local red_pool = ngx.ctx[_M.redis_pool]
    if red_pool and red_pool[pool_name] then
         local redis_host,redis_port,redis_timeout,redis_poolsize= redis_pool_get_redis_conf(redis_name)
	 local red = red_pool[pool_name] 
         red:set_keepalive(redis_timeout, redis_poolsize)
         -- ngx.ctx[redis_pool] = nil
         red_pool[pool_name] = nil
     end
 end

-- 关闭或释放连接
-- local function close_redis(red)  
--   if not red then  
--     return;  
--   end  
--   --释放连接(连接池实现)  
--   local pool_max_idle_time = 10000 --毫秒  
--   local pool_size = 100 --连接池大小  
--   local ok, err = red:set_keepalive(pool_max_idle_time, pool_size)  
--   if not ok then  
--     ngx.log(ngx.DEBUG,"set keepalive error : " .. err)
--     return ok,err  
--   end
--   return true,nil   
-- end

 
------------------------------------------------------
--集群重连一次
local function retryHset(red,keyname,field,value)
      local ok,err = red:hset(keyname,field,value)      
      ngx.log(ngx.DEBUG,"hget once   ok="..(ok or "nil  err=")..(err or "")
      local flag,ip,port = isClusterChanged(ok,err)
      if flag then
         --重连，之后再次调用
        ok,err = red:connect(ip,port);
        if not ok then
           ngx.log(ngx.ERR,"failed to connect: "..err)
           return nil, err
        end
         ngx.log(ngx.INFO,"<br>reconnect to ip="..(ip or "nil ip").."   port = "..(port or "nil port").."<br>")
         ok,err = red:hset(keyname,field,value)
      end
      return ok,err
end
-- 
local function retryHget(red,keyname,field)
      local ok,err = red:hget(keyname,field)
      ngx.log(ngx.DEBUG,"hget once   ok="..(ok or "nil  err=")..(err or "")
      local flag,ip,port = isClusterChanged(ok,err)
      if flag then
         --重连，之后再次调用
        ok,err = red:connect(ip,port);
        if not ok then
           ngx.log(ngx.ERR,"failed to connect: "..err)
           return nil, err
        end         
         ngx.log(ngx.INFO,"<br>reconnect to ip="..(ip or "nil ip").."   port = "..(port or "nil port").."<br>")
         ok,err = red:hget(keyname,field)
      end
      return ok,err
end



local function setSession(session_id,key,value)
  ngx.log(ngx.DEBUG,"setSession  id="..session_id.." key="..key.." value="..value)
  local red = redis_pool_get_redis_conn() 
  if not red then
     ngx.log(ngx.ERR,"connot connect to redis pool !")
  end 
  local redis_key = _M.prefix..session_id
  value  = json.encode(value);
  ok, err = retryHset(red,redis_key ,key , value)
  if not ok then
    return
  end
  red:expire(redis_key,cfg.redis_config.timeout) --1  
  local ok , err = red:set_keepalive(0,100)
  return ok,err; 
end

local function getSession(session_id,key)
    
  local value = nil  
  local red = redis_pool_get_redis_conn()
  local redis_key = _M.prefix..session_id 
  local res, err = retryHget(red,redis_key,key )
  value = res
  if value and tostring(value) == "userdata: NULL" then
    value = nil
  else
    red:expire(redis_key,cfg.redis_config.timeout) --1000 - 1sec
    ngx.log(ngx.DEBUG,"  redis:expire("..redis_key..","..cfg.redis_config.timeout.." second)")
  end
  red:set_keepalive(0,100)
  return value 
end

    _M.getSession = getSession;
    _M.setSession = setSession; 
--################################################################################
return _M;