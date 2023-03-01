local gameobject = require "boom.gameobject"
local events = require "boom.events"

local M = {}

local AREA_RECT = nil

function M.init()
	AREA_RECT = msg.url("#arearectfactory")
end

function M.area(options)
	local c = {}
	c.tag = "area"

	c.init = function()
		local object = c.object
		local pos = vmath.vector3(0)
		local rotation = nil
		local properties = nil
		local scale = vmath.vector3(20)
		local area_id = factory.create(AREA_RECT, pos, rotation, properties, scale)
		go.set_parent(area_id, c.object.id, false)
	end

	local registered_events = {}
	c.on_collide = function(tag, cb)
		local cancel = events.on_collide(c.object.id, tag, function(object1, object2, cancel)
			cb(object2, cancel)
		end)
		registered_events[#registered_events + 1] = cancel
	end

	c.destroy = function()
		for i = #registered_events,1,-1 do
			local cancel = registered_events[i]
			cancel()
			registered_events[i] = nil
		end
	end

	return c
end

return M