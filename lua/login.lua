  local json_parser = require "json_parser";
  local oauth2 = require "oauth2";  
  local constants = require "constants";
  local redis_cluster = require "redis_cluster";
  local sessionzj = require("zjsession");
  local init_cfg = require("init_cfg")

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
  local argsv = sessionzj.copyTab(args);
  local isGot,sessionid = sessionzj.getSessionId();
  ngx.log(ngx.DEBUG,"session id = "..( sessionid or "nil"))

  local conf = {};
  local token = redis_cluster.getSession("sessionid",constants.PUBLIC_TOKEN);    
  argsv.client_id= init_cfg.client_id;
  argsv.client_secret = init_cfg.client_secret;
  argsv.redirect_uri = init_cfg.redirect_uri;
  conf.args = argsv;
  conf.grant_type = constants.GRANT_TYPE.GRANT_PASSWORD;
  local authObj,err,tokenLenth = oauth2.get_token_by_type(conf,conf.grant_type)
  if authObj then
    token = authObj.access_token;
    redis_cluster.setSession(sessionid,constants.USER_ACCESS_TOKEN,token);
    if tokenLenth == 2 then
       local refresh_token = authObj.refresh_token;
       redis_cluster.setSession(sessionid,constants.KEY_REFRESH_TOKEN,refresh_token);
       ngx.log(ngx.DEBUG,"refresh_token"..refresh_token);
    end
    ngx.log(ngx.DEBUG,"access_token = "..token)
    local datas = {};
    datas.flag = "true";
    datas.message = "login success!";
    local data = json_parser.encode(datas)
    ngx.say(data);
    return;
  else
    local datas = {};
    datas.flag = "false";
    datas.message = json_parser.encode(err);
    local data = json_parser.encode(datas)
    ngx.say(data);
    return;
  end        
  
  --args.token=token;  
  --ready to call login
  --ngx.say( json_parser.encode( args ))
  
   
