local M = {}

local gravity = 800

--- Get gravity
-- @treturn number gravity The gravity in pixels per seconds
function M.get_gravity()
	return gravity
end

--- Set gravity
-- @number gravity Gravity in pixels per seconds
function M.set_gravity(_gravity)
	gravity = _gravity
end


return M