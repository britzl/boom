---Body component.
-- Use this component to create a physical body that responds to gravity.
--
-- @usage
-- gravity(600)
-- local player = add({
--     sprite("player"),
--     area("auto"),
--     body()
-- })
--
-- player.jump(300)


local gravity = require "boom.info.gravity"
local collisions = require "boom.internal.collisions"
local callable = require "boom.internal.callable"

local M = {}

--- Physical body that responds to gravity.
-- Requires AreaComp and PosComp components on the game object. This also makes
-- the object solid.
-- @table options Component options (jump_force, is_static)
-- @treturn BodyComp component The body component
function M.body(options)
	local c = {}
	c.tag = "body"

	--- If the body is in contact with ground.
	-- @type BodyComp
	-- @field boolean
	c.is_grounded = false

	--- If the body is falling (velocity is pointing down).
	-- @type BodyComp
	-- @field boolean
	c.is_falling = false

	--- If the body is jumping (velocity is pointing up).
	-- @type BodyComp
	-- @field boolean
	c.is_jumping = false

	--- The upward velocity applied to the body when jumping.
	-- @type BodyComp
	-- @field number
	c.jump_force = options and options.jump_force or 800

	--- If the body is static and not affected by gravity.
	-- @type BodyComp
	-- @field boolean
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

				local bump = normal.y <= -0.9
				local ground = normal.y >= 0.9
				object.is_grounded = ground

				if bump and acc.y > 0 then
					acc.y = 0
				elseif ground and acc.y < 0 then
					acc.y = 0
				end
			end
		end)
	end

	--- Add upward force.
	-- @type BodyComp
	-- @number force The upward force to apply
	c.jump = function(force)
		local object = c.object
		force = force or object.jump_force
		object.is_grounded = false
		acc.y = force
	end

	if not c.is_static then
		c.pre_update = function()
			local object = c.object
			if object.is_grounded == true then
				object.is_grounded = false
			end
		end

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
				object.dirty = true
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

return callable.make(M, M.body)