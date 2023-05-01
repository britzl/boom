local gravity = require "boom.info.gravity"
local collisions = require "boom.collisions"

local M = {}

--- Physical body that responds to gravity.
-- Requires AreaComp and PosComp components on the game object. This also makes
-- the object solid.
-- @table options Component options (jump_force, is_static)
-- @treturn component BodyComp The body component
function M.body(options)
	local c = {}
	c.tag = "body"

	c.is_grounded = false
	c.is_falling = false
	c.is_jumping = false
	c.jump_force = options and options.jump_force or 800
	c.is_static = options and options.is_static or false

	local acc = vec2()
	local correction = vmath.vector3()

	local collision_handle = nil

	c.init = function()
		local object = c.object
		assert(object.comps.pos, "Component 'body' requires component 'pos'")
		assert(object.comps.area, "Component 'body' requires component 'area'")

		if object.is_static then return end

		collision_handle = collisions.on_object_collision(object, "body", function(data)
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
					acc.y = 0
				end
			end
		end)
	end

	--- Add upward force
	-- @type BodyComp
	-- @number force The upward force to apply
	c.jump = function(force)
		local object = c.object
		force = force or object.jump_force
		object.is_grounded = false
		acc.y = force
	end

	if not c.is_static then
		c.update = function(dt)
			local object = c.object
			if not object.is_grounded then
				local g = gravity.get_gravity()
				acc.y = acc.y - g * dt
				if acc.y < -300 then
					acc.y = -300
				end

				object.is_jumping = acc.y > 0
				object.is_falling = acc.y < 0
				object.pos = object.pos + acc * dt
			end
			if object.is_grounded == true then
				object.is_grounded = false
			end
			correction.x = 0
			correction.y = 0
		end
	end

	c.destroy = function()
		if collision_handle then
			collision_handle()
			collision_handle = nil
		end
	end

	return c
end




return M