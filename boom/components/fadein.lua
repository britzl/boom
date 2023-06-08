--- Fade in game object visual components such as sprites.
-- @usage
-- add({
--     text("Hello World"),
--     fadein(2)
-- })

local M = {}

--- Fade object in.
-- @number time In seconds
-- @treturn FadeInComp component The fade in component.
function M.fadein(time)
	local c = {}
	c.tag = "fadein"

	c.init = function()
		local object = c.object
		local comps = object.comps

		local sprite = comps.sprite
		if sprite then
			go.set(sprite.__url, "tint.w", 0)
			go.animate(sprite.__url, "tint.w", go.PLAYBACK_ONCE_FORWARD, 1, go.EASING_LINEAR, time)
		end

		local text = comps.text
		if text then
			go.set(text.__url, "color.w", 0)
			go.animate(text.__url, "color.w", go.PLAYBACK_ONCE_FORWARD, 1, go.EASING_LINEAR, time)
		end
	end

	return c
end

return M