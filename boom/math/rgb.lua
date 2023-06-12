local M = {}

local function new(r, g, b, a)
	local tr = type(r)
	if tr == "table" then
		local t = r
		r = t.r
		g = t.g
		b = t.b
		a = t.a
	elseif tr == "string" then
		local hex = r
		if hex:sub(1,1) == "#" then hex = hex:sub(2) end
		if #hex == 3 then
			r = tonumber(hex:sub(1,1), 16) / 16
			g = tonumber(hex:sub(2,2), 16) / 16
			b = tonumber(hex:sub(3,3), 16) / 16
			a = 1
		elseif #hex == 4 then
			r = tonumber(hex:sub(1,1), 16) / 16
			g = tonumber(hex:sub(2,2), 16) / 16
			b = tonumber(hex:sub(3,3), 16) / 16
			a = tonumber(hex:sub(4,4), 16) / 16
		elseif #hex == 6 then
			r = tonumber(hex:sub(1,2), 16) / 256
			g = tonumber(hex:sub(3,4), 16) / 256
			b = tonumber(hex:sub(5,6), 16) / 256
			a = 1
		elseif #hex == 8 then
			r = tonumber(hex:sub(1,2), 16) / 256
			g = tonumber(hex:sub(3,4), 16) / 256
			b = tonumber(hex:sub(5,6), 16) / 256
			a = tonumber(hex:sub(7,8), 16) / 256
		end
	end
	r = r or 1.0
	g = g or 1.0
	b = b or 1.0
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

local rgb = {}

rgb.RED = new(1, 0, 0, 1)
rgb.GREEN = new(0, 1, 0, 1)
rgb.BLUE = new(0, 0, 1, 1)
rgb.BLACK = new(0, 0, 0, 1)
rgb.WHITE = new(1, 1, 1, 1)

local mt = {
	__call = function(t, ...)
		return new(...)
	end
}

M.rgb = setmetatable(rgb, mt)

return setmetatable(M, mt)