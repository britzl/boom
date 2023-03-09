return function()
	add({
		text("GAME OVER"),
		pos(width() / 2, height() / 2)
	})

	on_click(function()
		show("examples")
	end)
	on_key_press(function()
		show("examples")
	end)
end