local redis = require "resty.redis"
local red = redis:new()
red:settimeout(1000)
-- or connect to a unix domain socket file listened
-- by a redis server:
--  local ok, err = red:connect("unix: /path/to/redis.sock")
local ok, err = red:connect("127.0.0.1", 6379)
if not ok then
	ngx.say("failed to connect to the redis server")
	return
end

--anth
local count
count, err = red:get_reused_times()
if count == 0 then
	ok, err = red:auth("123456")
	if not ok then
		ngx.say("failed to auth: ", err)
		return
	end
elseif err then
	ngx.say("failed to get count: ", err)
	return
end

ok, err = red:set("cat", "Merry")
if not ok then
	ngx.say("set cat key err: ", err)
	return
end
ngx.say("set result: ", ok)

local res
res, err = red:get("cat")
if err then
	ngx.say("get cat value err: ", err)
end
ngx.say("cat: ", res)

ok, err = red:set("horse", "Bob")
if not ok then
	ngx.say("set horse key err: ", err)
	return
end
ngx.say("set result: ", ok)


res, err = red:get("horse")
if err then
	ngx.say("get horse value err: ", err)
end
ngx.say("horse: ", res)


-- put it into the connection pool of size 100,
-- with 10 seconds max idle time
ok, err = red:set_keepalive(10000, 100)
if not ok then
	ngx.say("failed to set_keepalive: ", err)
	return
end

