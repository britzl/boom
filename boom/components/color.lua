local color = require "boom.math.color"

local M = {}

---
-- Color of object
-- @param ... r,g,b components or color
function M.color(...)
	local c = {}
	c.tag = "color"
	c.color = color(...)

	c.init = function()
		local object = c.object
		if object.comps.sprite then
			local url = object.comps.sprite.__url
			local tint = go.get(url, "tint")
			tint.x = c.object.color.r
			tint.y = c.object.color.g
			tint.z = c.object.color.b
			go.set(url, "tint", tint)
		end
		if object.comps.text then
			local url = object.comps.text.__url
			local color = go.get(url, "color")
			color.x = c.object.color.r
			color.y = c.object.color.g
			color.z = c.object.color.b
			go.set(url, "color", color)
		end
	end

	return c
end

return M