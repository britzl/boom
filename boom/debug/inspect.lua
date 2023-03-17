local gameobject = require "boom.gameobject.gameobject"

local M = {}

local GREEN = vmath.vector4(0,1,0,1)

local inspecting = false

function M.inspect()
	inspecting = not inspecting
	--msg.post("@system:", "toggle_physics_debug")
end

function M.__update()
	if inspecting then
		local objects = gameobject.get("area")
		for i=1,#objects do
			local object = objects[i]
			local world_rect = object.comps.area.world_rect
			msg.post("@render:", "draw_line", { start_point = world_rect.topleft,     end_point = world_rect.topright, color = GREEN })
			msg.post("@render:", "draw_line", { start_point = world_rect.topright,    end_point = world_rect.bottomright, color = GREEN })
			msg.post("@render:", "draw_line", { start_point = world_rect.bottomright, end_point = world_rect.bottomleft, color = GREEN })
			msg.post("@render:", "draw_line", { start_point = world_rect.bottomleft,  end_point = world_rect.topleft, color = GREEN })
		end

	end
end

return M