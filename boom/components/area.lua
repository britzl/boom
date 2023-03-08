local collision = require "boom.events.collision"
local mouse = require "boom.events.mouse"
local vec2 = require "boom.math.vec2"

local cos = _G.math.cos
local sin = _G.math.sin
local rad = _G.math.rad

local M = {}

local AREA_RECT = nil

local function intersects(a, b)
	local polygons = { a, b }
	for i=1,#polygons do
		local polygon = polygons[i]
		for i1=1,#polygon do
			local i2 = (i1 + 1)
			i2 = i2 > #polygon and 1 or i2
			local p1 = polygon[i1]
			local p2 = polygon[i2]
			local normal = vec2(p2.y - p1.y, p1.x - p2.x)
			local mina = nil
			local maxa = nil
			for j=1,#a do
				local projected = normal.x * a[j].x + normal.y * a[j].y
				if not mina or projected < mina then mina = projected end
				if not maxa or projected > maxa then maxa = projected end
			end

			local minb = nil
			local maxb = nil
			for j=1,#b do
				local projected = normal.x * b[j].x + normal.y * b[j].y
				if not minb or projected < minb then minb = projected end
				if not maxb or projected > maxb then maxb = projected end
			end

			if maxa < minb or maxb < mina then
				print("polygons don't intersect!")
				return false
			end
		end
	end
	return true
end


local p1 = { vec2(0,0), vec2(0,10), vec2(30,10), vec2(30,0)  }

local p2 = { vec2(5,0), vec2(5,10), vec2(35,10), vec2(35,0)  }


local function rotate_point(p, a)
	local cosa = cos(rad(a))
	local sina = sin(rad(a))
	local x = (p.x * cosa) - (p.y * sina)
	local y = (p.y * cosa) + (p.x * sina)
	return vec2(x, y)
end


function M.__init()
	AREA_RECT = msg.url("#arearectfactory")
end

function M.area(options)
	local c = {}
	c.tag = "area"

	local width = options and options.width or 20
	local height = options and options.height or 20

	local shape = { vec2(), vec2(), vec2(), vec2() }
	local center = vec2()

	c.init = function()
		local pos = vmath.vector3(0)
		local rotation = nil
		local properties = nil
		local scale = vmath.vector3(math.max(width, height))
		local area_id = factory.create(AREA_RECT, pos, rotation, properties, scale)
		go.set_parent(area_id, c.object.id, false)
	end

	local registered_events = {}
	c.on_collide = function(tag, cb)
		local cancel = collision.on_collide(c.object.id, tag, function(object1, object2, cancel)
			cb(object2, cancel)
		end)
		registered_events[#registered_events + 1] = cancel
	end

	c.on_click = function(cb)
		local cancel = mouse.on_click(c.object.id, function(obejct, cancel)
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
	c.has_point = function(p)
		local object = c.object
		local a = object.angle or 0
		local c = object.pos or center

		local dist = rotate_point(c - p, -a)

		local topleft = shape[1]
		local topright = shape[2]
		local bottomleft = shape[3]
		local bottomright = shape[4]

		if dist.x > topleft.x and dist.y < topleft.y
		and dist.x < topright.x and dist.y < topright.y
		and dist.x > bottomleft.x and dist.y > bottomleft.y
		and dist.x < bottomright.x and dist.y > bottomright.y
		then
			return true
		end
		return false
	end

	local V2_ONE = vec2(1)
	local GREEN = vmath.vector4(0,1,0,1)
	c.update = function(dt)
		local object = c.object
		local comps = object.comps
		local sprite = comps.sprite
		local pos = comps.pos
		local s = object.scale or V2_ONE
		local a = object.angle or 0
		local w = (sprite and sprite.width or width) * s.x
		local h = (sprite and sprite.height or height) * s.y
		local c = object.pos or center

		local w2 = w / 2
		local h2 = h / 2

		shape[1] = vec2(-w2,  h2) -- topleft
		shape[2] = vec2( w2,  h2) -- topright
		shape[3] = vec2(-w2, -h2) -- bottomleft
		shape[4] = vec2( w2, -h2) -- bottomright

		local tl = c + rotate_point(shape[1], a)
		local tr = c + rotate_point(shape[2], a)
		local bl = c + rotate_point(shape[3], a)
		local br = c + rotate_point(shape[4], a)

		msg.post("@render:", "draw_line", { start_point = tl, end_point = tr, color = GREEN })
		msg.post("@render:", "draw_line", { start_point = tr, end_point = br, color = GREEN })
		msg.post("@render:", "draw_line", { start_point = br, end_point = bl, color = GREEN })
		msg.post("@render:", "draw_line", { start_point = bl, end_point = tl, color = GREEN })
	end

	c.on_input = function(action_id, action)
		local object = c.object
		--print("action", action.x, "pos", object.pos, "w,h", w, h)
	end


	return c
end

return M