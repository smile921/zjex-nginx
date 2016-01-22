# use nginx with lua script supported 

  compile nginx with lua module and enable oauth2 client support
# opensource libs
1.  lubyk/yaml
2.  brentp/lua-stringy
3.  Tieske/uuid




##  document for libs yaml
local data = yaml.load(some_yaml)

local yaml_string = yaml.dump(some_table)
## document for libs uuid
local uuid = require("uuid")
 print("here's a new uuid: ",uuid())

 local socket = require("socket")  -- gettime() has higher precision than os.time()
 local uuid = require("uuid")
 -- see also example at uuid.seed()
 uuid.randomseed(socket.gettime()*10000)
 print("here's a new uuid: ",uuid())

 # test 

1.  http://10.88.1.215:9988/getTokenClientCredentials?a=b
2.  http://10.88.1.215:9988/getTokenUserNamePassword?username=frere&password=3t4u2g3j4h
3.  http://10.88.1.215:9988/getTokenAuthorizationCode?code=123456
4.  http://10.88.1.215:9988/getTokenRefresh?refresh_token=133fc2ea-3901-495b-91e6-e144615a31a2
  