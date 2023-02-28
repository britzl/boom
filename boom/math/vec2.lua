local M = {}

local function new(x, y)
	x = x or 0
	y = y or x
	return vmath.vector3(x, y, 0)
end

M.UP = new(0, 1)
M.DOWN = new(0, -1)
M.LEFT = new(-1, 0)
M.RIGHT = new(1, 0)

return setmetatable(M, {
	_call = function(t, ...)
		return new(...)
	end
})