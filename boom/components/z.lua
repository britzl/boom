local M = {}

--- Determines the draw order for objects.
-- Object will be drawn on top if z value is bigger.
-- @number z Z-value of the object.
-- @treturn component Z The created component
function M.z(z)
	local c = {}
	c.tag = "z"

	--- The z value
	-- @type Z
	-- @field number
	c.z = z
	return c
end

return M