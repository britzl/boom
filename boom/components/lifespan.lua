local gameobject = require "boom.gameobject.gameobject"

local M = {}

---
-- Destroy the game obj after certain amount of time
-- @param time
-- param options (fade)
function M.lifespan(time, options)
	assert(time and time > 0)
	local c = {}
	c.tag = "lifespan"

	local fade = options and options.fade or 0

	c.init = function()
		if fade <= time then
			local object = c.object
			local comps = object.comps

			local sprite = comps.sprite
			if sprite then
				go.animate(sprite.__url, "tint.w", go.PLAYBACK_ONCE_FORWARD, 0, go.EASING_LINEAR, fade, (time - fade))
			end

			local text = comps.text
			if text then
				go.set(text.__url, "color.w", 0)
				go.animate(text.__url, "color.w", go.PLAYBACK_ONCE_FORWARD, 1, go.EASING_LINEAR, fade, (time - fade))
			end
		end

		timer.delay(time, false, function()
			gameobject.destroy(c.object)
		end)
	end

	return c
end

return M