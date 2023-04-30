local gravity = require "boom.info.gravity"

local M = {}

--- Enables double jump.
-- Requires "body" component
-- @table options Component options
-- @treturn component DoubleJumpComp The double jump component
function M.double_jump(options)
	local c = {}
	c.tag = "double_jump"

	c.num_jumps = options and options.num_jumps or 1

	---
	-- @class DoubleJumpComp
	-- @number force The upward force to apply
	c.double_jump = function(force)
		local object = c.object
		force = force or 
		acc.y = object.jump_force
	end

	return c
end

return M