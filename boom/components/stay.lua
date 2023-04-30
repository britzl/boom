local M = {}

---
-- Do not get destroyed on scene switch
-- @return component The created component
function M.stay()
	local c = {}
	c.tag = "stay"
	return c
end

return M