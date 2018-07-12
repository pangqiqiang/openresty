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

--initial pipeline
red:init_pipeline()
red:set("cat", "Marry")
red:set("horse", "Bob")
red:get("horse")
red:get("cat")
--commit the pipeline
local results
results, err = red:commit_pipeline()
if not results then
	ngx.say("failed  to commit the pipelined results: ", err)
	return
end

for i, res in ipairs(results) do
	if type(res) == "table" then
		if not res[1] then 
			ngx.say("failed to run command ", i, ": ", res[2])
		else
			ngx.say(res[1], " => ", res[2])
		end
	else
		-- process the scalar value
		ngx.say(res)
	end
end

-- put it into the connection pool of size 100,
-- with 10 seconds max idle time
ok, err = red:set_keepalive(10000, 100)
if not ok then
	ngx.say("failed to set_keepalive: ", err)
	return
end
	
