local gameobject = require "boom.gameobject"

local M = {}

local listeners = {}

local function register_listener(event, data)
	assert(event)
	assert(data)
	listeners[event] = listeners[event] or {}

	local cancel = nil
	cancel = function()
		listeners[event][cancel] = nil
	end

	listeners[event][cancel] = data
	return cancel
end

-----------

local keymap = {}

function M.on_key_press(key_id, fn)
	key_id = hash(key_id)
	local key = keymap[key_id]
	if not key then
		key = {}
		keymap[key_id] = key
	end
	key.on_pressed = fn
end

function M.on_key_release(key_id, fn)
	key_id = hash(key_id)
	local key = keymap[key_id]
	if not key then
		key = {}
		keymap[key_id] = key
	end
	key.on_released = fn
end

function M.is_key_down(key_id)
	key_id = hash(key_id)
	local key = keymap[key_id]
	if not key then return false end
	return key.pressed
end

local function handle_input(action_id, action)
	local key = keymap[action_id]
	if not key then
		return
	end
	if action.pressed then
		key.pressed = true
		if key.on_pressed then
			key.on_pressed()
		end
	elseif action.released then
		key.pressed = false
		if key.on_released then
			key.on_released()
		end
	end
end

function M.on_input(action_id, action)
	if action_id then
		handle_input(hash("*"), action)
		handle_input(action_id, action)
	end
end

---------------------

---
-- Register an event that runs when two game objects with certain tags collide
-- @param tag1
-- @param tag2
-- @param fn Will receive (first, second, cancel) as args
-- @return Cance event function
function M.on_collide(tag1, tag2, fn)
	register_listener("collision_response", function(message, cancel)
		local id = message.id
		local other_id = message.other_id
		local object = gameobject.object(id)
		local other_object = gameobject.object(other_id)
		if object.destroyed or other_object.destroyed then
			return
		end
		if (object.tags[tag1] and other_object.tags[tag2])
		or (object.tags[tag2] and other_object.tags[tag1]) then
			fn(object, other_object, cancel)
		end
	end)
end

-- 
function M.on_collision_response(cb)
	return register_listener("collision_response", cb)
end

function M.on_message(message_id, message, sender)
	if message_id == hash("collision_response") then
		message.id = go.get_parent(sender)
		message.other_id = go.get_parent(message.other_id)
		for cancel,listener in pairs(listeners.collision_response or {}) do
			listener(message, cancel)
		end
	end
end

---------------------

--- register an event that runs every frame, optionally for all
-- game objects with certain tag
-- @param tag [optional] run event for all objects matching tag
-- @param fn event function to call. Will receive object and cancel function
function M.on_update(tag, fn)
	if not fn then
		fn = tag
		tag = nil
	end
	if tag then
		register_listener("update", function(cancel)
			local objects = gameobject.get(tag)
			for i=1,#objects do
				fn(objects[i], cancel)
			end
		end)
	else
		register_listener("update", function(cancel)
			fn(cancel)
		end)
	end
end

function M.update(dt)
	for cancel,listener in pairs(listeners.update or {}) do
		listener(cancel)
	end
end

return M