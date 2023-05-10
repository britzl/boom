local vec2 = require "boom.math.vec2"

local M = {}

local sprite = _G.sprite

local SPRITE = hash("/sprite")
local V2_ZERO = vec2()

local factory_url = nil
local game_url = nil
local sprite_screen_material = nil

function M.__init(config)
	factory_url = msg.url("#spritefactory")
	game_url = config.game_url
	sprite_screen_material = config.sprite_screen_material
end

--- Render a sprite.
-- @string anim Which animation or image to use
-- @table options Extra options (flip_x, flip_y, width, height)
-- @treturn SpriteComp component The created component
function M.sprite(anim, options)
	local c = {}
	c.tag = "sprite"

	--- The current animation
	-- @type SpriteComp
	-- @field string
	c.anim = anim

	--- The width of the sprite
	-- @type SpriteComp
	-- @field number
	c.width = 1

	--- The height of the sprite
	-- @type SpriteComp
	-- @field number
	c.height = 1

	--- If sprite should be flipped horizontally
	-- @type SpriteComp
	-- @field bool
	c.flip_x = options and options.flip_x

	--- If the sprite should be flipped vertically
	-- @type SpriteComp
	-- @field bool
	c.flip_y = options and options.flip_y

	c.init = function()
		local object = c.object

		local id = factory.create(factory_url)
		go.set_parent(id, object.id, false)

		local url = msg.url(nil, id, "sprite")
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
		local fixed = object.comps.fixed
		if fixed then
			go.set(url, "material", sprite_screen_material)
		end
	end

	c.destroy = function()
		go.delete(c.__url)
	end

	c.pre_update = function(dt)
		local object = c.object
		local url = c.__url
		local size = go.get(url, "size")
		local width = options and options.width or size.x
		local height = options and options.height or size.y

		object.width = width
		object.height = height
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

		local scale = object.scale
		if scale then
			go.set(url, "scale", scale)
		end

		local anchor = object.anchor
		if anchor then
			local p = vec2()
			local w = object.width * (scale and scale.x or 1)
			local h = object.height * (scale and scale.y or 1)
			p.x = (w / 2) * anchor.x
			p.y = (h / 2) * anchor.y
			p.z = object.z or 0
			go.set_position(p, url)
		end

		sprite.set_vflip(url, object.flip_y)
		sprite.set_hflip(url, object.flip_x)
	end

	--- Play an animation
	-- @type Sprite
	-- @string anim The animation to play
	c.play = function(anim)
		local object = c.object
		if object.anim ~= anim then
			object.anim = anim
			sprite.play_flipbook(c.__url, anim)
		end
	end

	--- Stop the current animation
	-- @type Sprite
	c.stop = function()
		go.set(c.__url, "playback_rate", 0)
	end
	return c
end

return M