local listener = require "boom.events.listener"
local gameobject = require "boom.gameobject.gameobject"
local vec2 = require "boom.math.vec2"

local MOUSE_BUTTON_1 = hash("mouse_button_1")
local MOUSE_MOVE = hash("mouse_move")

local M = {}

local click_listeners = {}
local press_listener = {}
local release_listener = {}
local move_listener = {}

local mouse_pos = vec2()

--- Set mouse click listener.
-- @string tag Optional click on object with tag filter
-- @function cb Callback when mouse button is clicked
-- @treturn function fn Cancel listener function
function M.on_click(tag, cb)
	if not cb then
		cb = tag
		tag = nil
	end

	if tag then
		return listener.register(click_listeners, MOUSE_BUTTON_1, function(action)
			if not action.released then return end
			local objects = gameobject.get("area")
			for i=1,#objects do
				local object = objects[i]
				if object.tags[tag] and object.has_point(mouse_pos) then
					cb(object)
				end
			end
		end)
	else
		return listener.register(click_listeners, MOUSE_BUTTON_1, function(action)
			if action.released then
				cb()
			end
		end)
	end
end

--- Register callback that runs when left mouse button is pressed.
-- @function cb The callback
-- @treturn function fn Cancel callback
function M.on_mouse_press(cb)
	return listener.register(press_listener, MOUSE_BUTTON_1, cb)
end

--- Register callback that runs when left mouse button is released.
-- @function cb The callback
-- @treturn function fn Cancel callback
function M.on_mouse_release(cb)
	return listener.register(release_listener, MOUSE_BUTTON_1, cb)
end

--- Register callback that runs when the mouse is moved.
-- @function cb The callback
-- @treturn function fn Cancel callback
function M.on_mouse_move(cb)
	return listener.register(move_listener, MOUSE_MOVE, cb)
end

--- Get mouse position (screen coordinates).
-- @treturn vec2 pos Mouse position
function M.mouse_pos()
	return mouse_pos
end

function M.__on_input(action_id, action)
	if not action_id then
		mouse_pos.x = action.x
		mouse_pos.y = action.y
		listener.trigger(move_listener, MOUSE_MOVE, action)
	elseif action_id == MOUSE_BUTTON_1 then
		mouse_pos.x = action.x
		mouse_pos.y = action.y
		listener.trigger(move_listener, MOUSE_MOVE, action)
		if action.pressed then
			listener.trigger(press_listener, action_id, action)
		elseif action.released then
			listener.trigger(click_listeners, action_id, action)
			listener.trigger(release_listener, action_id, action)
		end
	end
end

function M.__destroy()
	click_listeners = {}
	release_listener = {}
	press_listener = {}
	move_listener = {}
end

return M