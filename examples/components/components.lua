
local function anchor_example(x, y)
	add({
		sprite("player_idle", { atlas = "platformer" }),
		pos(x, y + 50),
		anchor("left")
	})
	add({
		sprite("player_idle", { atlas = "platformer" }),
		pos(x, y + 50),
		anchor("right")
	})
	add({
		sprite("player_idle", { atlas = "platformer" }),
		pos(x, y + 50),
		anchor("top")
	})
	add({
		sprite("player_idle", { atlas = "platformer" }),
		pos(x, y + 50),
		anchor("bottom")
	})
end


local function body_example(x, y)
	local p = add({
		sprite("player_idle", { atlas = "platformer" }),
		pos(x, y + 50),
		area({ shape = "auto" }),
		body({ jump_force = 400 })
	})
	add({
		pos(x, y + 10),
		area({ shape = "rect", width = 100, height = 20 }),
		body({ is_static = true })
	})
	on_mouse_press(function()
		if p.is_grounded then
			p.jump()
		end
	end)
end

local function double_jump_example(x, y)
	local p = add({
		sprite("player_idle", { atlas = "platformer" }),
		pos(x, y + 50),
		area({ shape = "auto" }),
		body({ jump_force = 400 }),
		double_jump()
	})
	add({
		pos(x, y + 10),
		area({ shape = "rect", width = 100, height = 20 }),
		body({ is_static = true })
	})
	on_mouse_press(function()
		p.double_jump()
	end)
end

local function area_example(x, y)
	local r = add({
		sprite("element_blue_rectangle", { atlas = "breakout" }),
		pos(x, y + 50),
		area({ shape = "auto" }),
	})
	local c = add({
		sprite("ballGrey", { atlas = "breakout" }),
		pos(x, y + 85),
		area({ shape = "auto-circle" }),
	})
	on_click(c.id, function()
		print("click circle")
	end)
	on_click(r.id, function()
		print("click rect")
	end)
end

local function color_example(x, y)
	local rect = add({
		sprite("element_grey_rectangle", { atlas = "breakout" }),
		area({ shape = "auto" }),
		pos(x, y + 50),
		color(1, 1, 1, 1),
	})
	on_mouse_press(function()
		rect.color.r = rand(0, 1)
		rect.color.g = rand(0, 1)
		rect.color.b = rand(0, 1)
	end)
end

local function fadein_example(x, y)
	add({
		sprite("element_blue_rectangle", { atlas = "breakout" }),
		fadein(3),
		pos(x, y + 20),
	})
end

local function health_example(x, y)
	local p = add({
		sprite("player_idle", { atlas = "platformer" }),
		health(10),
		pos(x, y + 40),
	})
	local txt = add({ text("HP: " .. p.hp, { align = "center" }), pos(x, y + 20) })
	on_mouse_press(function()
		p.hurt(1)
	end)
	on_mouse_press("right", function()
		p.heal(1)
	end)
	p.on_hurt(function()
		txt.text = "HP: " .. p.hp
	end)
	p.on_heal(function()
		txt.text = "HP: " .. p.hp
	end)
	p.on_death(function()
		txt.text = "DEAD!"
	end)
end


local function mouse_pos_example(x, y)
	local mouse_pos_txt = add({ text("MOUSE", { align = "center" }), pos(x, y + 20) })
	local world_pos_txt = add({ text("WORLD", { align = "center" }), pos(x, y + 30) })
	on_mouse_move(function()
		local mp = mouse_pos()
		local wp = to_world(mp)
		mouse_pos_txt.text = string.format("MOUSE: %.2f,%.2f", mp.x, mp.y)
		world_pos_txt.text = string.format("WORLD: %.2f,%.2f", wp.x, wp.y)
	end)
end

return function()
	local examples = {
		{ name = "anchor", fn = anchor_example, desc = "left, right, top, bottom" },
		{ name = "area", fn = area_example, desc = "click on shapes" },
		{ name = "body", fn = body_example, desc = "click to jump" },
		{ name = "color", fn = color_example, desc = "click to color" },
		{ name = "double_jump", fn = double_jump_example, desc = "click to double jump" },
		{ name = "fadein", fn = fadein_example, desc = "" },
		{ name = "health", fn = health_example, desc = "lmb = damage, rmb = heal" },
		{ name = "mouse_pos", fn = mouse_pos_example, desc = "mouse" },
	}

	for i,ex in ipairs(examples) do
		local x = 50 + ((i - 1) % 5) * 120
		local y = 50 + math.floor((i - 1) / 5) * 120
		add({ text(ex.name, { align = "center" }), pos(x, y - 10) })
		add({ text(ex.desc, { align = "center" }), pos(x, y) })
		ex.fn(x, y)
	end
end