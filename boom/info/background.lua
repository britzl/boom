local rgb = require "boom.math.rgb"

local M = {}

local background_color = rgb(sys.get_config_number("render.clear_color_red"), sys.get_config_number("render.clear_color_green"), sys.get_config_number("render.clear_color_blue"), sys.get_config_number("render.clear_color_alpha"))

function M.set_background(...)
	local c = rgb(...)
	background_color = c
	msg.post("@render:", "clear_color", { color = vmath.vector4(c.r, c.g, c.b, c.a) })
end

function M.get_background(...)
	return rgb(background_color)
end

return M