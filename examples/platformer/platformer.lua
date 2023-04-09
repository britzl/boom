local function tile(id)
	return function()
		return {
			sprite(id, { atlas = "platformer" }),
			area(),
			body({ is_static = true }),
			{ name = "tile" },
		}
	end
end

local function bump(id)
	return function()
		return {
			sprite(id, { atlas = "platformer" }),
			area(),
			body({ is_static = true }),
			"bump",
			{ name = "bump" },
		}
	end
end

return function()
	cam_zoom(2)
	set_background(0, 0.5, 1, 1)
	set_gravity(300)
	local map = {
		"                ",
		"                ",
		"                ",
		"                ",
		"                ",
		"  #             ",
		"  #             ",
		"  #             ",
	}
	
	local map = {
		"                      !                                                                            [======]   [=]!               !           [=]    [!!]                                                          XX",
		"                                                                                                                                                                                                                 XXX",
		"                                                                                                                                                                                                                XXXX",
		"                                                                                  !                                                                                                                            XXXXX",
		"                !   [!=!]                           AB                     AB                   [!]              O     []     !  !  !     O          []       X  X          XX  X            [=!]             XXXXXX",
		"                                         AB         CD                     CD                                                                                XX  XX        XXX  XX                           XXXXXXX",
		"                             AB          CD         CD                     CD                                                                               XXX  XXX      XXXX  XXX     12               12 XXXXXXXX",
		"                             CD          CD         CD                     CD                                                                              XXXX  XXXX    XXXXX  XXXX    34               34XXXXXXXXX",
		"#######################################################################################.  ,##############.   ,################################################################  ####################################",
		"----------------------------------------------------------------------------------------  ----------------   -----------------------------------------------------------------  ------------------------------------",
		"123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890",
	}

	local options = {
		tile_width = 18,
		tile_height = 18,
		tiles = {
			["O"] = tile("tile_0000"),
			["["] = tile("tile_0001"),
			["="] = tile("tile_0002"),
			["]"] = tile("tile_0003"),

			[","] = tile("tile_0021"),
			["#"] = tile("tile_0022"),
			["."] = tile("tile_0023"),

			["X"] = tile("tile_0047"),

			["-"] = tile("tile_0122"),
			["!"] = bump("tile_0010"),

			["A"] = tile("tile_0095_1"),
			["B"] = tile("tile_0095_2"),
			["C"] = tile("tile_0115_1"),
			["D"] = tile("tile_0115_2"),
		}
	}
	add_level(map, options)

	local player = add({
		sprite("character_0001", { atlas = "platformer" }),
		area({ shape = "circle" }),
		anchor("bottom"),
		body(),
		pos(40, 50),
		"player",
		{ name = "player" },
	})

	player.on_collide("bump", function(data)
		print("bump")
	end)

	on_key_press("key_space", function() if player.is_grounded then player.jump(220) end end)
	on_key_press("key_left", function()
		player.move(-60, player.vel.y)
		player.play("player_walk")
		player.flip_x = false
	end)
	on_key_press("key_right", function()
		player.move(60, player.vel.y)
		player.play("player_walk")
		player.flip_x = true
	end)

	on_update(function(cancel)
		if not is_key_down("key_left") and not is_key_down("key_right") then
			player.move(0, player.vel.y)
			player.play("player_idle")
		end

		if player.pos.x < 0 then player.pos.x = 0 end

		cam_pos(player.pos.x, 169)
	end)

	--inspect()

end