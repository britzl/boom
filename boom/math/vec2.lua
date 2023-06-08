--- Vector type for a 2D point (backed by Defold vmath.vector3())
local observable = require("boom.internal.observable")

local M = {}

local vec2 = {}

--- Create a Vec2
-- @name vec2
-- @number x Horizontal position
-- @number y Vertical position
-- @treturn Vec2 v2 The created vec2
local function new(x, y)
	local tx = type(x)
	if tx == "userdata" then
		local v3 = x
		x = v3.x
		y = v3.y
	elseif tx == "table" then
		local v2 = x
		x = v2.x
		y = v2.y
	else
		x = x or 0
		y = y or x
	end

	local v3 = vmath.vector3(x, y, 0)

	local properties = {}
	properties.x = x
	properties.y = y
	properties.z = 0
	properties.tov3 = function()
		v3.x = properties.x
		v3.y = properties.y
		v3.z = properties.z
		return v3
	end

	local v2 = {}

	observable.create(v2, properties)
	local mt = getmetatable(v2) or {}
	mt.__sub = function(o1, o2)
		return new(o1.x - o2.x, o1.y - o2.y)
	end
	mt.__add = function(o1, o2)
		return new(o1.x + o2.x, o1.y + o2.y)
	end
	mt.__mul = function(o1, o2)
		if type(o2) == "number" then
			return new(o1.x * o2, o1.y * o2)
		else
			return new(o1.x * o2.x, o1.y * o2.y)
		end
	end
	return setmetatable(v2, mt)
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