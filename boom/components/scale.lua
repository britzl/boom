return function(x, y)
	local c = {}
	c.tag = "scale"
	c.scale = vmath.vector3(x, y, 1)

	c.scale_to = function(x, y)
		local object = c.object
		local scale = object.scale
		scale.x = x
		scale.y = y or x
		go.set_scale(scale, object.id)
	end

	return c
end