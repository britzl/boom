local M = {}


local dt = 0
local time = 0

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

function M.__init()
	time = socket.gettime()
end

function M.__update(_dt)
	dt = _dt
end


return M