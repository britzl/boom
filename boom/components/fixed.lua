local M = {}

---
-- Make object unaffected by camera
-- @return The component
function M.fixed(...)
	local c = {}
	c.tag = "fixed"
	return c
end

return M