return function()
	cam_pos(width() / 2, height()  / 2)

	add({
		text("GAME OVER", { font = "upheaval", align = "center" }),
		pos(width() / 2, height() / 2)
	})

	on_click(function()
		show("examples")
	end)
	on_key_press(function()
		show("examples")
	end)
end