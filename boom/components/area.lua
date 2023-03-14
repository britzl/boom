local collision = require "boom.events.collision"
local mouse = require "boom.events.mouse"
local vec2 = require "boom.math.vec2"

local cos = _G.math.cos
local sin = _G.math.sin
local rad = _G.math.rad

local M = {}

local AREA_RECT = nil

local V2_ZERO = vec2(0)
local V2_ONE = vec2(1)
local GREEN = vmath.vector4(0,1,0,1)


-- create a rect, either a new empty rect or a copy of another rect
local function create_rect(rect)
	return {
		topleft = vec2(rect and rect.topleft),
		topright = vec2(rect and rect.topright),
		bottomleft = vec2(rect and rect.bottomleft),
		bottomright = vec2(rect and rect.bottomright),
		center = vec2(rect and rect.center),
	}
end

-- rotate a point (vec2)
-- the provided point will be modified
local function rotate_point_inline(p, a)
	if not a or a == 0 then return end
	if p.x == 0 and p.y == 0 then return end
	local cosa = cos(rad(a))
	local sina = sin(rad(a))
	local x = (p.x * cosa) - (p.y * sina)
	local y = (p.y * cosa) + (p.x * sina)
	p.x = x
	p.y = y
end

-- apply an offset to a rect
-- the provided rect will be modified
local function offset_rect_inline(rect, offset)
	local tl = rect.topleft
	local tr = rect.topright
	local bl = rect.bottomleft
	local br = rect.bottomright
	local c = rect.center
	tl.x = tl.x + offset.x
	tl.y = tl.y + offset.y
	tr.x = tr.x + offset.x
	tr.y = tr.y + offset.y
	bl.x = bl.x + offset.x
	bl.y = bl.y + offset.y
	br.x = br.x + offset.x
	br.y = br.y + offset.y
	c.x = c.x + offset.x
	c.y = c.y + offset.y
end

-- rotate a rect
-- the provided rect will be modified
local function rotate_rect_inline(rect, angle)
	if not angle or angle == 0 then return end
	rotate_point_inline(rect.topleft, angle)
	rotate_point_inline(rect.topright, angle)
	rotate_point_inline(rect.bottomleft, angle)
	rotate_point_inline(rect.bottomright, angle)
	rotate_point_inline(rect.center, angle)
end

local function point_in_rect(point, rect, center, angle)
	-- rotate distance vector from area center to point onto rect
	local dist = center - point
	rotate_point_inline(dist, -angle)

	local topleft = rect.topleft
	local topright = rect.topright
	local bottomleft = rect.bottomleft
	local bottomright = rect.bottomright

	-- check if distance vector is within the unrotated rect
	return dist.x > topleft.x and dist.y < topleft.y
		and dist.x < topright.x and dist.y < topright.y
		and dist.x > bottomleft.x and dist.y > bottomleft.y
		and dist.x < bottomright.x  and dist.y > bottomright.y
end


function M.__init()
	AREA_RECT = msg.url("#arearectfactory")
end

