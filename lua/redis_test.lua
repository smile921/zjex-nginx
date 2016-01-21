local init_cfg = require("init_cfg")
local json     = require ("cjson")
local redis = require ("resty.redis")
local clusterRedis = require("zjexRedisCluster")  



local _M = {}
--********************************************
_M.session_redis_key_prefix="ngx_lua:session:userinfo:"
--*****************************************************************

local function close_redis(red)  
  if not red then  
    return  
  end  
  --释放连接(连接池实现)  
  local pool_max_idle_time = 10000 --毫秒  
  local pool_size = 100 --连接池大小  
  local ok, err = red:set_keepalive(pool_max_idle_time, pool_size)  
  if not ok then  
    ngx.say("set keepalive error : ", err)  
  end   
end

--创建实例  
local red = redis:new() 
-------------------------------------------------------  
   
------------------------------------------------------
--设置超时（毫秒）  
red:set_timeout(1000)  
--建立连接  
local ip = "10.88.1.214"  
local port = 7001  
local ok, err = red:connect(ip, port)  
if not ok then  
  ngx.say("connect to redis error : ", err)  
  return close_redis(red)  
end
ngx.say("  <br>创建redis 连接成功                  <br> ")  
--调用API进行处理  
ok, err = red:set("msg", "hello world")  
if not ok then  
  ngx.say("set msg error : ", err)  
  return close_redis(red)  
end  
ngx.say("  <br>redis set成功                       <br> ")    
--调用API获取数据  
local resp, err = red:get("msg")  
if not resp then  
  ngx.say("get msg error : ", err)  
  return close_reedis(red)  
end
ngx.say("  <br>读取redis 成功            <br> ")    
--得到的数据为空处理  
if resp == ngx.null then  
  resp = ''  --比如默认值  
end  
-- ngx.say("msg : ", resp)
local prefix = "ngx_lua:session:userinfo:";
-- hset设置
--local ok,err = clusterRedis:retryHset(red,prefix.."sessid-cd5e2b5c-eaf7-4612-b723-c9b6edc01a34",'kinfo',"{\"access_token\":\"cd5e2b5c-eaf7-4612-b723-c9b6edc01a34\",\"telephone\":\"15810973911\"}")
--ngx.say(ok)
--ngx.say(err)
--isClusterChanged(ok,err)
--local ok,err =  clusterRedis:retryHset(red,prefix.."sessid-cd5e2b5c-eaf7-4612-b723-hfdkjhsjssss",'kinfo',"{\"access_token\":\"cd5e2b5c-eaf7-4612-b723-c9b6edc01a34\",\"telephone\":\"15810973911\"}")
--ngx.say(ok)
--ngx.say(err)
--isClusterChanged(ok,err) 
--local ok,err =  clusterRedis:retryHset(red,prefix.."sessid-cd5e2b5c-eaf7-4612-b723-7n0eflsiejio",'kinfo',"{\"access_token\":\"cd5e2b5c-eaf7-4612-b723-c9b6edc01a34\",\"telephone\":\"15810973911\"}")
--ngx.say(ok)
--ngx.say(err)
--isClusterChanged(ok,err) 
--local ok,err =  clusterRedis:retryHset(red,prefix.."sessid-9nn4wxldd-eaf7-4612-8hwt-8u94jlsdw22r",'kinfo',"{\"access_token\":\"cd5e2b5c-eaf7-4612-b723-c9b6edc01a34\",\"telephone\":\"15810973911\"}")
--ngx.say(ok)
--ngx.say(err)
--isClusterChanged(ok,err) 
--local ok,err =  clusterRedis:retryHset(red,prefix.."sessid-mm3kk2llos-eaf7-4612-b723-c9b6edc01a34",'kinfo',"{\"access_token\":\"cd5e2b5c-eaf7-4612-b723-c9b6edc01a34\",\"telephone\":\"15810973911\"}")
--ngx.say(ok)
--ngx.say(err)
--isClusterChanged(ok,err)  
--local ok,err =  clusterRedis:retryHget(red,prefix.."sessid-cd5e2b5c-eaf7-4612-b723-c9b6edc01a34",'kinfo')
--if ok then
--  ngx.say(ok)         
--end

