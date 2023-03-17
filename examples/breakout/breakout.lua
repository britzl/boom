return function()
	set_background(0, 0.5, 1, 1)

	-- create playing field of bricks
	local h = height()
	for x = 1, 10 do
		for y = 1, 6 do
			add({
				"brick",
				area(),
				sprite("element_green_rectangle", { atlas = "breakout" }),
				pos(x * 70, h - y * 40)
			})
		end
	end

	local paddle = add({
		"paddle",
		sprite("paddleRed", { atlas = "breakout" }),
		pos(width() / 2 , 50),
		area(),
	})

	local ball = add({
		"ball",
		sprite("ballGrey", { atlas = "breakout" }),
		pos(width() / 2 , paddle.pos.y + 25),
		area(),
		{ dir = vec2(0) },
		{ attached = true },
	})

	-- handle ball bounce on paddle
	paddle.on_collide("ball", function(ball)
		if ball.attached then return end
		if ball.dir.y < 0 then
			ball.dir.y = -ball.dir.y
			ball.dir.x = ((ball.pos.x - paddle.pos.x) / paddle.width) * 1.4
		end
	end)

	-- ball to brick collision
	-- bounce ball and destroy brick
	on_collide("ball", "brick", function(ball, brick)
		if ball.pos.y < brick.pos.y then
			if ball.dir.y > 0 then
				ball.dir.y = -ball.dir.y
			end
		elseif ball.pos.y > brick.pos.y then
			if ball.dir.y < 0 then
				ball.dir.y = -ball.dir.y
			end
		elseif ball.pos.x > brick.pos.x then
			if ball.dir.x < 0 then
				ball.dir.x = -ball.dir.x
			end
		elseif ball.pos.x < brick.pos.x then
			if ball.dir.x > 0 then
				ball.dir.x = -ball.dir.x
			end
		end
		destroy(brick)
	end)

	on_update(function()
		local w = width()
		local h = height()

		-- move paddle
		paddle.pos.x = mouse_pos().x
		-- limit to screen edges
		if paddle.pos.x + (paddle.width / 2) > w then
			paddle.pos.x = w - (paddle.width / 2)
		elseif paddle.pos.x - (paddle.width / 2) < 0 then
			paddle.pos.x = 0 + (paddle.width / 2)
		end

		-- follow paddle if ball is attached
		if ball.attached then
			print("attached")
			ball.pos.x = paddle.pos.x
			return
		end

		-- ball left and right wall bounce
		if ball.pos.x < 0 and ball.dir.x < 0 then
			ball.dir.x = -ball.dir.x
		elseif ball.pos.x > w and ball.dir.x > 0 then
			ball.dir.x = -ball.dir.x
		end

		-- game over if ball leaves bottom of screen
		-- bounce if hitting top of screen
		if ball.pos.y < 0 then
			ball.dir.x = 0
			ball.dir.y = 0
			ball.attached = true
			ball.pos.x = paddle.pos.x
			ball.pos.y = paddle.pos.y + 25
		elseif ball.pos.y > h and ball.dir.y > 0 then
			ball.dir.y = -ball.dir.y
		end

		ball.move(ball.dir * 200)
	end)

	-- launch ball if attached to paddle
	on_click(function()
		if ball.attached then
			ball.attached = false
			ball.dir.x = 0
			ball.dir.y = 1
		end
	end)

	--inspect()
end