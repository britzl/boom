--- Component to control the color of the game object.
-- @usage
-- local bullet = add({
--     sprite("red-bullet"),
--     color(1, 0, 0)
-- })

local rgb = require "boom.math.rgb"
local callable = require "boom.internal.callable"

local M = {}

--- Create a color component
-- @param ... r,g,b components or color
-- @treturn ColorComp component The color component
function M.color(...)
	local c = {}
	c.tag = "color"
	c.color = rgb(...)
	return c
end

return callable.make(M, M.color)