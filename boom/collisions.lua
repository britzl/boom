local gameobject = require "boom.gameobject.gameobject"

local M = {}

local HASH_CONTACT_POINT_RESPONSE = hash("contact_point_response")

local object_listeners = {}
local tag_listeners = {}

function M.on_tag_collision(tag1, tag2, cb)
	if not tag_listeners[tag1] then
		tag_listeners[tag1] = {}
	end
	local cancel = nil
	cancel = function()
		tag_listeners[tag1][cancel] = nil
		if not next(tag_listeners[tag1]) then
			tag_listeners[tag1] = nil
		end
	end
	tag_listeners[tag1][cancel] = {
		tag1 = tag1,
		tag2 = tag2,
		cb = cb
	}
	return cancel
end


function M.on_object_collision(object, tag, cb)
	local id = object.id
	if not object_listeners[id] then
		object_listeners[id] = {}
	end
	local cancel = nil
	cancel = function()
		object_listeners[id][cancel] = nil
		if not next(object_listeners[id]) then
			object_listeners[id] = nil
		end
	end
	object_listeners[id][cancel] = {
		id = id,
		tag = tag,
		cb = cb
	}
	return cancel
end


local function handle_contact_point_response(message, sender)
	--print(message.group, message.other_group)
	local id = go.get_parent(sender)
	local other_id = go.get_parent(message.other_id)
	local object = gameobject.object(id)
	local other_object = gameobject.object(other_id)
	if not object or object.destroyed or not other_object or other_object.destroyed then
		return
	end

	local listeners = object_listeners[id]
	if listeners then
		for cancel,listener in pairs(listeners) do
			local tag = listener.tag
			if not tag or tag and other_object.tags[tag] then
				local data = {}
				data.source = object
				data.target = other_object
				data.normal = message.normal
				data.distance = message.distance
				listener.cb(data, cancel)
			end
		end
	end

	for tag1,listeners in pairs(tag_listeners) do
		if object.tags[tag1] then
			for cancel,listener in pairs(listeners) do
				local tag2 = listener.tag2
				if not tag2 or tag2 and other_object.tags[tag2] then
					local data = {}
					data.source = object
					data.target = other_object
					data.normal = message.normal
					data.distance = message.distance
					listener.cb(data, cancel)
				end
			end
		end
	end
end


function M.on_message(message_id, message, sender)
	if message_id == HASH_CONTACT_POINT_RESPONSE then
		handle_contact_point_response(message, sender)
	end
end


return M