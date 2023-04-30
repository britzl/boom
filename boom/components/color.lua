--- Component to control the color of the game object

local color = require "boom.math.color"

local M = {}

--- Create a color component
-- @param ... r,g,b components or color
-- @treturn component ColorComp The color component
function M.color(...)
	local c = {}
	c.tag = "color"
	c.color = color(...)
	return c
end

return M