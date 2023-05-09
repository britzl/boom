--- Area component.
-- Use this component to define a collider area and bounds for a game object.

local collisions = require "boom.collisions"
local mouse = require "boom.events.mouse"
local vec2 = require "boom.math.vec2"
local rect = require "boom.area.rect"
local circle = require "boom.area.circle"
local areafactory = require "boom.area.areafactory"

local M = {}

local AREA_RECT = nil
local AREA_CIRCLE = nil

local V2_ZERO = vec2(0)
local V2_ONE = vec2(1)


function M.__init()
	AREA_RECT = msg.url("#arearectfactory")
	AREA_CIRCLE = msg.url("#areacirclefactory")
end

--- Create a collider area and enabled collision detection.
-- This will create an area component which is used to describe an area which
-- can collide with other area components.
-- @table options Component options (width and height)
-- @treturn area AreaComp The area component
function M.area(options)
	local c = {}
	c.tag = "area"

	local shape = options and options.shape or "rect"
	local radius = options and options.radius or 10
	local width = options and options.width or 20
	local height = options and options.height or 20
	local area_id = nil

	local registered_collisions = {}

	local registered_events = {}


	local function create_area(object, w, h)
		if area_id then
			go.delete(area_id)
		end
		local is_static = object.is_static
		local properties = {
			group = is_static and hash("static") or hash("area"),
			area_mask = true,
			static_mask = (is_static ~= true),
		}
		if shape == "rect" then
			area_id = areafactory.rect(w, h, properties)
		elseif shape == "circle" then
			area_id = areafactory.circle(w, properties)
		end
		go.set_parent(area_id, object.id, false)
	end

	c.init = function()
		local object = c.object

		if shape == "rect" then
			object.local_area = rect.create()
			object.world_area = rect.create()
			create_area(object, width, height)
		elseif shape == "circle" then
			object.local_area = circle.create()
			object.world_area = circle.create()
			create_area(object, radius)
		else
			error("Unknown shape " .. shape)
		end

		if not object.is_static then
			local cancel = collisions.on_object_collision(object, nil, function(data, cancel)
				registered_collisions[#registered_collisions + 1] = data
			end)
			registered_events[#registered_events + 1] = cancel
		end
	end

	--- Get all collisions currently happening for this component.
	-- @type AreaComp
	-- @treturn collisions table List of collisions
	c.get_collisions = function()
		return registered_collisions
	end

	--- Check collision between this component and another object.
	-- @type AreaComp
	-- @tparam other_object GameObject The game object to check collisions with.
	-- @treturn collision bool Return true if colliding with the other object
	-- @treturn data table Collision data
	c.check_collision = function(other_object)
		for i=1,#registered_collisions do
			local collision = registered_collisions[i]
		end
		return false
	end

	--- Register event listener when this component is colliding.
	-- @type AreaComp
	-- @string tag Optional tag which colliding object must have, nil for all collisions
	-- @function cb Function to call when collision is detected
	c.on_collide = function(tag, cb)
		local cancel = collisions.on_object_collision(c.object, tag, function(cancel)
			cb(cancel)
		end)
		registered_events[#registered_events + 1] = cancel
	end

	--- Register event listener when this component is clicked.
	-- @type AreaComp
	-- @function cb Function to call when clicked
	c.on_click = function(cb)
		local cancel = mouse.on_click(c.object.id, function(object, cancel)
			cb(object, cancel)
		end)
		registered_events[#registered_events + 1] = cancel
	end

	--- Check if a point is within the area of this component.
	-- @type AreaComp
	-- @param point The point to check
	-- @treturn result bool Will return true if point is within area
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
			create_area(object, w, h)

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
			create_area(object, r)

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