local M = {}

function M.make(t, fn)
	local mt = getmetatable(t)
	if not mt then mt = {} end

	assert(not mt.__call, "Table already has a __call metamethod")
	mt.__call = function(t, ...)
		return fn(...)
	end

	return setmetatable(t, mt)
end

return M