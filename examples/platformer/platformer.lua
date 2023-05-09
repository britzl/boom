local function up_down(object, amount_up, amount_down, speed, cb)
	local duration = amount_up / speed
	local y = object.pos.y
	tween(y, y + amount_up, duration, go.EASING_OUTSINE, function(value)
		object.pos.y = value
		object.dirty = true
	end).on_end(function()
		duration = amount_down / speed
		tween(object.pos.y, object.pos.y - amount_down, duration, go.EASING_INSINE, function(value)
			object.pos.y = value
			object.dirty = true
		end).on_end(cb)
	end)
end

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
	up_down(c, 10, 10, 50, function()
		c.destroy()
	end)
end

local function littleblue()
	return {
		sprite("littleblue", { atlas = "platformer" }),
		area({ shape = "auto-circle" }),
		anchor("bottom"),
		body(),
		z(1),
		health(1),
		"littleblue",
		"enemy",
		{ name = "littleblue" },
	}
end


local function bump_up_down(object)
	if object.bumping then return end
	object.bumping = true
	up_down(object, 5, 5, 100, function()
		object.bumping = false
	end)
end

return function()
	cam_zoom(2)
	set_background(0, 0.5, 1, 1)
	set_gravity(600)

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
		area({ shape = "auto-circle" }),
		anchor("bottom"),
		body(),
		pos(40, 60),
		"player",
		{ name = "player" },
	})

	local fpstext = add({
		pos(10,10),
		text(""),
		fixed()
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
		if (player.pos.y - data.target.pos.y) > 5 then
			local enemy = data.target
			enemy.hurt(1)
			enemy.move(0, 0)
			enemy.unuse("enemy")
			enemy.unuse("body")
			enemy.unuse("area")
			enemy.flip_y = true
			up_down(enemy, 15, enemy.pos.y + 50, 100, function()
				enemy.destroy()
			end)
		end
	end)

	on_key_press("key_space", function()
		if player.is_grounded then
			player.jump(320)
		end
	end)

	on_update(function(cancel)
		local lb = get("littleblue")
		for i=1,#lb do
			local littleblue = lb[i]
			if littleblue.hp > 0 then
				littleblue.move(-20, littleblue.vel.y)
			end
		end

		local run = is_key_down("key_lshift") and 2 or 1
		if is_key_down("key_right") then
			player.move(80 * run, player.vel.y)
			player.play("player_walk")
			player.flip_x = true
		elseif is_key_down("key_left") then
			player.move(-80 * run, player.vel.y)
			player.play("player_walk")
			player.flip_x = false
		else
			player.move(0, player.vel.y)
			player.play("player_idle")
		end

		if player.pos.x < 0 then player.pos.x = 0 end

		cam_pos(player.pos.x, 169)

		fpstext.text = fps()
	end)

	--inspect()

end