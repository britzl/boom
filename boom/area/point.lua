local M = {}

local cos = _G.math.cos
local sin = _G.math.sin
local rad = _G.math.rad

-- rotate a point (vec2)
-- the provided point will be modified
function M.rotate_point_inline(p, a)
	if not a or a == 0 then return end
	if p.x == 0 and p.y == 0 then return end
	local cosa = cos(rad(a))
	local sina = sin(rad(a))
	local x = (p.x * cosa) - (p.y * sina)
	local y = (p.y * cosa) + (p.x * sina)
	p.x = x
	p.y = y
end



return M