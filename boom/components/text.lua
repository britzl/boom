local M = {}

local game_url = nil

function M.__init(_game_url)
	game_url = _game_url
end

local LABEL_LEFT = hash("/label_left")
local LABEL_RIGHT = hash("/label_right")
local LABEL_CENTER = hash("/label_center")

---
-- A text component
-- @params text The text to show
-- @params options Text options (width, font, align)
-- @return The component
function M.text(text, options)
	local c = {}
	c.tag = "text"
	c.text = text

	local width = options and options.width or sys.get_config_int("display.width")
	local align = options and options.align or "left"
	local font = options and options.font
	assert(align == "left" or align == "right" or align == "center", "Font align must be 'left', 'right' or 'center")

	c.init = function()
		local object = c.object
		local url = nil
		if align == "left" then
			go.delete(object.ids[LABEL_RIGHT])
			go.delete(object.ids[LABEL_CENTER])
			url = msg.url(nil, object.ids[LABEL_LEFT], "label")
		elseif align == "right" then
			go.delete(object.ids[LABEL_LEFT])
			go.delete(object.ids[LABEL_CENTER])
			url = msg.url(nil, object.ids[LABEL_RIGHT], "label")
		elseif align == "center" then
			go.delete(object.ids[LABEL_LEFT])
			go.delete(object.ids[LABEL_RIGHT])
			url = msg.url(nil, object.ids[LABEL_CENTER], "label")
		else
			error("This should not happen")
		end
		c.__url = url
		msg.post(url, "enable")
		go.set(url, "size.x", width)
		if font then
			local font_hash = go.get(game_url, font)
			go.set(url, "font", font_hash)
		end
	end

	c.update = function(dt)
		local url = c.__url
		local object = c.object

		local color = object.color
		local opacity = object.opacity
		if color or opacity then
			local text_color = go.get(url, "color")
			text_color.x = color and color.r or text_color.x
			text_color.y = color and color.g or text_color.y
			text_color.z = color and color.b or text_color.z
			text_color.w = opacity or text_color.w
			go.set(url, "color", text_color)
		end

		-- worth checking if text has changed?
		label.set_text(url, object.text)

		local scale = object.scale
		if scale then
			go.set(url, "scale", scale)
		end
	end

	return c
end

return M