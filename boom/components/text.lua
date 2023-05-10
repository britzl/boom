local M = {}

local text_left_factory_url = nil
local text_right_factory_url = nil
local text_center_factory_url = nil
local game_url = nil
local label_screen_material = nil

function M.__init(config)
	text_left_factory_url = "#textleftfactory"
	text_right_factory_url = "#textrightfactory"
	text_center_factory_url = "#textcenterfactory"
	game_url = config.game_url
	label_screen_material = config.label_screen_material
end

--- Render text.
-- @string text The text to show
-- @table options Text options (width, font, align)
-- @treturn TextComp component The created component
function M.text(text, options)
	local c = {}
	c.tag = "text"

	--- The text to render
	-- @type TextComp
	-- @field string
	c.text = text

	local width = options and options.width or sys.get_config_int("display.width")
	local align = options and options.align or "left"
	local font = options and options.font
	assert(align == "left" or align == "right" or align == "center", "Font align must be 'left', 'right' or 'center")

	c.init = function()
		local object = c.object
		local url = nil
		if align == "left" then
			local id = factory.create(text_left_factory_url)
			go.set_parent(id, object.id, false)
			url = msg.url(nil, id, "label")
		elseif align == "right" then
			local id = factory.create(text_right_factory_url)
			go.set_parent(id, object.id, false)
			url = msg.url(nil, id, "label")
		elseif align == "center" then
			local id = factory.create(text_center_factory_url)
			go.set_parent(id, object.id, false)
			url = msg.url(nil, id, "label")
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

		-- set to a fixed material if the object has the fixed component
		local fixed = c.object.comps.fixed
		if fixed then
			go.set(url, "material", label_screen_material)
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

		label.set_text(url, object.text or "")

		local scale = object.scale
		if scale then
			go.set(url, "scale", scale)
		end
	end

	c.destroy = function()
		go.delete(c.__url)
	end

	return c
end

return M