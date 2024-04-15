local vec2 = require "boom.math.vec2"
local screen = require "boom.info.screen"

local M = {}

local DISPLAY_WIDTH = sys.get_config_int("display.width")
local DISPLAY_HEIGHT = sys.get_config_int("display.height")

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

local v4_tmp = vmath.vector4()
---
-- Transform a point from world position to screen position.
-- @param p Point
-- @return position Screen position
function M.to_screen(p)
	local projection = go.get(CAMERA_ID, "projection")
	local view = go.get(CAMERA_ID, "view")
	local w = WINDOW_WIDTH
	local h = WINDOW_HEIGHT
	v4_tmp.x, v4_tmp.y, v4_tmp.z, v4_tmp.w = x, y, z, 1
	local v4 = projection * view * v4_tmp
	local x1 = ((v4.x + 1) / 2) * w
	local y1 = ((v4.y + 1) / 2) * h
	--local z1 = ((v4.z + 0) / 2)
	return vec2(x1, y1)
end

---
-- Transform a point from screen position to world position.
-- @param p Point
-- @return position World position
function M.to_world(p)
	local x = p.x
	local y = p.y
	local z = p.z or 1
	local projection = go.get(CAMERA_ID, "projection")
	local view = go.get(CAMERA_ID, "view")
	local w, h = window.get_size()
	-- The window.get_size() function will return the scaled window size,
	-- ie taking into account display scaling (Retina screens on macOS for
	-- instance). We need to adjust for display scaling in our calculation.
	w = w / (w / DISPLAY_WIDTH)
	h = h / (h / DISPLAY_HEIGHT)

	-- https://defold.com/manuals/camera/#converting-mouse-to-world-coordinates
	local inv = vmath.inv(projection * view)
	x = (2 * x / w) - 1
	y = (2 * y / h) - 1
	z = (2 * z) - 1
	local x1 = x * inv.m00 + y * inv.m01 + z * inv.m02 + inv.m03
	local y1 = x * inv.m10 + y * inv.m11 + z * inv.m12 + inv.m13
	--local z1 = x * inv.m20 + y * inv.m21 + z * inv.m22 + inv.m23
	return vec2(x1, y1)
end


function M.__init()
	msg.post(CAMERA_ID, "acquire_camera_focus")
	--local pos = vec2(screen.width() / 2, screen.height() / 2)
	local pos = vmath.vector3(screen.width() / 2, screen.height() / 2, 0)
	go.set_position(pos, CAMERA_ID)
end

return M