local init_cfg = require("init_cfg")
local json     = require ("cjson")
local redis = require ("resty.redis")
local json_parser = require "json_parser"
local oauth2 = require "oauth2"  
local constants = require "constants"

local request_method = ngx.var.request_method;
local args=nil;   
----获取参数的值
if "GET" == request_method then
   args = ngx.req.get_uri_args();
elseif "POST" == request_method then
   ngx.req.read_body();
   args = ngx.req.get_post_args()
end
local conf = {};
args.client_id= init_cfg.client_id;
args.client_secret = init_cfg.client_secret;
args.redirect_uri = init_cfg.redirect_uri;
conf.args = args;
conf.grant_type = constants.GRANT_TYPE.GRANT_REFRESH_TOKEN;
local a,b,c = oauth2.get_token_by_type(conf,conf.grant_type)
if a then
  ngx.say("access_token : " .. a.access_token)
  if c == 2 then
     ngx.say("refresh_token : " .. a.refresh_token)
  end
end
if b then
 ngx.say(table.concat( b, " ::: " ))
end 

  ngx.say("<br><br><br><br><br><br><br><br><br><br><br><br>");

local _M = {}
--********************************************
 

--****************************************************************************************************************
return _M

