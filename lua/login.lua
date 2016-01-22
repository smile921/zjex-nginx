 
  local json_parser = require "json_parser"
  local auth2 = require "auth2"  
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
  conf.args = args;


  args.method = request_method;
  ngx.say( json_parser.encode( args ))
