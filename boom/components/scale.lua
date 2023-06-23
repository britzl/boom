--- Scale a gameobject

local vec2 = require "boom.math.vec2"
local callable = require "boom.internal.callable"

local M = {}

---
-- Apply a scale to the object
-- @param x
-- @param y
-- @return ScaleComp component The scale component.
function M.scale(x, y)
	x = x or 1
	y = y or x
	local c = {}
	c.tag = "scale"
	c.scale = vec2(x, y)

	--- Set new scale.
	-- @type ScaleComp
	-- @number x
	-- @number y
	c.scale_to = function(x, y)
		local object = c.object
		local scale = object.scale
		scale.x = x
		scale.y = y or x
	end

	--- Change scale.
	-- @type ScaleComp
	-- @number x
	-- @number y
	c.scale_by = function(x, y)
		local object = c.object
		local scale = object.scale
		scale.x = scale.x + x
		scale.y = scale.y + (y or x)
	end

	return c
end

return callable.make(M, M.scale)