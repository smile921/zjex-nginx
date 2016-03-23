local stringy = require "stringy"
local constants = require "constants"
local json_parser = require "json_parser"

local _M = {}

local function parseTokenResponse( response )
   -- extract token from response
   local authObj = nil;
   local err = nil;
   local return_type  = 0;
   if response and response.status == 200 then
      local zjexJson = response.body;
      authObj = json_parser.decode( zjexJson)
      access_token  = authObj.access_token
      if access_token then
        return_type = 1;
      else
        return_type= -1;
      end
      refresh_token = authObj.refresh_token
      if refresh_token then
         return_type = 2;
      end
      return authObj,err,return_type;
   end
end 
-- local CONTENT_LENGTH = "content-length"
-- local RESPONSE_TYPE = "response_type"
-- local STATE = "state"
-- local CODE = "code"
-- local TOKEN = "token"
-- local REFRESH_TOKEN = "refresh_token"
-- local SCOPE = "scope"
-- local CLIENT_ID = "client_id"
-- local CLIENT_SECRET = "client_secret"
-- local REDIRECT_URI = "redirect_uri"
-- local ACCESS_TOKEN = "access_token"
-- local GRANT_TYPE = "grant_type"
-- local GRANT_AUTHORIZATION_CODE = "authorization_code"  -- /token grant_type=authorization_code 
-- local GRANT_CLIENT_CREDENTIALS = "client_credentials"  -- /token grant_type=client_credentials
-- local GRANT_REFRESH_TOKEN = "refresh_token"            -- /token grant_type=refresh_token
-- local GRANT_PASSWORD = "password"                      -- /token grant_type=password
-- local ERROR = "error"
-- local AUTHENTICATED_USERID = "authenticated_userid"
-- local AUTHORIZE_URL = "^%s/oauth/authorize/?$"
-- local TOKEN_URL = "^%s/oauth/token/?$" 
-- local GRANT_IMPLICIT = "implicit"   -- /token grant_type=implicit   
-- local AUTHORIZATION_CODE_URL = "code"  -- response_type=code /authrize
  
-- 获取token  
local function get_token_by_type(conf,gtant_type)
   ngx.log(ngx.DEBUG,gtant_type)
   local suffix = "?"
   if gtant_type and gtant_type == constants.GRANT_TYPE.GRANT_CLIENT_CREDENTIALS then
      args = conf.args;
      suffix = suffix .. constants.AUTHENTICATION.GRANT_TYPE .."=" .. gtant_type
      suffix = suffix .. "&" .. constants.AUTHENTICATION.CLIENT_ID .. "=" .. args[constants.AUTHENTICATION.CLIENT_ID]
      suffix = suffix .. "&" .. constants.AUTHENTICATION.CLIENT_SECRET .. "=" .. args[constants.AUTHENTICATION.CLIENT_SECRET]
      suffix = suffix .. "&" .. constants.AUTHENTICATION.REDIRECT_URI .. "=" .. args[constants.AUTHENTICATION.REDIRECT_URI]
   elseif gtant_type and gtant_type == constants.GRANT_TYPE.GRANT_PASSWORD then
      args = conf.args;
      suffix = suffix .. constants.AUTHENTICATION.GRANT_TYPE .."=" .. gtant_type
      suffix = suffix .. "&" .. constants.AUTHENTICATION.CLIENT_ID .. "=" .. args[constants.AUTHENTICATION.CLIENT_ID]
      suffix = suffix .. "&" .. constants.AUTHENTICATION.CLIENT_SECRET .. "=" .. args[constants.AUTHENTICATION.CLIENT_SECRET]
      suffix = suffix .. "&" .. constants.AUTHENTICATION.REDIRECT_URI .. "=" .. args[constants.AUTHENTICATION.REDIRECT_URI]
      suffix = suffix .. "&" .. "username" .. "=" .. args["username"]
      suffix = suffix .. "&" .. "password" .. "=" .. args["password"]     
   elseif gtant_type and gtant_type == constants.GRANT_TYPE.GRANT_AUTHORIZATION_CODE then
      args = conf.args;
      suffix = suffix .. constants.AUTHENTICATION.GRANT_TYPE .."=" .. gtant_type;
      suffix = suffix .. "&" .. constants.AUTHENTICATION.CLIENT_ID .. "=" .. args[constants.AUTHENTICATION.CLIENT_ID]
      suffix = suffix .. "&" .. constants.AUTHENTICATION.CLIENT_SECRET .. "=" .. args[constants.AUTHENTICATION.CLIENT_SECRET]
      suffix = suffix .. "&" .. constants.AUTHENTICATION.REDIRECT_URI .. "=" .. args[constants.AUTHENTICATION.REDIRECT_URI]
      suffix = suffix .. "&" .. constants.AUTHENTICATION.CODE .. "=" .. args[constants.AUTHENTICATION.CODE] 
   elseif gtant_type and gtant_type == constants.GRANT_TYPE.GRANT_IMPLICIT then
      args = conf.args;
      suffix = suffix .. constants.AUTHENTICATION.GRANT_TYPE .."=" .. gtant_type;
      suffix = suffix .. "&" .. constants.AUTHENTICATION.CLIENT_ID .. "=" .. args[constants.AUTHENTICATION.CLIENT_ID]
      suffix = suffix .. "&" .. constants.AUTHENTICATION.CLIENT_SECRET .. "=" .. args[constants.AUTHENTICATION.CLIENT_SECRET]
      suffix = suffix .. "&" .. constants.AUTHENTICATION.REDIRECT_URI .. "=" .. args[constants.AUTHENTICATION.REDIRECT_URI]
      suffix = suffix .. "&" .. constants.AUTHENTICATION.CODE .. "=" .. args[constants.AUTHENTICATION.CODE] 
   elseif gtant_type and gtant_type == constants.GRANT_TYPE.GRANT_REFRESH_TOKEN then
      args = conf.args;
      suffix = suffix .. constants.AUTHENTICATION.GRANT_TYPE .."=" .. gtant_type;
      suffix = suffix .. "&" .. constants.AUTHENTICATION.CLIENT_ID .. "=" .. args[constants.AUTHENTICATION.CLIENT_ID]
      suffix = suffix .. "&" .. constants.AUTHENTICATION.CLIENT_SECRET .. "=" .. args[constants.AUTHENTICATION.CLIENT_SECRET]
      suffix = suffix .. "&" .. constants.AUTHENTICATION.REDIRECT_URI .. "=" .. args[constants.AUTHENTICATION.REDIRECT_URI]
      suffix = suffix .. "&" .. constants.AUTHENTICATION.REFRESH_TOKEN .. "=" .. args[constants.AUTHENTICATION.REFRESH_TOKEN] 
   end
   --    现在参数已经准备好了，请求获取token
   --  /gateway_token  /oauth/token
   local auth2_nginx_url = "/gateway_token" .. suffix;
   ngx.req.set_header("Content-Type", "application/json;charset=utf8");
   ngx.req.set_header("Accept", "application/json");
   local response = ngx.location.capture(auth2_nginx_url);
   ngx.log(ngx.DEBUG,auth2_nginx_url)
   return  parseTokenResponse(response);
end



-- 授权码模式获取授权码的重定向地址
local function  get_redirect_uri(client_id)
   
end

 

   _M.get_token_by_type = get_token_by_type;
   _M.get_redirect_uri = get_redirect_uri;
return _M
