local _M = {}

function _M.isNumber(...)
	local args = {...}
	for _, v in pairs(args) do
		num = tonumber(v)
		if num == nil then
			return false
		end
	end
	return true
end


return _M