return function()
	print("game")

	print(get_background())
	set_background(0, 0.5, 1, 1)

	local score = add({
		pos(20, 600),
		text("Score: 0"),
		{ score = 0 }
	})
	--pprint(score)

	local player = add({
		sprite("ship_0002"),
		pos(200, 180),
		--color(255, 0, 0),
		area()
	})
	player.on_collide("enemy", function(cancel)
		show("gameover")
	end)

	loop(1.5, function()
		local enemy = add({
			pos(rand(0, width()), height() - 20),
			sprite("ship_0005", { flip_y = true }),
			move(vec2.DOWN, 100),
			area(),
			"enemy",
		})
		enemy.on_collide("bullet", function(bullet)
			destroy(enemy)
			destroy(bullet)
			score.score = score.score + 1
			score.text = "Score: " .. tostring(score.score)
		end)
	end)

	on_key_press("key_space", function()
		add({
			area(),
			pos(player.pos),
			sprite("tile_0015"),
			move(vec2.UP, 700),
			"bullet"
		})
	end)

	on_key_press("key_left", function() player.move(-100, player.vel.y) end)
	on_key_press("key_right", function() player.move(100, player.vel.y) end)
	on_key_press("key_up", function() player.move(player.vel.x, 100) end)
	on_key_press("key_down", function() player.move(player.vel.x, -100) end)

	on_update(function(cancel)
		if not is_key_down("key_left") and not is_key_down("key_right") then
			player.move(0, player.vel.y)
		end
		if not is_key_down("key_up") and not is_key_down("key_down") then
			player.move(player.vel.x, 0)
		end
	end)
end