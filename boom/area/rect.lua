local vec2 = require "boom.math.vec2"
local point = require "boom.area.point"


local M = {}


-- apply an offset to a rect
-- the provided rect will be modified
function M.offset_inline(rect, offset)
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
function M.rotate_inline(rect, angle)
	if not angle or angle == 0 then return end
	point.rotate_point_inline(rect.topleft, angle)
	point.rotate_point_inline(rect.topright, angle)
	point.rotate_point_inline(rect.bottomleft, angle)
	point.rotate_point_inline(rect.bottomright, angle)
	point.rotate_point_inline(rect.center, angle)
end


-- To find if a point is inside your rectangle, take the distance-vector
-- from the rectangle center to this point and rotate it backward (by the
-- angle -a). Then check if it is inside the corresponding unrotated
-- rectangle
-- https://love2d.org/forums/viewtopic.php?p=69469&sid=4a77ba2c0052546e8b7a6d32c74fdbcc#p69469

function M.point_inside(p, rect, center, angle)
	-- rotate distance vector from area center to point onto rect
	local distance = center - p
	point.rotate_point_inline(distance, -angle)

	local topleft = rect.topleft
	local topright = rect.topright
	local bottomleft = rect.bottomleft
	local bottomright = rect.bottomright

	-- check if distance vector is within the unrotated rect
	local inside = distance.x > topleft.x and distance.y < topleft.y
	and distance.x < topright.x and distance.y < topright.y
	and distance.x > bottomleft.x and distance.y > bottomleft.y
	and distance.x < bottomright.x  and distance.y > bottomright.y

	return inside
end


function M.resize(rect, w, h)
	local w2 = w / 2
	local h2 = h / 2
	-- make sure the local space unrotated rect is of correct size
	-- (in case the width or height has changed)
	-- local space rect does not have an offset
	rect.topleft.x = -w2
	rect.topleft.y = h2
	rect.topright.x = w2
	rect.topright.y =  h2
	rect.bottomleft.x = -w2
	rect.bottomleft.y = -h2
	rect.bottomright.x = w2
	rect.bottomright.y = -h2
end

-- create a rect, either a new empty rect or a copy of another rect
function M.create(rect)
	return {
		topleft = vec2(rect and rect.topleft),
		topright = vec2(rect and rect.topright),
		bottomleft = vec2(rect and rect.bottomleft),
		bottomright = vec2(rect and rect.bottomright),
		center = vec2(rect and rect.center),
	}
end

function M.copy(from, to)
	to.topleft.x = from.topleft.x
	to.topleft.y = from.topleft.y
	to.topright.x = from.topright.x
	to.topright.y = from.topright.y
	to.bottomleft.x = from.bottomleft.x
	to.bottomleft.y = from.bottomleft.y
	to.bottomright.x = from.bottomright.x
	to.bottomright.y = from.bottomright.y
	to.center.x = from.center.x
	to.center.y = from.center.y
end


return M