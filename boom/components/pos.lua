return function(x, y)
	if type(x) == "userdata" then
		local pos = x
		x = pos.x
		y = pos.y
	end
	local c = {
		tag = "pos",
		pos = vmath.vector3(x, y, 0)
	}

	local _xvel = 0
	local _yvel = 0

	c.move = function(xvel, yvel)
		_xvel = xvel
		_yvel = yvel
	end

	c.update = function(dt)
		local object = c.object
		local pos = object.pos
		pos.x = pos.x + _xvel * dt
		pos.y = pos.y + _yvel * dt
		go.set_position(pos, object.id)
	end
	
	return c
end