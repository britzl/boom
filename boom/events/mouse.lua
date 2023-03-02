local listener = require "boom.events.listener"

local MOUSE_BUTTON_1 = hash("mouse_button_1")

local M = {}

local click_listeners = {}

function M.on_click(tag, fn)
	if not fn then
		fn = tag
		tag = nil
	end

	if tag then
		print("on click with tag is not supported")
	else
		return listener.register(click_listeners, MOUSE_BUTTON_1, function()
			fn()
		end)
	end
end

function M.__on_input(action_id, action)
	if action.x then
		listener.trigger(click_listeners, action_id)
	end
end

function M.__destroy()
	click_listeners = {}
end

return M