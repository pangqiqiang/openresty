local redis = require "resty.redis_iresty"
local red = redis:new({timeout=1000})



local func  = red:subscribe( "channel" )

if not func then
  return nil
end

while true do
    local res, err = func()
    if err then
        func(false)
    end
    ngx.log(ngx.ERR,tostring(res[3]))
end