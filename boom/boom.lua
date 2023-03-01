local gameobject = require "boom.gameobject"
local components = require "boom.components"
local events = require "boom.events"
local math = require "boom.math"
local timer = require "boom.timer"
local info = require "boom.info"

local M = {}

local initialized = false
local game = nil


-- set global functions
-- ignore certain lifecycle functions used by boom internally
local function set_globals()
	local IGNORE = { init = true, final = true, update = true, on_input == true, on_message = true}
	for _,system in pairs({ gameobject, components, events, math, timer, info }) do
		for name,fn in pairs(system) do
			if not IGNORE[name] and name.sub(1,1) ~= "_" then
				_G[name] = fn
			end
		end
	end
end

local function start_game()
	if initialized then
		--setfenv(game, ENV)
		game()
	end
end

function M.init()
	gameobject.init()
	components.init()
	set_globals()
	initialized = true
	start_game()
end

function M.boom(_game)
	game = _game
	start_game()
end

function M.update(dt)
	gameobject.update(dt)
	events.update(dt)
end

function M.on_message(message_id, message, sender)
	events.on_message(message_id, message, sender)
end

function M.on_input(action_id, action)
	events.on_input(action_id, action)
end

return setmetatable(M, {
	__call = function(t, game)
		M.boom(game)
	end
})