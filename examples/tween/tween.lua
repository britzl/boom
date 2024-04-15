return function()

	local player = add({
		sprite("player_idle", { atlas = "platformer" }),
		pos(center()),
	})

	add({
		text("Click to animate to position"),
		pos(width() / 2,  20),
		scale(2)
	})

	local tween_controller = nil
	on_mouse_press(function()
		local world_pos = to_world(mouse_pos())
		local dist = world_pos.dist(player.pos)
		local duration = dist / 300
		if tween_controller then
			tween_controller.cancel()
		end
		tween_controller = tween(player.pos, world_pos, duration, go.EASING_LINEAR, function(val)
			player.pos.x = val.x
			player.pos.y = val.y
		end)
	end)
end