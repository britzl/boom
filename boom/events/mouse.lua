local listener = require "boom.events.listener"
local gameobject = require "boom.gameobject.gameobject"
local vec2 = require "boom.math.vec2"

local MOUSE_BUTTON_LEFT = hash("mouse_button_left")
local MOUSE_BUTTON_MIDDLE = hash("mouse_button_middle")
local MOUSE_BUTTON_RIGHT = hash("mouse_button_right")
local MOUSE_MOVE = hash("mouse_move")


local BUTTONS = {}
BUTTONS.left = MOUSE_BUTTON_LEFT
BUTTONS.right = MOUSE_BUTTON_RIGHT
BUTTONS.middle = MOUSE_BUTTON_MIDDLE

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
		return listener.register(click_listeners, MOUSE_BUTTON_LEFT, function(action)
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
		return listener.register(click_listeners, MOUSE_BUTTON_LEFT, function(action)
			if action.released then
				cb()
			end
		end)
	end
end

--- Register callback that runs when left mouse button is pressed.
-- @string button Optional button ("left", "right", "middle", default is "left")
-- @function cb The callback
-- @treturn function fn Cancel callback
function M.on_mouse_press(button, cb)
	if not cb then
		cb = button
		button = "left"
	end
	button = BUTTONS[button] or MOUSE_BUTTON_LEFT
	return listener.register(press_listener, button, cb)
end

--- Register callback that runs when left mouse button is released.
-- @string button Optional button ("left", "right", "middle", default is "left")
-- @function cb The callback
-- @treturn function fn Cancel callback
function M.on_mouse_release(button, cb)
	if not cb then
		cb = button
		button = "left"
	end
	button = BUTTONS[button] or MOUSE_BUTTON_LEFT
	return listener.register(release_listener, button, cb)
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
	elseif action_id == MOUSE_BUTTON_LEFT
	or action_id == MOUSE_BUTTON_MIDDLE
	or action_id == MOUSE_BUTTON_RIGHT then
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