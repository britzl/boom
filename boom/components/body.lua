local collision = require "boom.events.collision"
local gravity = require "boom.info.gravity"

local M = {}



function M.body(options)
	local c = {}
	c.tag = "body"

	c.is_grounded = false
	c.is_falling = false
	c.is_jumping = false
	c.jump_force = options and options.jump_force or 800

	local is_static = options and options.is_static or false
	local acc = 0

	c.init = function()
		local object = c.object
		assert(object.comps.pos, "Component 'body' requires component 'pos'")
		assert(object.comps.area, "Component 'body' requires component 'area'")
	end

	c.init = function()
		if is_static then return end
		local object = c.object
		object.on_collide("body", function(collision_data)
			acc = 0
			object.is_grounded = true
			print(collision_data.distance)
			object.pos.y = object.pos.y - collision_data.distance.y
		end)
	end


	c.jump = function(force)
		local object = c.object
		force = force or object.jump_force
		object.is_grounded = false
		acc = force
	end

	if not is_static then
		c.update = function(dt)
			local object = c.object
			if not object.is_grounded then
				local g = gravity.get_gravity()
				acc = acc - g * dt

				object.is_jumping = acc > 0
				object.is_falling = acc < 0

				local pos = object.pos
				pos.y = pos.y + acc * dt
			end
		end
	end

	c.destroy = function()
	end

	return c
end




return M