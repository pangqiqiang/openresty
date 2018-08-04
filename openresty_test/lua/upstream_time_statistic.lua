local log_dict = ngx.shared.log_dict
local upstream_time = tonumber(ngx.var.upstream_response_time)
local sum = log_dict:get("upstream_time-sum") or 0
sum = sum + upstream_time
log_dict:set("upstream_time-sum", sum)

local newval, err = log_dict:incr("upstream_time-nb", 1)
if not newval and err == "not found" then
	log_dict:add("upstream_time-nb", 0)
	log_dict:incr("upstream_time-nb", 1)
end
	