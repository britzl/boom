local M = {}

--- Do not get destroyed on scene switch.
-- @treturn component Stay The created component
function M.stay()
	local c = {}
	c.tag = "stay"
	return c
end

return M