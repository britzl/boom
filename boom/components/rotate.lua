local function update_rotation(object)
	go.set_rotation(vmath.quat_rotation_z(math.rad(object.angle)), object.id)
end

return function(angle)
	local c = {}
	c.tag = "rotate"
	c.angle = angle

	c.init = function()
		update_rotation(c.object)
	end
	c.rotate = function(angle)
		c.angle = angle
		update_rotation(c.object)
	end

	return c
end