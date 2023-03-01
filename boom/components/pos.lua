local vec2 = require "boom.math.vec2"

local M = {}

function M.pos(x, y)
	if type(x) == "userdata" then
		local pos = x
		x = pos.x
		y = pos.y
	end
	local c = {
		tag = "pos",
		pos = vec2(x, y),
		vel = vec2(0, 0),
	}

	c.init = function()
		go.set_position(c.object.pos, c.object.id)
	end

	c.move = function(xvel, yvel)
		c.object.vel.x = xvel
		c.object.vel.y = yvel
	end

	c.update = function(dt)
		local object = c.object
		local pos = object.pos
		local vel = object.vel
		pos.x = pos.x + vel.x * dt
		pos.y = pos.y + vel.y * dt
		go.set_position(pos, object.id)
	end
	
	return c
end

return M