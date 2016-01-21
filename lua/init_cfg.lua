
local cfg = { }


-- 10.24
--cfg.client_id = "2093412c1c992aac9fb3431763158958a5598c789260"
--cfg.client_secret = "F6CA4BCA4A06B9383A20938CE76FF163FEE1CDAC4BDAA26B1703DEA5DCF01CBF"

--  apiKey = androidtest
--  apiSecret = androidsecret
--  token = xxxx
--  signSecret = xxx
--   回调地址 https://baidu.com
--   http://10.88.1.207:8900/oauth/authorize?client_id=androidtest&response_type=code&redirect_uri=https%3A%2F%2Fbaidu.com
--   http://10.88.1.207:8900/oauth/token?grant_type=authorization_code&client_id=androidtest&client_secret=androidsecret&redirect_uri=https%3A%2F%2Fbaidu.com&code=k2Aa4q
--   http://10.88.1.207:8900/oauth/token?grant_type=refresh_token&client_id=androidtest&client_secret=androidsecret&refresh_token=5774421e-196a-4846-b948-5899047940de
cfg.client_id="androidtest1"
cfg.client_secret="androidsecret1"
cfg.response_type="code"
cfg.redirect_uri="http://10.88.1.215:9988"
cfg.gateway_server="http://10.88.1.207:8900"
cfg.grant_type = "authorization_code" 
cfg.grant_type_password = "password"



cfg.redis_ip = "10.88.1.214"
cfg.redis_port = "7030"
cfg.expire_timeout_second = 600  -- 1 = 1 sec   600 = 10分钟 redis中数据有效时间




cfg.session_cookie_name = "k_d_0_618_n_l_j_g_s_s"
cfg.getSessionIdFromCookie=function()
  --	return ngx.var.cookie__encrypt_sign
  return ngx.var["cookie_"..cfg.session_cookie_name]
end
--ngx.var.cookie_xxxx 跟 cfg.session_cookie_name = "xxxx" 保持一致



--[[
    页面是否需要登录的规则:
    1.访问的uri中包含/auth/
    2.cfg.page_need_login_list中指定的uri
]]--
cfg.page_need_login_list = ","

cfg.page_need_login_list = cfg.page_need_login_list .. "/account.html,"
cfg.page_need_login_list = cfg.page_need_login_list .. "/person/project_apply.html,"
cfg.page_need_login_list = cfg.page_need_login_list .. "/person/project_expand.html,"
cfg.page_need_login_list = cfg.page_need_login_list .. "/person/project_relevance.html,"
cfg.page_need_login_list = cfg.page_need_login_list .. "/subscribe_claims.html,"
cfg.page_need_login_list = cfg.page_need_login_list .. "/subscribe_claims_payment.html,"
cfg.page_need_login_list = cfg.page_need_login_list .. "/subscribe_turn.html,"
cfg.page_need_login_list = cfg.page_need_login_list .. "/subscribe_turn_payment.html,"
cfg.page_need_login_list = cfg.page_need_login_list .. "/subscribe.html,"

--**************************************************************





--http://192.168.10.24:8991/  开放平台
cfg.oauth_login_api_name = "zjex.kifp.get_cust_login"
cfg.oauth_login_api_version = "v1.0"
cfg.oauth_login_api_version_admin="v1.1"
cfg.oauth_login_api_name_admin="zjex.kifp.org_seller_login"



--将返回 的json数据缓存于redis中的api 列表
cfg.cache_data_api_list={
  "api11111111111111",
  "api222222222222222",
  "api333333333333333"
}


cfg.debug_level="debug"

cfg.ssologin ={ }



---
--http://10.88.1.207:8900/oauth/authorize?client_id=androidtest1&response_type=code&redirect_uri=http%3A%2F%2F10.88.1.215:9988
--http://10.88.1.207:8900/oauth/token?grant_type=authorization_code&client_id=androidtest1&client_secret=androidsecret1&redirect_uri=http%3A%2F%2F10.88.1.215:9988&code=C3hNKL
--http://10.88.1.207:8900/oauth/token?grant_type=refresh_token&client_id=androidtest1&client_secret=androidsecret1&refresh_token=5774421e-196a-4846-b948-5899047940de
---
--*******************************************************************************
return cfg