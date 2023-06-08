local vec2 = require "boom.math.vec2"
local screen = require "boom.info.screen"

local M = {}


local CAMERA_ID = "/boom/camera#camera"

local FOLLOW_ID = nil

local function tovec2(x, y)
	if not x then return nil end
	if x and y then return vec2(x, y) end
	return x
end

---
-- Get or set camera position.
-- @param x or vec2
-- @param y
-- @return position Camera position
function M.cam_pos(...)
	local pos = tovec2(...)
	if not pos then
		return go.get_position(CAMERA_ID)
	end
	go.set_position(pos.tov3(), CAMERA_ID)
end

--- Get or set camera rotation.
-- @param angle The angle to set or nil to get current rotation
-- @return rotation The camera rotation in degrees
function M.cam_rot(angle)
	if not angle then
		return go.get(CAMERA_ID, "euler.z")
	end
	go.set_rotation(vmath.quat_rotation_y(math.rad(angle)))
end

--- Get or set the camera zoom.
-- @param zoom The zoom to set or nil to get the current zoom.
-- @return The camera zoom
function M.cam_zoom(zoom)
	if not zoom then
		return go.get(CAMERA_ID, "zoom")
	end
	go.set(CAMERA_ID, "orthographic_zoom", zoom)
end


function M.__init()
	msg.post(CAMERA_ID, "acquire_camera_focus")
	--msg.post("@render:", "use_camera_projection")
	--local pos = vec2(screen.width() / 2, screen.height() / 2)
	local pos = vmath.vector3(screen.width() / 2, screen.height() / 2, 0)
	go.set_position(pos, CAMERA_ID)
end

function M.__update(dt)
end

return M