local M = {}

function M.rand(a, b)
	local r = math.random()
	if not a then return r end
	if not b then return r * a end
	return (r * (b - a + 1)) + a
end

function M.randi(a, b)
	return math.floor(M.rand(a, b))
end

return M