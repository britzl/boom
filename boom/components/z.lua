local callable = require "boom.internal.callable"

local M = {}

--- Determines the draw order for objects.
-- Object will be drawn on top if z value is bigger.
-- @number z Z-value of the object.
-- @treturn ZComp component The created component
function M.z(z)
	local c = {}
	c.tag = "z"

	--- The z value
	-- @type ZComp
	-- @field number
	c.z = z
	return c
end

return callable.make(M, M.z)