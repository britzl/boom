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
	cam_zoom(2)
	set_background(0, 0.5, 1, 1)
	set_gravity(300)

	local map = {
		"      []        ",
		"  [#]           ",
		"                ",
		"                ",
		"[######]    [##]",
	}
	local map = {
		"                      !                                                                            ########   ###!               !           ###    #!!#                                                          ##",
		"                                                                                                                                                                                                                 ###",
		"                                                                                                                                                                                                                ####",
		"                                                                                  !                                                                                                                            #####",
		"                !   [!#!]                           ##                     ##                   #!#              #     ##     !  !  !     #          ##       #  #          ##  #            ##!#             ######",
		"                                         ##         ##                     ##                                                                                ##  ##        ###  ##                           #######",
		"                             ##          ##         ##                     ##                                                                               ###  ###      ####  ###     ##               ## ########",
		"                             ##          ##         ##                     ##                                                                              ####  ####    #####  ####    ##               ###########",
		"#######################################################################################  ################   ##################################################################  ####################################",
		"#######################################################################################  ################   ##################################################################  ####################################",
		"123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890",
	}
	local options = {
		tile_width = 18,
		tile_height = 18,
		tiles = {
			["#"] = tile("tile_0002"),
			["["] = tile("tile_0001"),
			["]"] = tile("tile_0003"),
			["!"] = tile("tile_0010"),
		}
	}
	add_level(map, options)

	local player = add({
		sprite("character_0000", { atlas = "platformer" }),
		area({ shape = "circle" }),
		body(),
		pos(40, 200),
	})

	on_key_press("key_space", function() player.jump(220) end)

	on_key_press("key_left", function() player.move(-60, player.vel.y) end)
	on_key_press("key_right", function() player.move(60, player.vel.y) end)

	on_update(function(cancel)
		if not is_key_down("key_left") and not is_key_down("key_right") then
			player.move(0, player.vel.y)
		end

		cam_pos(player.pos.x, player.pos.y)
	end)

	--inspect()

end