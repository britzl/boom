--- Handles health related logic.
-- @usage
-- local enemy = add({
--     sprite("monster"),
--     area("auto"),
--     pos(100, 100),
--     health(3)
-- })
--
-- enemy.on_collide("bullet", function(collision)
--    enemy.hurt(1)
-- end)
--
-- enemy.on_death(function()
--     destroy(enemy)
-- end)

local callable = require "boom.internal.callable"
local listener = require "boom.events.listener"

local M = {}

--- Create a health component
-- @number hp Initial health (default is 1)
-- @treturn HealthComp component The health component
function M.health(hp)
	local c = {}
	c.tag = "health"

	--- Current hp.
	-- @type HealthComp
	-- @field number
	c.hp = hp or 1

	local on_heal_listeners = {}
	local on_hurt_listeners = {}
	local on_death_listeners = {}

	--- Register an event that runs when heal() is called.
	-- @type HealthComp
	-- @function cb Function to call
	c.on_heal = function(cb)
		return listener.register(on_heal_listeners, "heal", cb)
	end

	--- Register an event that runs when hurt() is called.
	-- @type HealthComp
	-- @function cb Function to call
	c.on_hurt = function(cb)
		return listener.register(on_hurt_listeners, "hurt", cb)
	end

	--- Register an event that runs when health is 0 or less.
	-- @type HealthComp
	-- @function cb Function to call
	c.on_death = function(cb)
		return listener.register(on_death_listeners, "death", cb)
	end

	--- Increase hp.
	-- Will trigger on_heal.
	-- @type HealthComp
	-- @number n Amount to increase
	c.heal = function(n)
		c.object.hp = c.object.hp + n
		listener.trigger(on_heal_listeners, "heal")
	end

	--- Decrease hp.
	-- Will trigger on_hurt
	-- @type HealthComp
	-- @number n Amount to decrease
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

return callable.make(M, M.health)