local color = require "boom.math.color"

local M = {}

local WIDTH = sys.get_config_int("display.width")
local HEIGHT = sys.get_config_int("display.height")

---
-- Get screen width
-- @return Width of screen
function M.width()
	return WIDTH
end

---
-- Get screen height
-- @return Height of screen
function M.height()
	return HEIGHT
end

local background_color = color(sys.get_config_number("render.clear_color_red"), sys.get_config_number("render.clear_color_green"), sys.get_config_number("render.clear_color_blue"), sys.get_config_number("render.clear_color_alpha"))

function M.set_background(...)
	local c = color(...)
	background_color = c
	msg.post("@render:", "clear_color", { color = vmath.vector4(c.r, c.g, c.b, c.a) })
end

function M.get_background(...)
	return color(background_color)
end

function M.init()
	window.set_listener(function(self, event, data)
		if event == window.WINDOW_EVENT_RESIZED then
			WIDTH = data.width
			HEIGHT = data.height
		end
	end)
end

return M