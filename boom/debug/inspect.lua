local gameobject = require "boom.gameobject.gameobject"

local M = {}

local GREEN = vmath.vector4(0,1,0,1)

local inspecting = false

function M.inspect()
	inspecting = not inspecting
	msg.post("@system:", "toggle_physics_debug")
end

local P1 = vmath.vector3()
local P2 = vmath.vector3()

function M.__update()
	if inspecting then
		local objects = gameobject.get("area")
		for i=1,#objects do
			local object = objects[i]
			local world_area = object.world_area
			if world_area.radius then
				local center = world_area.center
				local r = world_area.radius
				local segments = 8
				local arc = 2 * math.pi / segments
				for i=1,segments do
					local a1 = (i - 1) * arc
					P1.x = center.x + r * math.cos(a1)
					P1.y = center.y + r * math.sin(a1)

					local a2 = i * arc
					P2.x = center.x + r * math.cos(a2)
					P2.y = center.y + r * math.sin(a2)
					msg.post("@render:", "draw_line", { start_point = P1, end_point = P2, color = GREEN })
				end
			else
				msg.post("@render:", "draw_line", { start_point = world_area.topleft.tov3(),     end_point = world_area.topright.tov3(), color = GREEN })
				msg.post("@render:", "draw_line", { start_point = world_area.topright.tov3(),    end_point = world_area.bottomright.tov3(), color = GREEN })
				msg.post("@render:", "draw_line", { start_point = world_area.bottomright.tov3(), end_point = world_area.bottomleft.tov3(), color = GREEN })
				msg.post("@render:", "draw_line", { start_point = world_area.bottomleft.tov3(),  end_point = world_area.topleft.tov3(), color = GREEN })
			end
		end

	end
end

return M