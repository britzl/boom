return function()

	local player = add({
		sprite("player_idle", { atlas = "platformer" }),
		pos(center()),
	})

	on_mouse_press(function()
		local dist = mouse_pos().dist(player.pos)
		local duration = dist / 300
		tween(player.pos, mouse_pos(), duration, go.EASING_LINEAR, function(val)
			player.pos.x = val.x
			player.pos.y = val.y
		end)
	end)
end