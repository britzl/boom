--- Make object unaffected by camera.

local M = {}

--- Create a fixed component
-- @treturn FixedComp component The component
function M.fixed(...)
	local c = {}
	c.tag = "fixed"
	return c
end

return M