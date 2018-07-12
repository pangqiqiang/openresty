local redis = require "resty.redis"
local red = redis:new()
red:set_timeout(1000) --1sec

local ok, err = red:connect("127.0.0.1", 6379)
if not ok then
	ngx.say("failed to connect ", err)
	return
end

--auth
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


ok, err = red:set("dog", "an animal")
if not ok then
	ngx.say("failed to set dog: ", err)
	return
end
ngx.say("set result: ", ok)

local value
value, err = red:get("dog")
if value then
	ngx.say("get key dog's value: ", value)
elseif err then
	ngx.say("failed to get key dog's value: ", err)
	return
end

 -- 连接池大小是100个，并且设置最大的空闲时间是 10 秒
local ok, err = red:set_keepalive(10000, 100)
if not ok then
	ngx.say("fail to set keepalive: ", err)
	return
end