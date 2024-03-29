--- Component to move a game object in a direction of travel and at a specific speed.
--
-- @usage
-- -- move towards a direction infinitely
-- local projectile = add({
--     sprite("bullet"),
--     pos(player.pos),
--     move(vec2(0, 1), 1200),
-- })

local WIDTH = sys.get_config_int("display.width")
local HEIGHT = sys.get_config_int("display.width")

local callable = require "boom.internal.callable"

local M = {}

--- Create a move component.
-- @vec2 direction Direction of movement.
-- @number speed Speed of movement in pixels per second.
-- @treturn MoveComp component The created component.
function M.move(direction, speed)
	local c = {}
	c.tag = "move"
	c.direction = direction
	c.speed = speed

	c.init = function()
		local object = c.object
		assert(object.comps.pos, "Component 'move' requires component 'pos'")
		object.move(object.direction.x * object.speed, object.direction.y * object.speed)
	end

	c.update = function(dt)
		local object = c.object
		if object.speed == 0 or (object.direction.x == 0 and object.direction.y == 0) then
			return
		end
		object.move(object.direction.x * object.speed, object.direction.y * object.speed)
	end

	return c
end


return callable.make(M, M.move)