function M.area(options)
	local c = {}
	c.tag = "area"

	local width = options and options.width or 20
	local height = options and options.height or 20

	c.init = function()
		c.local_rect = create_rect()
		c.world_rect = create_rect()
		c.radius = math.sqrt(((width / 2) * (width / 2)) + ((height / 2) * (height / 2)))

		local pos = vmath.vector3(0)
		local rotation = nil
		local properties = nil
		local scale = vmath.vector3(math.max(width, height))
		local area_id = factory.create(AREA_RECT, pos, rotation, properties, scale)
		go.set_parent(area_id, c.object.id, false)
	end

	c.check_collision = function(other_object)
		local other_area = other_object.comps.area
		if not other_area then return false end

		local object = c.object

		local radius = c.radius
		local other_radius = other_area.radius

		local world_rect = c.world_rect
		local other_world_rect = other_area.world_rect

		local center = world_rect.center
		local other_center = other_world_rect.center

		local cx = center.x
		local cy = center.y
		local ocx = other_center.x
		local ocy = other_center.y
		local distance = math.sqrt((cx - ocx) * (cx - ocx) + (cy - ocy) * (cy - ocy))
		if distance > (radius + other_radius) then
			return false
		end

		local local_rect = c.local_rect
		local other_local_rect = other_area.local_rect

		local angle = object.angle or 0
		local other_angle = other_object.angle or 0

		return point_in_rect(other_world_rect.topleft, local_rect, center, angle)
			or point_in_rect(other_world_rect.topright, local_rect, center, angle)
			or point_in_rect(other_world_rect.bottomleft, local_rect, center, angle)
			or point_in_rect(other_world_rect.bottomright, local_rect, center, angle) 
			or point_in_rect(world_rect.topleft, other_local_rect, other_center, other_angle) 
			or point_in_rect(world_rect.topright, other_local_rect, other_center, other_angle) 
			or point_in_rect(world_rect.bottomleft, other_local_rect, other_center, other_angle) 
			or point_in_rect(world_rect.bottomright, other_local_rect, other_center, other_angle) 
	end

	local registered_events = {}
	c.on_collide = function(tag, cb)
		local cancel = collision.on_collide(c.object.id, tag, function(object1, object2, cancel)
			cb(object2, cancel)
		end)
		registered_events[#registered_events + 1] = cancel
	end

	c.on_click = function(cb)
		local cancel = mouse.on_click(c.object.id, function(object, cancel)
			cb(object, cancel)
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

	-- To find if a point is inside your rectangle, take the distance-vector
	-- from the rectangle center to this point and rotate it backward (by the
	-- angle -a). Then check if it is inside the corresponding unrotated
	-- rectangle
	-- https://love2d.org/forums/viewtopic.php?p=69469&sid=4a77ba2c0052546e8b7a6d32c74fdbcc#p69469
	c.has_point = function(point)
		local object = c.object
		local angle = object.angle or 0
		local center = c.world_rect.center
		return point_in_rect(point, c.local_rect, center, angle)
	end

	c.update = function(dt)
		local object = c.object
		local comps = object.comps
		local sprite = comps.sprite
		local anchor = object.anchor or V2_ZERO
		local scale = object.scale or V2_ONE
		local w = (sprite and sprite.width or width) * scale.x
		local h = (sprite and sprite.height or height) * scale.y
		local w2 = w / 2
		local h2 = h / 2

		-- for quick collision check
		c.radius = math.sqrt((w2 * w2) + (h2 * h2))

		-- make sure the local space unrotated rect is of correct size
		-- (in case the width or height has changed)
		-- local space rect does not have an offset
		local local_rect = c.local_rect
		local_rect.topleft.x = -w2
		local_rect.topleft.y = h2
		local_rect.topright.x = w2
		local_rect.topright.y =  h2
		local_rect.bottomleft.x = -w2
		local_rect.bottomleft.y = -h2
		local_rect.bottomright.x = w2
		local_rect.bottomright.y = -h2

		-- create world space rotated rect and offset rect
		local center = object.pos or V2_ZERO
		local angle = object.angle or 0
		local offset = vec2(w2 * anchor.x, h2 * anchor.y)

		--local world_rect = create_rect(local_rect, center, angle)
		local world_rect = create_rect(local_rect)
		offset_rect_inline(world_rect, offset)
		rotate_rect_inline(world_rect, angle)
		offset_rect_inline(world_rect, center)
		c.world_rect = world_rect

		-- debug
		msg.post("@render:", "draw_line", { start_point = world_rect.topleft,     end_point = world_rect.topright, color = GREEN })
		msg.post("@render:", "draw_line", { start_point = world_rect.topright,    end_point = world_rect.bottomright, color = GREEN })
		msg.post("@render:", "draw_line", { start_point = world_rect.bottomright, end_point = world_rect.bottomleft, color = GREEN })
		msg.post("@render:", "draw_line", { start_point = world_rect.bottomleft,  end_point = world_rect.topleft, color = GREEN })
	end

	return c
end

return M