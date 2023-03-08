local gameobject = require "boom.gameobject.gameobject"

local WIDTH = sys.get_config_int("display.width")
local HEIGHT = sys.get_config_int("display.width")

local M = {}

---
-- Move towards a direction infinitely, and destroys when it leaves game view
-- @param direction Vec 2
-- @param speed Speed of movement in pixels per second
-- @return The component
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
		local pos = object.pos
		if pos.x < 0 then
			gameobject.destroy(object)
		elseif pos.x > WIDTH then
			gameobject.destroy(object)
		elseif pos.y < 0 then
			gameobject.destroy(object)
		elseif pos.y > HEIGHT then
			gameobject.destroy(object)
		end
	end

	return c
end


return M