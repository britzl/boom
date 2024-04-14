local function game()
	set_gravity(2000)

	local score = 0

	local score_text = add({
		text(""),
		scale(3),
		pos(width() / 2, height() - 30)
	})

	local player = add({
		sprite("glide", { atlas = "flappy" }),
		pos(width() / 2, height() / 2),
		area({ shape = "circle", radius = 6 }),
		scale(3),
		body()
	})

	on_update(function()
		if player.pos.y > height() or player.pos.y < 0 then
			show("lose", score)
		end
	end)

	on_update("pipe", function(pipe, dt)
		if pipe.passed then return end
		if player.pos.x > (pipe.pos.x + pipe.width) then
			pipe.passed = true
			score = score + 1
			score_text.text = score
		end
	end)

	on_key_press("key_space", function()
		player.jump(400)
		player.play("fly")
	end)

	on_key_release("key_space", function()
		player.play("glide")
	end)

	loop(1, function()
		local offset = rand(-170, 170)
		add({
			sprite("column", { atlas = "flappy" }),
			pos(width() + 20, height() + 40 - offset),
			area(),
			offscreen({ destroy = true, distance = 200 }),
			scale(3),
			move(LEFT, 320),
			{ passed = true },
			"pipe"
		})
		add({
			sprite("column", { atlas = "flappy" }),
			pos(width() + 20, 0 - 40 - offset),
			area(),
			offscreen({ destroy = true, distance = 200 }),
			scale(3),
			move(LEFT, 320),
			"pipe"
		})
	end)

	player.on_collide("pipe", function()
		show("lose", score)
	end)

end

local function lose(score)
	add({
		sprite("glide", { atlas = "flappy" }),
		pos(width() / 2, height() / 2),
		scale(3),
		anchor("center")
	})

	add({
		text(score, { align = "center" }),
		pos(width() / 2, height() / 2 - 100),
		scale(3),
		anchor("center")
	})

	on_click(function()
		show("game")
	end)

	on_key_press("key_space", function()
		show("game")
	end)
end



return function()
	set_background(0.2, 0.4, 1.0)

	scene("game", game)
	scene("lose", lose)

	show("lose", 100)
end