local log_dict = ngx.shared.log_dict
local sum = log_dict:get("upstream_time-sum")
local nb = log_dict:get("upstream_time-nb")
if nb and sum then
	ngx.say("average upstream response time: ",
		sum/nb, "(", nb, " reqs)")
else
	ngx.say("no data yet")
end
