local M = {}

function M.offset_inline(circle, offset)
	circle.center = circle.center + offset
end

function M.resize(circle, radius)
	circle.radius = radius
end


function M.create(circle)
	return {
		radius = circle and circle.radius or 0,
		center = vec2(circle and circle.center),
	}
end

function M.copy(from, to)
	to.radius = from.radius
	to.center.x = from.center.x
	to.center.y = from.center.y
end


function M.point_inside(p, circle, center, angle)
	-- rotate distance vector from area center to point onto rect
	local distance = vmath.length(center - p)
	return distance <= circle.radius
end

return M