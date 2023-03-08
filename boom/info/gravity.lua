local M = {}

local gravity = 800

---
-- Get gravity
-- @return gravity The gravity in pixels per seconds
function M.get_gravity()
	return gravity
end

---
-- Set gravity
-- @param gravity Gravity in pixels per seconds
function M.set_gravity(_gravity)
	gravity = _gravity
end


return M