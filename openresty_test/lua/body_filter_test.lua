
--[[ ##encounter hello,the following drop

local chunk = ngx.arg[1]
if string.match(chunk, "hello") then
	ngx.arg[2] = true  --new eof
	return
end
ngx.argp[1] = nil


--]]



-- just throw away any remaining chunk data
--When the Lua code may change the length of the response body, 
--then it is required to always clear out the Content-Length 
--response header (if any) in a header filter to enforce 
--streaming output

ngx.arg[1] = string.len(ngx.arg[1]) .. "\n"