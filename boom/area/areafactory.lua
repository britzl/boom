local M = {}


function M.circle(radius, properties)
	local position = vmath.vector3(0)
	local rotation = nil
	local scale = vmath.vector3(radius * 2)
	local id = factory.create("areafactory#circle", position, rotation, properties, scale)
	return id
end


function M.rect(width, height, properties)
	local w = 1
	local h = 1
	local rotation = nil
	if width > height then
		h = math.ceil(width / height)
		rotation = vmath.quat_rotation_z(math.rad(90))
	else
		h = math.ceil(height / width)
	end
	h = math.min(h, 10)

	local position = vmath.vector3(0)
	local scale = vmath.vector3(math.min(width, height))
	local url = "areafactory#rect" .. w .. "x" .. h
	print(url)
	local id = factory.create(url, position, rotation, properties, scale)
	return id
end


return M