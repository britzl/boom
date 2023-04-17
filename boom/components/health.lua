local listener = require "boom.events.listener"

local M = {}

---
-- Handles health related logic
-- @param hp Initial health
-- @return The component
function M.health(hp)
	local c = {}
	c.tag = "health"
	c.hp = hp

	local on_heal_listeners = {}
	local on_hurt_listeners = {}
	local on_death_listeners = {}

	---
	-- Register an event that runs when heal() is called
	-- @param cb Function to call
	c.on_heal = function(cb)
		return listener.register(on_heal_listeners, "heal", cb)
	end

	---
	-- Register an event that runs when hurt() is called
	-- @param cb Function to call
	c.on_hurt = function(cb)
		return listener.register(on_hurt_listeners, "hurt", cb)
	end

	---
	-- Register an event that runs when health is 0 or less
	-- @param cb Function to call
	c.on_death = function(cb)
		return listener.register(on_death_listeners, "death", cb)
	end

	---
	-- Increase hp. Will trigger on_heal.
	-- @param n Amount to increase
	c.heal = function(n)
		c.object.hp = c.object.hp + n
		listener.trigger(on_heal_listeners, "heal")
	end

	---
	-- Decrease hp. Will trigger on_hurt
	-- @param n Amount to decrease
	c.hurt = function(n)
		c.object.hp = c.object.hp - n
		if c.object.hp <= 0 then
			listener.trigger(on_death_listeners, "death")
		else
			listener.trigger(on_hurt_listeners, "hurt")
		end
	end

	c.destroy = function()
		on_heal_listeners = {}
		on_hurt_listeners = {}
		on_death_listeners = {}
	end

	return c
end

return M