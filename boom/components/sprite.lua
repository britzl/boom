local M = {}

local sprite = _G.sprite

local SPRITE = hash("/sprite")

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
		local size = go.get(c.__url, "size")
		c.width = options and options.width or size.x
		c.height = options and options.height or size.y

		if c.object.scale then
			go.set(c.__url, "scale", c.object.scale)
		end
	end

	c.play = function(anim)
		c.object.anim = anim
		sprite.play_flipbook(c.__url, anim)
	end
	return c
end

return M