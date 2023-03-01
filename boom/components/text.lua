local M = {}

function M.text(text)
	local c = {}
	c.tag = "text"
	c.text = text

	local url = nil

	c.init = function()
		url = msg.url(nil, c.object.id, "label")
		msg.post(url, "enable")
	end

	c.update = function(dt)
		-- worth checking if text has changed?
		label.set_text(url, c.object.text)
	end

	return c
end

return M