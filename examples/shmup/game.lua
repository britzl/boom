return function()
	print("game")
	set_background(0, 0.5, 1, 1)

	local score = add({
		pos(20, height() - 30),
		text("Score: 0", { font = "upheaval", align = "left" }),
		fixed(),
		{ score = 0 }
	})
	--pprint(score)

	loop(0.1, function()
		local enemy = add({
			pos(rand(0, width()), height() + 40),
			sprite("ship_0005", { flip_y = true, atlas = "shmup" }),
			move(vec2.DOWN, 100),
			area(),
			health(3),
			offscreen({ destroy = true, distance = 100}),
			"enemy",
		})
		enemy.on_collide("bullet", function(collision)
			destroy(collision.target)
			enemy.hurt(1)
		end)
		enemy.on_death(function()
			destroy(enemy)
			score.score = score.score + 1
			score.text = "Score: " .. tostring(score.score)
		end)
	end)


	local player = add({
		sprite("ship_0002", { atlas = "shmup" }),
		pos(200, 180),
		--color(1, 0, 0),
		area(),
	})
	player.on_collide("enemy", function(collision)
		show("shmup-gameover")
	end)

	on_key_press("key_space", function()
		add({
			area(),
			pos(player.pos),
			sprite("tile_0015", { atlas = "shmup" }),
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

		--cam_pos(player.pos.x, height()  / 2)
	end)
end