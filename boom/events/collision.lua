local gameobject = require "boom.gameobject.gameobject"
local listener = require "boom.events.listener"

local M = {}

local collision_listeners = {}

local COLLISION_RESPONSE = hash("collision_response")
local CONTACT_POINT_RESPONSE = hash("contact_point_response")

---
-- Register an event that runs when two game objects collide
-- @param tag1 Tag which the first game object must have
-- @param tag2 Optional tag which the second game object must have
-- @param fn Will receive (collision, cancel) as args
-- @return Cancel event function
function M.on_collide(tag1, tag2, fn)
	assert(tag1)
	assert(fn)
	return listener.register(collision_listeners, CONTACT_POINT_RESPONSE, function(message, cancel)
		local id = message.id
		local other_id = message.other_id
		local object = gameobject.object(id)
		local other_object = gameobject.object(other_id)
		if not object or object.destroyed or not other_object or other_object.destroyed then
			return
		end

		local tag1_match = object.tags[tag1]
		local tag2_match = other_object.tags[tag2]
		--local tag1_match = (object.tags[tag1] or other_object.tags[tag1])
		--local tag2_match = (object.tags[tag2] or other_object.tags[tag2])

		if (not tag2 and tag1_match)
		or (tag1_match and tag2_match) then
			local data = {}
			data.source = object
			data.target = other_object
			data.normal = message.normal
			data.distance = message.distance
			fn(data, cancel)
		end
	end)
end


function M.__on_message(message_id, message, sender)
	if message_id == CONTACT_POINT_RESPONSE then
		message.id = go.get_parent(sender)
		message.other_id = go.get_parent(message.other_id)
		listener.trigger(collision_listeners, CONTACT_POINT_RESPONSE, message)
	end
end

function M.__destroy()
	collision_listeners = {}
end

return M