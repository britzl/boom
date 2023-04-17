local M = {}

---
-- Determines the draw order for objects. Object will be
-- drawn on top if z value is bigger.
-- @param z Z-value of the object.
-- @return The component
function M.z(z)
	local c = {}
	c.tag = "z"
	c.z = z
	return c
end

return M