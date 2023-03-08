local M = {}

---
-- Apply a scale to the object
-- @param x
-- @param y
-- @return The component
function M.scale(x, y)
	x = x or 1
	y = y or x
	local c = {}
	c.tag = "scale"
	c.scale = vmath.vector3(x, y, x)

	c.scale_to = function(x, y)
		local object = c.object
		local scale = object.scale
		scale.x = x
		scale.y = y or x
		go.set_scale(scale, object.id)
	end

	return c
end

return M