local M = {}

local vec2 = {}

local function new(x, y)
	if type(x) == "userdata" then
		return vmath.vector3(x)
	end
	x = x or 0
	y = y or x
	return vmath.vector3(x, y, 0)
end

vec2.UP = new(0, 1)
vec2.DOWN = new(0, -1)
vec2.LEFT = new(-1, 0)
vec2.RIGHT = new(1, 0)

local mt = {
	__call = function(t, ...)
		return new(...)
	end
}

M.vec2 = setmetatable(vec2, mt)

return setmetatable(M, mt)