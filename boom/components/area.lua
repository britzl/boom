local collision = require "boom.events.collision"
local mouse = require "boom.events.mouse"
local vec2 = require "boom.math.vec2"
local rect = require "boom.area.rect"
local circle = require "boom.area.circle"

local M = {}

local AREA_RECT = nil
local AREA_CIRCLE = nil

local V2_ZERO = vec2(0)
local V2_ONE = vec2(1)


function M.__init()
	AREA_RECT = msg.url("#arearectfactory")
	AREA_CIRCLE = msg.url("#areacirclefactory")
end

---
-- Create a collider area and enabled collision detection
-- @param options (width and height)
-- @return The component
function M.area(options)
	local c = {}
	c.tag = "area"

	local shape = options and options.shape or "rect"
	local radius = options and options.radius or 10
	local width = options and options.width or 20
	local height = options and options.height or 20
	local area_id = nil

	local collisions = {}

	local registered_events = {}

	c.init = function()
		local object = c.object

		if shape == "rect" then
			object.local_area = rect.create()
			object.world_area = rect.create()
		elseif shape == "circle" then
			object.local_area = circle.create()
			object.world_area = circle.create()
		else
			error("Unknown shape " .. shape)
		end

		local is_static = object.is_static
		local pos = vmath.vector3(0)
		local rotation = nil
		local properties = {
			group = is_static and hash("static") or hash("area"),
			area_mask = true,
			static_mask = (is_static ~= true),
		}
		if shape == "rect" then
			local scale = vmath.vector3(math.min(width, height))
			area_id = factory.create(AREA_RECT, pos, rotation, properties, scale)
		elseif shape == "circle" then
			local scale = vmath.vector3(radius * 2)
			area_id = factory.create(AREA_CIRCLE, pos, rotation, properties, scale)
		end
		go.set_parent(area_id, c.object.id, false)

		local cancel = collision.on_collide(c.object.id, nil, function(data, cancel)
			collisions[#collisions + 1] = data
		end)
		registered_events[#registered_events + 1] = cancel
	end

	--- Get all collisions currently happening
	-- @return list of collisions
	c.get_collisions = function()
		return collisions
	end

	---
	-- Check collision with other object
	-- @param other_object
	-- @return collision Return true if colliding with other object
	-- @return data Collision data
	c.check_collision = function(other_object)
		for i=1,#collisions do
			local collision = collisions[i]
		end
		return false
	end

	---
	-- Register event listener when colliding
	-- @param tag Optional tag which colliding object must have, nil for all collisions
	-- @param cb Function to call when collision is detected
	c.on_collide = function(tag, cb)
		local cancel = collision.on_collide(c.object.id, tag, function(cancel)
			cb(cancel)
		end)
		registered_events[#registered_events + 1] = cancel
	end

	---
	-- Register event listener when this object is clicked
	-- @param cb Function to call when clicked
	c.on_click = function(cb)
		local cancel = mouse.on_click(c.object.id, function(object, cancel)
			cb(object, cancel)
		end)
		registered_events[#registered_events + 1] = cancel
	end


	---
	-- Check if a point is within the area
	-- @param point
	-- @return true if point is within area
	c.has_point = function(point)
		local object = c.object
		local angle = object.angle or 0

		if shape == "rect" then
			return rect.point_inside(point, object.local_area, object.world_area.center, angle)
		elseif shape == "cirlce" then
			return circle.point_inside(point, object.local_area, object.world_area.center, angle)
		end
	end

	c.pre_update = function()
		for i = #collisions,1,-1 do
			collisions[i] = nil
		end
	end

	c.update = function(dt)
		local object = c.object
		local anchor = object.anchor or V2_ZERO
		local scale = object.scale or V2_ONE

		if shape == "rect" then
			local w = (object.width or width) * scale.x
			local h = (object.height or height) * scale.y
			local w2 = w / 2
			local h2 = h / 2

			-- resize collision object
			go.set_scale(math.min(w, h), area_id)

			rect.resize(object.local_area, w, h)

			-- create world space rotated rect and offset rect
			local center = object.pos or V2_ZERO
			local angle = object.angle or 0
			local offset = vec2(w2 * anchor.x, h2 * anchor.y)

			go.set_position(offset, area_id)

			rect.copy(object.local_area, object.world_area)
			rect.offset_inline(object.world_area, offset)
			rect.rotate_inline(object.world_area, angle)
			rect.offset_inline(object.world_area, center)
		elseif shape == "circle" then
			local r = (object.radius or radius) * scale.x

			-- resize collision object
			go.set_scale(r * 2, area_id)

			circle.resize(object.local_area, r)

			local center = object.pos or V2_ZERO
			local offset = vec2(r * anchor.x, r * anchor.y)
			circle.copy(object.local_area, object.world_area)

			go.set_position(offset, area_id)

			circle.create(object.local_area)
			circle.offset_inline(object.world_area, offset)
			circle.offset_inline(object.world_area, center)
		end
	end

	c.destroy = function()
		for i = #registered_events,1,-1 do
			local cancel = registered_events[i]
			cancel()
			registered_events[i] = nil
		end
		go.delete(area_id)
	end

	return c
end

return M