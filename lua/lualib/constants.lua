local VERSION = "1.0"

return {
  NAME = "zjex.oauth2.sdk",
  VERSION = VERSION,
  ROCK_VERSION = VERSION.."-1",
  DATABASE_ERROR_TYPES = setmetatable ({
    SCHEMA = "schema",
    INVALID_TYPE = "invalid_type",
    DATABASE = "database",
    UNIQUE = "unique",
    FOREIGN = "foreign"
  }, { __index = function(t, key)
                    local val = rawget(t, key)
                    if not val then
                       error("'"..tostring(key).."' is not a valid errortype", 2)
                    end
                    return val
                 end
              }),
  -- Non standard headers, specific to Kong
  HEADERS = {
    HOST_OVERRIDE = "X-Host-Override",
    PROXY_TIME = "X-Kong-Proxy-Time",
    API_TIME = "X-Kong-Api-Time",
    CONSUMER_ID = "X-Consumer-ID",
    CONSUMER_CUSTOM_ID = "X-Consumer-Custom-ID",
    CONSUMER_USERNAME = "X-Consumer-Username",
    CREDENTIAL_USERNAME = "X-Credential-Username",
    RATELIMIT_LIMIT = "X-RateLimit-Limit",
    RATELIMIT_REMAINING = "X-RateLimit-Remaining"
  },
  GRANT_TYPE = {
      GRANT_AUTHORIZATION_CODE = "authorization_code",  -- /token grant_type=authorization_code 
      GRANT_CLIENT_CREDENTIALS = "client_credentials",  -- /token grant_type=client_credentials
      GRANT_REFRESH_TOKEN = "refresh_token",            -- /token grant_type=refresh_token
      GRANT_PASSWORD = "password",                      -- /token grant_type=password
      GRANT_IMPLICIT = "implicit"                       -- /token grant_type=implicit   
  },
  AUTHENTICATION = {
      CONTENT_LENGTH = "content-length",
      RESPONSE_TYPE = "response_type",
      STATE = "state",
      CODE = "code",
      TOKEN = "token",
      REFRESH_TOKEN = "refresh_token",
      SCOPE = "scope",
      CLIENT_ID = "client_id",
      CLIENT_SECRET = "client_secret",
      REDIRECT_URI = "redirect_uri",
      ACCESS_TOKEN = "access_token",
      GRANT_TYPE = "grant_type",
      AUTHENTICATED_USERID = "authenticated_userid",
      AUTHORIZE_URL = "^%s/oauth/authorize/?$",
      TOKEN_URL = "^%s/oauth/token/?$", 
     
      AUTHORIZATION_CODE_URL = "code"  -- response_type=code /authrize
  },
  LOG_LEVEL = {
  INFO = ngx.INFO ,
  ERR = ngx.ERR,
  DEBUG = ngx.DEBUG,
  WARN = ngx.WARN
  },
  PUBLIC_TOKEN="zjex_public_token",
  PUBLIC_REFRESH_TOKEN="zjex_refresh_token",
  USER_ACCESS_TOKEN="user_access_token" 
}
