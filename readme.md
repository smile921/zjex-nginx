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
