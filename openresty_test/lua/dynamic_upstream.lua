local _M = { _VERSION = '1.0' }
function _M.capture_test()
    local res = ngx.location.capture("/upstream",
        {
            method = ngx.HTTP_GET,
            vars = {
                my_upstream = "remote_hello",
                my_uri = "/hello"
            },
		}
	)
	if res == nil or res.status ~= ngx.HTTP_OK then
		ngx.say("capture failed")
		return
	end
	ngx.say(res.body)
end

function _M.exec_test()
	ngx.var.my_upstream = "remote_world"
	ngx.var.my_uri = "/world"
	ngx.exec("/upstream")
end

return _M
