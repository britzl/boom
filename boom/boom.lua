--- Boom is a game framework built on top of Defold.
-- It is heavily inspired by the Kaboom.js game framework.

local gameobject = require "boom.gameobject.gameobject"
local components = require "boom.components.components"
local events = require "boom.events.events"
local math = require "boom.math.math"
local timer = require "boom.timer.timer"
local info = require "boom.info.info"
local scene = require "boom.scene.scene"
local level = require "boom.level.level"
local debug = require "boom.debug.debug"

local collisions = require "boom.internal.collisions"
local systems = require "boom.internal.systems"


local M = {}


local initialized = false
local started = false
local game_fn = nil
local config = {}

local function start_game()
	if initialized and game_fn and not started then
		--setfenv(game, ENV)
		started = true
		game_fn()
	end
end

---
-- Start a boom game.
-- Call this from your own game script
-- @tparam function game Game loop function
function M.boom(game)
	game_fn = game
	config.game_url = msg.url()
	start_game()
end

-- initialize boom
-- called from boom.script
-- @tparam url URL of the boom.script (only used for unit tests)
function M.init(url, skip_systems)
	if initialized then
		print("Boom is already initialized")
		return
	end
	initialized = true

	config.boom_url = url or msg.url()
	config.label_screen_material = go.get(config.boom_url, "label_screen_material")
	config.sprite_screen_material = go.get(config.boom_url, "sprite_screen_material")

	if not skip_systems then
		systems.add(events)
		systems.add(math)
		systems.add(components)
		systems.add({ gameobject })
		systems.add(info)
		systems.add(debug)
		systems.add({ level })
		systems.add({ scene })
		systems.add({ timer })
		systems.add({ collisions })
	end

	systems.init(config)
	start_game()
end

-- finalize boom
-- called from boom.script
function M.final()
	systems.destroy()
	initialized = false
	game_fn = nil
	config = {}
end

-- update boom
-- called from boom.script
function M.update(dt)
	--message_queue.process()
	--input_queue.process()
	systems.update(dt)
end

-- handle messages
-- called from boom.script
function M.on_message(message_id, message, sender)
	--message_queue.queue(message_id, message, sender)
	systems.on_message(message_id, message, sender)
end

-- handle input
-- called from boom.script
function M.on_input(action_id, action)
	--input_queue.queue(action_id, action)
	systems.on_input(action_id, action)
end

return setmetatable(M, {
	__call = function(t, game)
		M.boom(game)
	end
})