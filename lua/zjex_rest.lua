  local json_parser = require "json_parser";
  local oauth2 = require "oauth2";  
  local constants = require "constants";
  local redis_cluster = require "redis_cluster";
  local sessionzj = require("zjsession");
  local init_cfg = require("init_cfg")
  local stringy = require "stringy";
  local resty_string = require ("resty.string");

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
  local token = redis_cluster.getSession(sessionid,constants.PUBLIC_TOKEN);
  local access_token = redis_cluster.getSession(sessionid,constants.USER_ACCESS_TOKEN);
  if not access_token and not token then  
    argsv.client_id= init_cfg.client_id;
    argsv.client_secret = init_cfg.client_secret;
    argsv.redirect_uri = init_cfg.redirect_uri;
    conf.args = argsv;
    conf.grant_type = constants.GRANT_TYPE.GRANT_CLIENT_CREDENTIALS;
    local authObj,err,tokenLenth = oauth2.get_token_by_type(conf,conf.grant_type)
    if authObj then
      token = authObj.access_token;
      redis_cluster.setSession(sessionid,constants.PUBLIC_TOKEN,token);
    end        
  end
  if   access_token   then
     token = access_token;
  end
  args.token = token;    
  -- 调用api不成功，可根据错误信息，判断是否刷新token或者跳转到登录页面
  local api_params =json_parser.encode( args );
  --ngx.log(ngx.DEBUG,api_params);
  local request_uri = ngx.var.request_uri;
  request_uri = ngx.unescape_uri(request_uri)
  local endPos = stringy.find(request_uri,"?");
  local base = string.sub(request_uri,1,endPos-1);
  local path ="/gateway_api/api/";
  path = string.gsub(base,"/zjex_rest",path,1);
  local response = nil;
  if "GET" == request_method then
    -- TODO 把get请求的参数拼接到path后面，拼接token参数，参数需要编码
    uriArgs = sessionzj.prepareArgs(args);
    uriArgs = sessionzj.encodeURI(uriArgs);
    path = path .. "?" .. uriArgs;
    ngx.log(ngx.DEBUG,path);
    response = ngx.location.capture( path,{ 
                                     method = ngx.HTTP_GET
                                     }
                                    );  
  elseif "POST" == request_method then
    response = ngx.location.capture( path,{ 
                                     method = ngx.HTTP_POST,
                                     body = ngx.encode_args(api_params)   --must be string
                                     }
                                    );  
  end
  if response and response.status == 200 then
    --todo 
    ngx.say(response.body)
  end