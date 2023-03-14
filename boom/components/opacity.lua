local M = {}

---
-- Opacity of object
-- @param opacity 0.0 to 1.0
-- @return The component
function M.opacity(opacity)
	local c = {}
	c.tag = "opacity"
	c.opacity = opacity
	return c
end

return M