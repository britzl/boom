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
	c.is_static = options and options.is_static or false

	local acc = 0
	local correction = vmath.vector3()

	c.init = function()
		local object = c.object
		assert(object.comps.pos, "Component 'body' requires component 'pos'")
		assert(object.comps.area, "Component 'body' requires component 'area'")

		if object.is_static then return end

		object.on_collide("body", function(data)
			local distance = data.distance
			local normal = data.normal
			if distance <= 0 then return end

			local proj = vmath.project(correction, normal * distance)
			if proj < 1 then
				local comp = (distance - distance * proj) * normal
				object.pos = object.pos + comp
				correction = correction + comp

				local bump = normal.y <= -1
				local ground = normal.y >= 1
				object.is_grounded = ground

				if bump or ground then
					acc = 0
				end
			end
		end)
	end


	c.jump = function(force)
		local object = c.object
		force = force or object.jump_force
		object.is_grounded = false
		acc = force
	end

	if not c.is_static then
		c.update = function(dt)
			local object = c.object
			if not object.is_grounded then
				local g = gravity.get_gravity()
				acc = acc - g * dt
				if acc < -300 then
					acc = -300
				end

				object.is_jumping = acc > 0
				object.is_falling = acc < 0

				local pos = object.pos
				pos.y = pos.y + acc * dt
			end
			object.is_grounded = false
			correction.x = 0
			correction.y = 0
		end
	end

	c.destroy = function()
	end

	return c
end




return M