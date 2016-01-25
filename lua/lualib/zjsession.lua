
local _M = {};
local session_cookie_name="z_2_j_0_e_1_x_6_o_0_p_2_e_9_n";
local function getSessionIdFromCookie()
    --  return ngx.var.cookie__encrypt_sign
    return ngx.var["cookie_"..session_cookie_name]
end
    --ngx.var.cookie_xxxx 跟 cfg.session_cookie_name = "xxxx" 保持一致

local function getSessionId()
  local esisted = false
  local new_sign_id = nil
  local get_sign_id   =  getSessionIdFromCookie();
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
 
  --ngx.var.http_user_agent  
  --如360的浏览器能在IE和webkit之前切换，useragent会发生变化，故校验部分去掉useragent
  local sign_id_md5_part = string.upper(ngx.md5( user_ip ) )
  if   get_sign_id  and get_sign_id ~= "clear" then  
     --存在此cookie的前提下，继续比较前半部分的签名是否一致
    local from = ngx.re.find( get_sign_id, "-")
    if from then
       return true,get_sign_id,nil   
    else
      return false,"","cookie签名格式不正确，基于安全考虑，本次请求不受理,请清理浏览器缓存或重启浏览器再试" 
    end
  else
    local sign_id_timestamp = string.upper(ngx.md5(tostring( ngx.now() ) )  )      
    new_sign_id = sign_id_md5_part.."-"..sign_id_timestamp 
    ngx.header["Set-Cookie"]= { session_cookie_name.."=" .. new_sign_id .. ';path=/;HttpOnly'}   
    --  ngx.header['Set-Cookie'] = {'a=32; path=/', 'b=4; path=/'}
    return false,new_sign_id,nil    
  end
  return false,"解析生成cookie签名异常,请清理浏览器缓存或重启浏览器再试",nil
end

local function copyTab(st)
    local tab = {}
    for k, v in pairs(st or {}) do
        if type(v) ~= "table" then
            tab[k] = v
        else
            tab[k] = copyTab(v)
        end
    end
    return tab
end

_M.copyTab = copyTab;
_M.session_cookie_name =session_cookie_name;
_M.getSessionId =  getSessionId;
return _M;