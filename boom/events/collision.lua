local gameobject = require "boom.gameobject.gameobject"
local listener = require "boom.events.listener"

local M = {}

local collision_listeners = {}

local COLLISION_RESPONSE = hash("collision_response")

---
-- Register an event that runs when two game objects with certain tags collide
-- @param tag1
-- @param tag2
-- @param fn Will receive (first, second, cancel) as args
-- @return Cancel event function
function M.on_collide(tag1, tag2, fn)
	return listener.register(collision_listeners, COLLISION_RESPONSE, function(message, cancel)
		local id = message.id
		local other_id = message.other_id
		local object = gameobject.object(id)
		local other_object = gameobject.object(other_id)
		if not object or object.destroyed or not other_object or other_object.destroyed then
			return
		end
		if (object.tags[tag1] and other_object.tags[tag2])
		or (object.tags[tag2] and other_object.tags[tag1]) then
			fn(object, other_object, cancel)
		end
	end)
end

function M.on_collision_response(cb)
	return listener.register(collision_listeners, COLLISION_RESPONSE, cb)
end

function M.__on_message(message_id, message, sender)
	if message_id == COLLISION_RESPONSE then
		message.id = go.get_parent(sender)
		message.other_id = go.get_parent(message.other_id)
		listener.trigger(collision_listeners, COLLISION_RESPONSE, message)
	end
end

function M.__destroy()
	collision_listeners = {}
end

return M