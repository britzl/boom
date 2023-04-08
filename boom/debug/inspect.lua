local gameobject = require "boom.gameobject.gameobject"

local M = {}

local GREEN = vmath.vector4(0,1,0,1)

local inspecting = false

function M.inspect()
	inspecting = not inspecting
	msg.post("@system:", "toggle_physics_debug")
end

function M.__update()
	if inspecting then
		local objects = gameobject.get("area")
		for i=1,#objects do
			local object = objects[i]
			local world_shape = object.world_shape
			if world_shape.radius then
			else
				msg.post("@render:", "draw_line", { start_point = world_shape.topleft,     end_point = world_shape.topright, color = GREEN })
				msg.post("@render:", "draw_line", { start_point = world_shape.topright,    end_point = world_shape.bottomright, color = GREEN })
				msg.post("@render:", "draw_line", { start_point = world_shape.bottomright, end_point = world_shape.bottomleft, color = GREEN })
				msg.post("@render:", "draw_line", { start_point = world_shape.bottomleft,  end_point = world_shape.topleft, color = GREEN })
			end
		end

	end
end

return M