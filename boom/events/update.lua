local listener = require "boom.events.listener"

local M = {}

local update_listeners = {}

--- Run a function every frame.
-- Register an event that runs every frame, optionally for all
-- game objects with certain tag
-- @string tag Run event for all objects matching tag (optional)
-- @function fn The event function to call. Will receive object and cancel function.
function M.on_update(tag, fn)
	if not fn then
		fn = tag
		tag = nil
	end
	if tag then
		listener.register(update_listeners, "update", function(cancel)
			local objects = gameobject.get(tag)
			for i=1,#objects do
				fn(objects[i], cancel)
			end
		end)
	else
		listener.register(update_listeners, "update", function(cancel)
			fn(cancel)
		end)
	end
end

function M.__update(dt)
	listener.trigger(update_listeners, "update")
end

function M.__destroy()
	update_listeners = {}
end

return M