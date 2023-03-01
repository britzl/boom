local M = {}

function M.color(r, g, b)
	local c = {}
	c.tag = "color"
	c.r = r / 255
	c.g = g / 255
	c.b = b / 255
	
	local url = nil

	c.init = function()
		url = msg.url(nil, c.object.id, "sprite")
		local tint = go.get(url, "tint")
		tint.x = c.object.r
		tint.y = c.object.g
		tint.z = c.object.b
		go.set(url, "tint", tint)
	end
	return c
end

return M