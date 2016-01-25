  local json_parser = require "json_parser";
  local oauth2 = require "oauth2";  
  local constants = require "constants";
  local redis_cluster = require "redis_cluster";
  local sessionzj = require("zjsession");

  local request_method = ngx.var.request_method;
  local args=nil;   
  ----获取参数的值
  if "GET" == request_method then
     args = ngx.req.get_uri_args();
  elseif "POST" == request_method then
     ngx.req.read_body();
     args = ngx.req.get_post_args()
  end
  args.method = request_method;
  local sessionid = sessionzj.getSessionId();
  ngx.log(ngx.DEBUG,"session id = "..( sessionid or "nil"))

  local conf = {};
  local token = redis_cluster.getSession(sessionid,constants.PUBLIC_TOKEN);
  if not token then  
    args.client_id= init_cfg.client_id;
    args.client_secret = init_cfg.client_secret;
    args.redirect_uri = init_cfg.redirect_uri;
    conf.args = args;
    conf.grant_type = constants.GRANT_TYPE.GRANT_CLIENT_CREDENTIALS;
    local authObj,err,tokenLenth = oauth2.get_token_by_type(conf,conf.grant_type)
    if authObj then
      token = authObj.access_token;
      redis_cluster.setSession(sessionid,constants.PUBLIC_TOKEN,token);        
  end
  args.token=token;  
  ngx.say( json_parser.encode( args ))
   
