local M = {}


local dt = 0
local prev_dt = 0
local time = 0
local fps = 60
---
-- Get the delta time
-- @return dt Delta time
function M.dt()
	return dt
end

---
-- Get time since start
-- @return time Time since start in seconds
function M.time()
	return socket.gettime() - timew
end

function M.fps()
	return fps
end

function M.__init()
	time = socket.gettime()
end

function M.__update(_dt)
	prev_dt = dt
	dt = _dt

	local smoothing = math.pow(0.9, dt * 60 / 1000);
	fps = (fps * smoothing) + (1 / dt * (1.0 - smoothing))
end


return M