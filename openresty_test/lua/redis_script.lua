local redis = require "resty.redis"
local red = redis:new()

red:set_timeout(1000) -- 1 sec

-- or connect to a unix domain socket file listened
-- by a redis server:
--     local ok, err = red:connect("unix:/path/to/redis.sock")

local ok, err = red:connect("127.0.0.1", 6379)
if not ok then
	ngx.say("failed to connect: ", err)
	return
end

--- use scripts in eval cmd
local id = 1
local res, err = red:eval([[
	-- 注意在 Redis 执行脚本的时候，从 KEYS/ARGV 取出来的值类型为 string
	local info = redis.call('get', KEYS[1])
	info = cjson.decode(info)
	local g_id = info.gid

	local g_info = redis.call('get', g_id)
	return g_info
	]], 1, id)

if not res then
   ngx.say("failed to get the group info: ", err)
   return
end

ngx.say(res)

-- put it into the connection pool of size 100,
-- with 10 seconds max idle time
local ok, err = red:set_keepalive(10000, 100)
if not ok then
	ngx.say("failed to set keepalive: ", err)
	return
end

-- or just close the connection right away:
-- local ok, err = red:close()
-- if not ok then
--     ngx.say("failed to close: ", err)
--     return
-- end