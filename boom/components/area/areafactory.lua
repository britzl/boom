local M = {}

local circle_factory_url = nil
local rect_factory_url = nil

local HASH_CIRCLE = hash("circle")
local HASH_RECT = hash("rect")

local V3_ZERO = vmath.vector3(0)

local CIRCLE_DATA = {
	type = physics.SHAPE_TYPE_SPHERE,
	diameter = 1,
}

local RECT_DATA = {
	type = physics.SHAPE_TYPE_BOX,
	dimensions = vmath.vector3(1, 1, 1),
}

function M.init()
	circle_factory_url = msg.url("#circle")
	rect_factory_url = msg.url("#rect")
end

function M.circle(radius, properties)
	local position = V3_ZERO
	local id = factory.create(circle_factory_url, position)
	local url = msg.url(nil, id, "collisionobject")

	CIRCLE_DATA.diameter = radius * 2
	physics.set_shape(url, HASH_CIRCLE, CIRCLE_DATA)
	physics.set_group(url, properties.group)
	physics.set_maskbit(url, hash("area"), properties.area_mask)
	physics.set_maskbit(url, hash("static"), properties.static_mask)
	return url
end


function M.rect(width, height, properties)
	local position = V3_ZERO
	local id = factory.create(rect_factory_url, position)
	local url = msg.url(nil, id, "collisionobject")

	RECT_DATA.dimensions.x = width
	RECT_DATA.dimensions.y = height
	physics.set_shape(url, HASH_RECT, RECT_DATA)
	physics.set_group(url, properties.group)
	physics.set_maskbit(url, hash("area"), properties.area_mask)
	physics.set_maskbit(url, hash("static"), properties.static_mask)
	return url
end


return M