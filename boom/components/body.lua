local collision = require "boom.events.collision"
local gravity = require "boom.info.gravity"

local M = {}



function M.body(options)
	local c = {}
	c.tag = "body"

	c.init = function()
		local object = c.object
		assert(object.comps.pos, "Component 'body' requires component 'pos'")
		assert(object.comps.area, "Component 'body' requires component 'area'")
	end

	local registered_events = {}
	c.on_collide = function(tag, cb)
		local cancel = collision.on_collide(c.object.id, tag, function(object1, object2, cancel)
			cb(object2, cancel)
		end)
		registered_events[#registered_events + 1] = cancel
	end

	c.update = function(dt)
		local g = gravity.get_gravity()
		local object = c.object
		local pos = object.pos
		pos.y = pos.y + gravity * dt
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