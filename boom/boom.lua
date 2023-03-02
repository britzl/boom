local gameobject = require "boom.gameobject.gameobject"
local components = require "boom.components.components"
local events = require "boom.events.events"
local math = require "boom.math.math"
local timer = require "boom.timer.timer"
local info = require "boom.info.info"
local scene = require "boom.scene.scene"

local systems = require "boom.systems"

systems.add(events)
systems.add(math)
systems.add(components)
systems.add({ gameobject })
systems.add({ info })
systems.add({ scene })
systems.add({ timer })

local M = {}

local initialized = false
local game = nil

local function start_game()
	if initialized then
		--setfenv(game, ENV)
		game()
	end
end

function M.init()
	systems.init()
	initialized = true
	start_game()
end

function M.boom(_game)
	game = _game
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