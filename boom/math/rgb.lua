--- Color in RGBA format.
local observable = require("boom.internal.observable")

local M = {}

local new = nil
new = function(r, g, b, a)
	local color = {}
	local properties = {}
	
	--- The red color component
	-- @type Color
	-- @field number
	properties.r = r or 1.0

	--- The green color component
	-- @type Color
	-- @field number
	properties.g = g or 1.0

	--- The blue color component
	-- @type Color
	-- @field number
	properties.b = b or 1.0

	--- The alpha (tranparency) of the color
	-- @type Color
	-- @field number
	properties.a = a or 1.0

	--- Clone the Color.
	-- @type Color
	-- @treturn Color color The cloned color.
	color.clone = function()
		return new(properties.r, properties.g, properties.b, properties.a)
	end

	--- Lighten the Color.
	-- @type Color
	-- @number n Amount to lighten color by
	-- @treturn Color color The lighter color.
	color.lighten = function(n)
		return new(properties.r + n, properties.g + n, properties.b + n, properties.a)
	end

	--- Darkens the Color.
	-- @type Color
	-- @number n Amount to darken color by
	-- @treturn Color color The darker color.
	color.darken = function(n)
		return new(properties.r - n, properties.g - n, properties.b - n, properties.a)
	end

	--- Invert the Color.
	-- @type Color
	-- @treturn Color color The inverted color.
	color.invert = function()
		return new(1.0 - properties.r, 1.0 - properties.g, 1.0 - properties.b, properties.a)
	end

	observable.create(color, properties)
	local mt = getmetatable(color) or {}
	mt.__tostring = function(t)
		return ("color(%f, %f, %f, %f)"):format(properties.r, properties.g, properties.b, properties.a)
	end
	return setmetatable(color, mt)
end

local rgb = {}

--- Red color.
-- @type rgb
-- @field Color
rgb.RED = new(1, 0, 0, 1)

--- Green color.
-- @type rgb
-- @field Color
rgb.GREEN = new(0, 1, 0, 1)

--- Blue color.
-- @type rgb
-- @field Color
rgb.BLUE = new(0, 0, 1, 1)

--- Black color.
-- @type rgb
-- @field Color
rgb.BLACK = new(0, 0, 0, 1)

--- White color.
-- @type rgb
-- @field Color
rgb.WHITE = new(1, 1, 1, 1)

---
-- Create Color from a hex string.
-- @type rgb
-- @string hex Hex string in RGB, RGBA, RRGGBB or RRGGBBAA format (with optional initial #).
-- @treturn Color color The created color.
function rgb.from_hex(hex)
	local r, g, b, a
	if hex:sub(1,1) == "#" then hex = hex:sub(2) end
	if #hex == 3 then
		r = tonumber(hex:sub(1,1), 16) / 15
		g = tonumber(hex:sub(2,2), 16) / 15
		b = tonumber(hex:sub(3,3), 16) / 15
		a = 1
	elseif #hex == 4 then
		r = tonumber(hex:sub(1,1), 16) / 15
		g = tonumber(hex:sub(2,2), 16) / 15
		b = tonumber(hex:sub(3,3), 16) / 15
		a = tonumber(hex:sub(4,4), 16) / 15
	elseif #hex == 6 then
		r = tonumber(hex:sub(1,2), 16) / 255
		g = tonumber(hex:sub(3,4), 16) / 255
		b = tonumber(hex:sub(5,6), 16) / 255
		a = 1
	elseif #hex == 8 then
		r = tonumber(hex:sub(1,2), 16) / 255
		g = tonumber(hex:sub(3,4), 16) / 255
		b = tonumber(hex:sub(5,6), 16) / 255
		a = tonumber(hex:sub(7,8), 16) / 255
	end
	return new(r, g, b, a)
end

local mt = {
	__call = function(t, ...)
		return new(...)
	end
}

--- Create a Color.
-- @number r Red component (0.0 to 1.0)
-- @number g Green component (0.0 to 1.0)
-- @number b Blue component (0.0 to 1.0)
-- @number a Alpha component (0.0 to 1.0)
-- @treturn Color color The created color.
M.rgb = setmetatable(rgb, mt)

return setmetatable(M, mt)