--- Position of a game object.
-- @usage
-- -- this game object will draw a "bean" sprite at (100, 200)
-- add({
--    pos(100, 200),
--    sprite("bean")
-- })

local vec2 = require "boom.math.vec2"

local M = {}

local function to_vec2(x, y)
	if not x then return nil end
	if x and y then return vec2(x, y) end
	return x
end

local function to_xy(x, y)
	if not x then return 0, 0 end
	if x and y then return x, y end
	local v2 = x
	return v2.x, v2.y
end

--- Create a position component.
-- @number x
-- @number y
-- @treturn PosComp component The created component
function M.pos(x, y)
	local typex = type(x)
	if typex == "userdata" then
		local pos = x
		x = pos.x
		y = pos.y
	elseif typex == "table" then
		local pos = x
		x = pos.x
		y = pos.y
	end

	local c = {}
	c.tag = "pos"
	c.pos = vec2(x, y)
	c.vel = vec2(0, 0)

	local v3 = vmath.vector3(x, y, 0)

	c.init = function()
		go.set_position(v3, c.object.id)
		--go.set_position(c.object.pos, c.object.id)
	end

	--- Move a number of pixels per second.
	-- @type PosComp
	-- @number x
	-- @number y
	c.move = function(...)
		local xvel, yvel = to_xy(...)
		local object = c.object
		object.vel.x = xvel
		object.vel.y = yvel
	end

	c.update = function(dt)
		local object = c.object
		local vel = object.vel
		local pos = object.pos
		if vel.x ~= 0 or vel.y ~= 0 then
			pos.x = pos.x + vel.x * dt
			pos.y = pos.y + vel.y * dt
		end
		v3.x = pos.x
		v3.y = pos.y
		go.set_position(v3, object.id)
		--go.set_position(pos, object.id)
	end

	return c
end

return M