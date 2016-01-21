  local json.util = require("json.util")

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
  ngx.say( json.util.encode( args ))