red:init_pipeline()
ngx.say("  <br>init_pipeline 连接       <br> ")  
red:set("msg1", "hello1")  
red:set("msg2", "hello2")  
red:get("msg1")  
red:get("msg2")  
local respTable, err = red:commit_pipeline()  
ngx.say("  <br>commit_pipeline         <br> ")   
--得到的数据为空处理  
if respTable == ngx.null then  
  respTable = {}  --比如默认值  
end  

--结果是按照执行顺序返回的一个table  
for i, v in ipairs(respTable) do  
  ngx.say("msg : ", v, "<br/>")  
end

local value = "{key:val,key1:val1}";
local key = "kinfo"
local redis_key="ngx_lua:session:userinfo:session-cd5e2b5c-eaf7-4612-b723-c9b6edc01a34"
red:init_pipeline()
value  = json.encode(value);
red:hset(redis_key ,key , value)
local results, err = red:commit_pipeline()
if results then
  ngx.say("<br> results <br>")
end    

local sha1, err = red:script("load",  "return redis.call('get', KEYS[1])");  
if not sha1 then  
  ngx.say("load script error : ", err)  
  return close_redis(red)  
end  
ngx.say("sha1 : ", sha1, "<br/>")  
local resp, err = red:evalsha(sha1, 1, "msg");     


ngx.say("  <br>关闭redis 连接       <br> ")
close_redis(red)  




function _M.delSession(session_id)
  local red = redis:new();    
  local host =  init_cfg.redis_ip
  local port =  init_cfg.redis_port

  red:set_timeout(1000) -- 1 sec
  local ok,err = red:connect(host,port)
  if not ok then  
    -- ngx.log(ngx.ERR,err);  
    -- ngx.exit(ngx.HTTP_SERVICE_UNAVAILABLE)

    zjexUtil.return_not_connect_redis("sdk_session.delSession() please make sure redis is on,redis connect "..(err or "@empty") )
  end  

  zjexUtil.debug("开始清除session_id: "..session_id.." redis信息")
  local results, err =  red:del( _M.session_redis_key_prefix..session_id) 
  if not results then
    zjexUtil.debug("failed to del userinfo: ", err)                  
  end
  zjexUtil.debug("=>清除完成")

--[[
		 put it into the connection pool of size 100,
                -- with 10 seconds max idle time
                local ok, err = red:set_keepalive(10000, 100)
]]--
  red:set_keepalive(0,100)  
  --red:close()  
end


_M.resetCookie=function(session_id)
  zjexUtil.debug("设置session_id:"..session_id.." =clear;HttpOnly") 
  ngx.header["Set-Cookie"]= { init_cfg.session_cookie_name.."=" .. "clear" .. ';path=/;HttpOnly'}		
end



--redis get*****************************************************************
function _M.getSession(session_id,key)
  zjexUtil.debug("getSession: "..session_id.." key "..key) 
  local value = nil  
  local red = redis:new()  
  local host =  init_cfg.redis_ip
  local port =  init_cfg.redis_port
  red:set_timeout(1000) -- 1 sec
  local ok,err = red:connect(host,port)
  if not ok then  
    zjexUtil.return_not_connect_redis("sdk_session.getSession() please make sure redis is on,redis connect "..(err or "@empty") )
  end  
  --instance:set("name","gao");  
  -- value = red:get(key)  or "nil"

--hget,hset每次只能处理一个 key,value  hmget,hmset则能一次设置多个key

  local redis_key = _M.session_redis_key_prefix..session_id 
  local res, err = red:hget( redis_key,key )
  if not res  or res == ngx.null  then
    -- zjexUtil.debug("key:"..key.." not found.")
    -- zjexUtil.return_not_connect_redis("key:"..key.." not found.")
    --  return
  end

  value = res

  if value and tostring(value) == "userdata: NULL" then
    value = nil
  else
    red:expire(redis_key,init_cfg.expire_timeout_second) --1000 - 1sec
    zjexUtil.debug("getSession redis:expire("..redis_key..","..init_cfg.expire_timeout_second.." second)")
  end

  red:set_keepalive(0,100)
  --red:close()  

  return value 
end



