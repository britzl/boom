local vec2 = require "boom.math.vec2"

local M = {}

local sprite = _G.sprite

local SPRITE = hash("/sprite")
local V2_ZERO = vec2()

local game_url = nil

function M.__init(_game_url)
	game_url = _game_url
end

---
-- Render as a sprite
-- @param anim Which animation or image to use
-- @param options Extra options (flip_x, flip_y, width, height)
-- @return The component
function M.sprite(anim, options)
	local c = {}
	c.tag = "sprite"
	c.anim = anim

	c.init = function()
		local url = msg.url(nil, c.object.ids[SPRITE], "sprite")
		c.__url = url
		msg.post(url, "enable")

		-- handle sprite options
		if options then
			if options.atlas then
				go.set(url, "image", go.get(game_url, options.atlas))
			end
			if options.flip_y then
				sprite.set_vflip(url, true)
			elseif options.flip_x then
				sprite.set_hflip(url, true)
			end
		end

		-- set correct animation
		sprite.play_flipbook(url, anim)
	end

	c.update = function(dt)
		local object = c.object
		local url = c.__url

		local color = object.color
		local opacity = object.opacity
		if color or opacity then
			local tint = go.get(url, "tint")
			tint.x = color and color.r or tint.x
			tint.y = color and color.g or tint.y
			tint.z = color and color.b or tint.z
			tint.w = opacity or tint.w
			go.set(url, "tint", tint)
		end

		local size = go.get(url, "size")
		local width = options and options.width or size.x
		local height = options and options.height or size.y
		c.width = width
		c.height = height

		local scale = object.scale
		if scale then
			go.set(url, "scale", scale)
		end

		local anchor = object.anchor
		if anchor then
			local p = vec2()
			local w = width * (scale and scale.x or 1)
			local h = height * (scale and scale.y or 1)
			p.x = (w / 2) * anchor.x
			p.y = (h / 2) * anchor.y
			go.set_position(p, url)
		end
	end

	c.play = function(anim)
		c.object.anim = anim
		sprite.play_flipbook(c.__url, anim)
	end
	return c
end

return M