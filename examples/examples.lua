return function()

	--inspect()

	local function add_button(txt, p, fn)
		local btn = add({
			sprite("grey_button00", { atlas = "ui" }),
			pos(p),
			area(),
			scale(1),
			"button",
		})
		btn.add({
			pos = vec2(0, 0),
			text(txt, { font = "upheaval", align = "center" }),
			color(0,0,0),
		})
		btn.on_click(fn)
		return btn
	end

	local BUTTONS = { "shmup", "breakout", "platformer", "flappy", "tween", "components" }

	for i=1,#BUTTONS do
		local b = BUTTONS[i]
		local p = vec2(width() / 2, height() - i * 60)
		BUTTONS[b] = add_button(b, p, function() show(b) end)
	end
end