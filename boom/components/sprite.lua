local vec2 = require "boom.math.vec2"

local M = {}

local sprite = _G.sprite

local SPRITE = hash("/sprite")
local V2_ZERO = vec2()

local game_url = nil
local sprite_screen_material = nil

function M.__init(config)
	game_url = config.game_url
	sprite_screen_material = config.sprite_screen_material
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
	c.width = 1
	c.height = 1
	c.flip_x = options.flip_x
	c.flip_y = options.flip_y

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
			end
			if options.flip_x then
				sprite.set_hflip(url, true)
			end
		end

		-- set correct animation
		sprite.play_flipbook(url, anim)

		-- set to a fixed material if the object has the fixed component
		local fixed = c.object.comps.fixed
		if fixed then
			go.set(url, "material", sprite_screen_material)
		end
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
		object.width = width
		object.height = height

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
			p.z = object.z or 0
			go.set_position(p, url)
		end

		sprite.set_vflip(url, object.flip_y)
		sprite.set_hflip(url, object.flip_x)
	end

	---
	-- Play an animation
	-- @param anim The animation to play
	c.play = function(anim)
		local object = c.object
		if object.anim ~= anim then
			object.anim = anim
			sprite.play_flipbook(c.__url, anim)
		end
	end

	---
	-- Stop the current animation
	c.stop = function()
		go.set(c.__url, "playback_rate", 0)
	end
	return c
end

return M