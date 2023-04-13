local gravity = require "boom.info.gravity"

local M = {}

function M.double_jump(options)
	local c = {}
	c.tag = "double_jump"

	c.num_jumps = options and options.num_jumps or 1

	c.double_jump = function(force)
	end

	return c
end

return M