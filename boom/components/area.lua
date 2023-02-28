local gameobject = require "boom.gameobject"
local events = require "boom.events"
local factories = require "boom.factories"

return function(options)
	local c = {}
	c.tag = "area"

	c.init = function()
		local object = c.object
		local pos = vmath.vector3(0)
		local rotation = nil
		local properties = nil
		local scale = vmath.vector3(20)
		local area_id = factory.create(factories.AREA_RECT, pos, rotation, properties, scale)
		go.set_parent(area_id, c.object.id, false)

	end

	c.on_collide = function(tag, cb)
		events.on_collision_response(function(message, cancel)
			local other_id = message.other_id
			local other_object = gameobject.object(other_id)
			if other_object.comps[tag] then
				cb(other_object, cancel)
			end
		end)
	end

	return c
end