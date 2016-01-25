local init_cfg = require("init_cfg")
local json     = require ("cjson")
local redis = require ("resty.redis")
local redis_cluster = require "redis_cluster";

ngx.log(ngx.DEBUG,"redis_cluster ".. type(redis_cluster))
redis_cluster.setSession("abced","hello1","hello");
ngx.say("<br" .. (redis_cluster.getSession("abced","hello1") or "error ") .."<br>")

 
  

  ngx.say("<br><br><br><br><br><br><br><br><br><br><br><br>");

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




--****************************************************************************************************************
return _M

