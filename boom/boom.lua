local gameobject = require "boom.gameobject.gameobject"
local components = require "boom.components.components"
local events = require "boom.events.events"
local math = require "boom.math.math"
local timer = require "boom.timer.timer"
local info = require "boom.info.info"
local scene = require "boom.scene.scene"
local debug = require "boom.debug.debug"

local systems = require "boom.systems"

systems.add(events)
systems.add(math)
systems.add(components)
systems.add({ gameobject })
systems.add(info)
systems.add(debug)
systems.add({ scene })
systems.add({ timer })

local M = {}

local initialized = false
local game_fn = nil

local config = {
	game_url = nil,
	boom_url = nil,
	label_screen_material = nil,
	sprite_screen_material = nil,
}

local function start_game()
	if initialized then
		--setfenv(game, ENV)
		game_fn()
	end
end

---
-- Start a boom game
-- Call this from your own game script
-- @param game Game loop function
function M.boom(game)
	game_fn = game
	config.game_url = msg.url()
	start_game()
end

-- initialize boom
-- called from boom.script
function M.init()
	config.boom_url = msg.url()
	config.label_screen_material = go.get(config.boom_url, "label_screen_material")
	config.sprite_screen_material = go.get(config.boom_url, "sprite_screen_material")
	systems.init(config)
	initialized = true
	start_game()
end

function M.update(dt)
	systems.update(dt)
end

function M.on_message(message_id, message, sender)
	systems.on_message(message_id, message, sender)
end

function M.on_input(action_id, action)
	systems.on_input(action_id, action)
end

return setmetatable(M, {
	__call = function(t, game)
		M.boom(game)
	end
})