function _M.setLoginUserSession(session_id,token_info_str,login_name,isLogin)

  --local config = ngx.shared.config;  
  local red = redis:new();  
  --local host = config:get("host");  
  --local port = config:get("port");  
  local host =  init_cfg.redis_ip
  local port =  init_cfg.redis_port
  red:set_timeout(1000) -- 1 sec
  local ok,err = red:connect(host,port)
  if not ok then  
    zjexUtil.return_not_connect_redis("sdk_session.setLoginUserSession() please make sure redis is on,redis connect "..(err or "@empty") )
  end  


  local token_info = zjexUtil.jsonStringToObject( token_info_str)
  local private_access_token = token_info.access_token


  local redis_key = _M.session_redis_key_prefix..session_id 
  red:init_pipeline()
  ok, err = red:hset( redis_key,"token_info" , token_info_str)
  ok, err = red:hset( redis_key,"access_token" , private_access_token)
  ok, err = red:hset( redis_key, "login_name" , login_name or "")
  ok, err = red:hset( redis_key, "isLogin" , isLogin or "")	

  local results, err = red:commit_pipeline()
  if not results then
    --  zjexUtil.debug("failed to commit the user session pipelined requests: ", err)
  end
  red:expire(redis_key,init_cfg.expire_timeout_second) --1  - 1sec
  zjexUtil.debug("setLoginUserSession redis:expire("..redis_key..","..init_cfg.expire_timeout_second.." second)")

  red:set_keepalive(0,100)
  --red:close()  

  return value 
end

--生成cookie中的zjex_sign_id, HttpOnly*****************************************************************************
_M.getSessionID=function()
  local esisted = false
  local new_zjex_sign_id = nil

  local get_zjex_sign_id   =  init_cfg.getSessionIdFromCookie()


  local user_ip_route = "";

  local user_ip  = ngx.req.get_headers()["X-Real-IP"]
  user_ip_route = user_ip_route .." X-Real-IP:"..(user_ip or "@empty")   
  if user_ip == nil then
    user_ip = ngx.req.get_headers()["x_forwarded_for"]
    user_ip_route = user_ip_route .." x_forwarded_for:"..(user_ip or "@empty")  
  end
  if user_ip == nil then
    user_ip = ngx.var.remote_addr
    user_ip_route = user_ip_route .." remote_addr:"..(user_ip or "@empty")   
  end

  zjexUtil.debug("=== "..(user_ip_route or "@empty")  )

--ngx.var.http_user_agent  
--如360的浏览器能在IE和webkit之前切换，useragent会发生变化，故校验部分去掉useragent
  local zjex_sign_id_md5_part = string.upper(ngx.md5( user_ip ) )

  if   get_zjex_sign_id  and get_zjex_sign_id ~= "clear" then  

    --return true,get_zjex_sign_id,nil

    --存在此cookie的前提下，继续比较前半部分的签名是否一致

    local from = ngx.re.find( get_zjex_sign_id, "-")
    if from then
      --[[ 
		 				 local md5_sign = string.sub( get_zjex_sign_id, 1,from-1)		 				 
		                 if md5_sign == zjex_sign_id_md5_part then
								return true,get_zjex_sign_id,nil
					     else
		                        return false,"","cookie签名不一致(本次请求获取的客户IP与之前记录的IP不一致)，基于安全考虑，本次请求不受理,建议清理浏览器缓存或重启浏览器再试"
		                 end
		                 ]]--
      return true,get_zjex_sign_id,nil   
    else
      return false,"","cookie签名格式不正确，基于安全考虑，本次请求不受理,请清理浏览器缓存或重启浏览器再试"	
    end



  else

    local zjex_sign_id_timestamp = string.upper(ngx.md5(tostring( ngx.now() ) )	)			 
    new_zjex_sign_id = zjex_sign_id_md5_part.."-"..zjex_sign_id_timestamp 

    ngx.header["Set-Cookie"]= { init_cfg.session_cookie_name.."=" .. new_zjex_sign_id .. ';path=/;HttpOnly'}		

    --  ngx.header['Set-Cookie'] = {'a=32; path=/', 'b=4; path=/'}

    return false,new_zjex_sign_id,nil		
  end


  return false,"解析生成cookie签名异常,请清理浏览器缓存或重启浏览器再试",nil


end




--****************************************************************************************************************
--****************************************************************************************************************
return _M

