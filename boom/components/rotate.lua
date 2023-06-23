--- Rotate a gameobject

local callable = require "boom.internal.callable"

local M = {}

local function update_rotation(object)
	go.set_rotation(vmath.quat_rotation_z(math.rad(object.angle)), object.id)
end

---
-- Apply rotation to object
-- @number angle Angle in degrees
-- @treturn RotateComp component The created component.
function M.rotate(angle)
	local c = {}
	c.tag = "rotate"
	c.angle = angle

	c.init = function()
		update_rotation(c.object)
	end
	c.rotate = function(angle)
		c.angle = angle
		update_rotation(c.object)
	end

	return c
end

return callable.make(M, M.rotate)