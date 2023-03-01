local M = {}

local sprite = _G.sprite

function M.sprite(anim, options)
	local c = {}
	c.tag = "sprite"
	c.anim = anim

	local url = nil
	
	c.init = function()
		url = msg.url(nil, c.object.id, "sprite")
		msg.post(url, "enable")
		sprite.play_flipbook(url, anim)
		if options then
			if options.flip_y then
				sprite.set_vflip(url, true)
			elseif options.flip_h then
				sprite.set_hflip(url, true)
			end
		end
	end
	
	c.play = function(anim)
		c.object.anim = anim
		defoldsprite.play_flipbook(url, anim)
	end
	return c
end

return M