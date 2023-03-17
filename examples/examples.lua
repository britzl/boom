return function()

	local function add_button(txt, p, fn)
		local btn = add({
			sprite("grey_button00", { atlas = "ui" }),
			pos(p),
			area(),
			rotate(math.random(0,180)),
			scale(2),
			--anchor("center"),
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


	local p = vec2(width() / 2, height() - 40)
	local shmup = add_button("shmup", p, function()
		show("shmup")
	end)

	local p = vec2(width() / 2, height() - 150)
	local foo = add_button("foo", p, function()
		print("foo")
	end)



	on_click("button", function(o)
		print("a button was clicked")
	end)
	on_update(function()
		foo.pos = mouse_pos()
		if foo.check_collision(shmup) then
			print("collide")
		end
	end)
	
end