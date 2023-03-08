local M = {}

---
-- Don't get destroyed on scene switch
-- @return component
function M.stay()
	local c = {}
	c.tag = "stay"
	return c
end

return M