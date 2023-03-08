local vec2 = require "boom.math.vec2"

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

---
-- Get screen center position
-- @return Center of screen (vec2)
function M.center()
	return vec2(WIDTH / 2, HEIGHT / 2)
end


function M.__init()
	window.set_listener(function(self, event, data)
		if event == window.WINDOW_EVENT_RESIZED then
			WIDTH = data.width
			HEIGHT = data.height
		end
	end)
end


return M