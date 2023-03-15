local gameobject = require "boom.gameobject.gameobject"
local listener = require "boom.events.listener"
local screen = require "boom.info.screen"

local M = {}

---
-- Control the behavior of object when it goes out of view
-- @param options (distance, destroy)
-- @return The component
function M.offscreen(options)
	local c = {}
	c.tag = "offscreen"
	c.is_offscreen = false

	local distance = options and options.distance or 0
	local destroy = options and options.destroy

	local offscreen_listeners = {}
	c.on_exit_screen = function(cb)
		return listener.register(offscreen_listeners, "exit_screen", cb)
	end
	c.on_enter_screen = function(cb)
		return listener.register(offscreen_listeners, "enter_screen", cb)
	end

	c.init = function()
		assert(c.object.comps.pos, "Component 'offscreen' requires component 'pos'")
	end

	c.update = function(dt)
		local object = c.object
		local pos = c.object.pos

		local w = screen.width()
		local h = screen.height()
		if pos.x < 0 - distance
		or pos.x > w + distance
		or pos.y > (h + distance)
		or pos.y < (0 - distance)
		then
			if not object.is_offscreen then
				object.is_offscreen = true
				listener.trigger(offscreen_listeners, "exit_screen")
				if destroy then
					gameobject.destroy(c.object)
				end
			end
		else
			if object.is_offscreen then
				object.is_offscreen = false
				listener.trigger(offscreen_listeners, "enter_screen")
			end
		end
	end

	c.destroy = function()
		offscreen_listeners = {}
	end

	return c
end

return M