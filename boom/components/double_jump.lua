local callable = require "boom.internal.callable"

local M = {}

--- Enables double jump.
-- Requires "body" component.
-- @table options Component options (num_jumps)
-- @treturn DoubleJumpComp component The double jump component
function M.double_jump(options)
	local c = {}
	c.tag = "double_jump"

	c.num_jumps = options and options.num_jumps or 2
	local jump_count = 0

	c.init = function()
		local object = c.object
		assert(object.comps.body, "Component 'double_jump' requires component 'body'")
	end

	--- Performs double jump (the initial jump only happens if player is grounded)
	-- @type DoubleJumpComp
	-- @number force The upward force to apply
	c.double_jump = function(force)
		local object = c.object
		if object.is_grounded then
			jump_count = 1
			object.jump(force)
		elseif jump_count < object.num_jumps then
			jump_count = jump_count + 1
			object.jump(force)
		end
	end

	return c
end

return callable.make(M, M.double_jump)