local function tile(id)
	return function()
		return {
			sprite(id, { atlas = "platformer" }),
			area(),
			body({ is_static = true }),
		}
	end
end

return function()
	set_background(0, 0.5, 1, 1)

	local map = {
		"      []        ",
		"  [#]           ",
		"                ",
		"                ",
		"[######]    [##]",
	}
	local options = {
		tile_width = 18,
		tile_height = 18,
		tiles = {
			["#"] = tile("tile_0002"),
			["["] = tile("tile_0001"),
			["]"] = tile("tile_0003"),
		}
	}
	--add_level(map, options)

	local player = add({
		sprite("character_0000", { atlas = "platformer" }),
		area(),
		body(),
		pos(40, 200),
	})
	
	add({
		sprite("paddleRed", { atlas = "breakout" }),
		area(),
		body({ is_static = true }),
		pos(40, 100),
	})
	
	on_key_press("key_space", function() player.jump(400) end)

	on_key_press("key_left", function() player.move(-100, player.vel.y) end)
	on_key_press("key_right", function() player.move(100, player.vel.y) end)

	on_update(function(cancel)
		if not is_key_down("key_left") and not is_key_down("key_right") then
			player.move(0, player.vel.y)
		end

		cam_pos(player.pos.x, player.pos.y)
	end)

	inspect()

end