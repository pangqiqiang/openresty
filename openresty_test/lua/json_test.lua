
local json = require "cjson"
--稀疏数组会被处理为object

json.encode_sparse_array(true)

local function _json_encode(data)
	return json.encode(data)
end

local function json_encode(data, empty_table_as_object)
	--Lua的数据类型里面，array和dict是同一个东西。
	--对应到json encode 就会有不同的判断
	json.encode_empty_table_as_object(empty_table_as_object or false)  --空table默认为array
	local ok, json_value = pcall(_json_encode, data)
	if  not ok then
		return nil
	end
	return json_value
end

local arr = {1, 3, 5}
arr[1000] = 999
ngx.say(json_encode(arr))

ngx.say("value --> ", json_encode({dogs={}}, true))
ngx.say("value --> ", json_encode({dogs={}}))

