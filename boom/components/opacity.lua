return function(opacity)
	local c = {}
	c.tag = "opacity"
	c.opacity = opacity

	local url = nil

	c.init = function()
		url = msg.url(nil, c.object.id, "sprite")
		go.set(url, "tint.w", c.object.opacity)
	end
	return c
end