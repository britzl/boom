local M = {}

---
-- Opacity of object
-- @param opacity 0.0 to 1.0
-- @return The component
function M.opacity(opacity)
	local c = {}
	c.tag = "opacity"
	c.opacity = opacity

	c.init = function()
		local object = c.object
		if object.comps.sprite then
			local url = object.comps.sprite.__url
			go.set(url, "tint.w", c.object.opacity)
		end
		if object.comps.text then
			local url = object.comps.text.__url
			go.set(url, "color.w", c.object.opacity)
		end
	end

	return c
end

return M