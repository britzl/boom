--- Vector type for a 2D point (backed by Defold vmath.vector3())

local M = {}

local vec2 = {}

--- Create a Vec2
-- @name vec2
-- @number x Horizontal position
-- @number y Vertical position
-- @treturn Vec2 v2 The created vec2
local function new(x, y)
	if type(x) == "userdata" then
		return vmath.vector3(x)
	end
	x = x or 0
	y = y or x
	return vmath.vector3(x, y, 0)
end


--- UP vector
-- @type Vec2
-- @field Vec2
vec2.UP = new(0, 1)

--- DOWN vector
-- @type Vec2
-- @field Vec2
vec2.DOWN = new(0, -1)

--- LEFT vector
-- @type Vec2
-- @field Vec2
vec2.LEFT = new(-1, 0)

--- RIGHT vector
-- @type Vec2
-- @field Vec2
vec2.RIGHT = new(1, 0)

local mt = {
	__call = function(t, ...)
		return new(...)
	end
}

M.vec2 = setmetatable(vec2, mt)

return setmetatable(M, mt)