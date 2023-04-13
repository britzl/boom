local function tile(id, tag)
	tag = tag or "tile"
	return function()
		return {
			sprite(id, { atlas = "platformer" }),
			area(),
			body({ is_static = true }),
			tag,
			{ name = tag },
		}
	end
end

local function create_coin(x, y)
	local c = add({
		sprite("coin", { atlas = "platformer" }),
		pos(x, y),
	})
	local duration = 0.2
	local y = c.pos.y
	tween(y, y + 10, duration, go.EASING_OUTQUAD, function(value)
		c.pos.y = value
		c.dirty = true
	end).on_end(function()
		tween(c.pos.y, c.pos.y - 10, duration, go.EASING_OUTQUAD, function(value)
			c.pos.y = value
			c.dirty = true
		end).on_end(function()
			c.destroy()
		end)
	end)
end

local function littleblue()
	return {
		sprite("littleblue", { atlas = "platformer" }),
		area({ shape = "circle" }),
		anchor("bottom"),
		body(),
		"littleblue",
		"enemy",
		{ name = "littleblue" },
	}
end

local function bump_up_down(object)
	if object.bumping then return end
	object.bumping = true
	local duration = 0.1
	local y = object.pos.y
	tween(y, y + 5, duration, go.EASING_OUTQUAD, function(value)
		object.pos.y = value
		object.dirty = true
	end).on_end(function()
		tween(object.pos.y, object.pos.y - 5, duration, go.EASING_OUTQUAD, function(value)
			object.pos.y = value
			object.dirty = true
		end).on_end(function()
			object.bumping = false
		end)
	end)
end

return function()
	cam_zoom(2)
	set_background(0, 0.5, 1, 1)
	set_gravity(300)

	local map = {
		"                      !                                                                            [======]   [=]!               !           [=]    [!!]                                                          XX",
		"                                                                                                                                                                                                                 XXX",
		"                                                                                                                                                                                                                XXXX",
		"                                                                                  !                                                                                                                            XXXXX",
		"                !   [?=!]                           AB                     AB                   [!]              O     []     !  !  !     O          []       X  X          XX  X            [=!]             XXXXXX",
		"                                         AB         CD                     CD                                                                                XX  XX        XXX  XX                           XXXXXXX",
		"                             AB          CD         CD                     CD                                                                               XXX  XXX      XXXX  XXX     12               12 XXXXXXXX",
		"                       b     CD          CD         CD                     CD                                                                              XXXX  XXXX    XXXXX  XXXX    34               34XXXXXXXXX",
		"########################################################################################  ################   #################################################################  ####################################",
		"----------------------------------------------------------------------------------------  ----------------   -----------------------------------------------------------------  ------------------------------------",
		"123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890",
	}

	local options = {
		tile_width = 18,
		tile_height = 18,
		tiles = {
			["O"] = tile("tile_0000", "bump"),
			["["] = tile("tile_0001", "bump"),
			["="] = tile("tile_0002", "bump"),
			["]"] = tile("tile_0003", "bump"),

			[","] = tile("tile_0021"),
			["#"] = tile("tile_0022"),
			["."] = tile("tile_0023"),

			["X"] = tile("tile_0047"),

			["-"] = tile("tile_0122"),
			["!"] = tile("tile_0010", "coinbump"),
			["?"] = tile("tile_0010", "mushroombump"),

			["A"] = tile("tile_0095_1"),
			["B"] = tile("tile_0095_2"),
			["C"] = tile("tile_0115_1"),
			["D"] = tile("tile_0115_2"),

			["b"] = littleblue,
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
		if data.target.pos.y > player.pos.y and player.is_jumping then
			bump_up_down(data.target)
		end
	end)
	player.on_collide("coinbump", function(data)
		if data.target.pos.y > player.pos.y and player.is_jumping then
			local target = data.target
			bump_up_down(target)
			target.unuse("coinbump")
			target.play("tile_0009")
			create_coin(target.pos.x, target.pos.y + 20)
		end
	end)
	player.on_collide("mushroombump", function(data)
		if data.target.pos.y > player.pos.y and player.is_jumping then
			bump_up_down(data.target)
			data.target.unuse("mushroombump")
			data.target.play("tile_0009")
		end
	end)
	player.on_collide("enemy", function(data)
		print("PLATFORMER enemy collision", player.is_falling)
		os.exit()
		if player.pos.y > data.target.pos.y and player.is_falling then
			local enemy = data.target
			enemy.unuse("enemy")
			enemy.unuse("body")
			enemy.unuse("area")
			enemy.flip_y = true
		end
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
		local lb = get("littleblue")
		for i=1,#lb do
			local littleblue = lb[i]
			littleblue.move(-20, littleblue.vel.y)
		end

		if not is_key_down("key_left") and not is_key_down("key_right") then
			player.move(0, player.vel.y)
			player.play("player_idle")
		end

		print("PLATFORMER update")

		if player.pos.x < 0 then player.pos.x = 0 end

		cam_pos(player.pos.x, 169)
	end)

	--inspect()

end