local M = {}

local function new(r, g, b, a)
	if type(r) == "table" then
		local t = r
		r = t.r
		g = t.g
		b = t.b
		a = t.a
	end
	r = r or 0
	g = g or 0
	b = b or 0
	a = a or 1.0

	local color = { r = r, g = g, b = b, a = a }
	return setmetatable(color, {
		__tostring = function(t)
			return ("color(%f, %f, %f, %f)"):format(t.r, t.g, t.b, t.a)
		end
	})
end

function M.clone(t)
	return new(t)
end

local color = {}

color.RED = new(1, 0, 0, 1)
color.GREEN = new(0, 1, 0, 1)
color.BLUE = new(0, 0, 1, 1)
color.BLACK = new(0, 0, 0, 1)
color.WHITE = new(1, 1, 1, 1)

local mt = {
	__call = function(t, ...)
		return new(...)
	end
}

M.color = setmetatable(color, mt)

return setmetatable(M, mt)