local M = {}

local timer = _G.timer

---
-- Run certain action after some time.
-- @param n Number of seconds to wait
-- @param fn The function to call
-- @return The component
function M.timer(n, fn)
	local c = {}
	c.tag = "timer"

	local handle = nil

	local function start_timer(n, fn)
		if handle then
			timer.cancel(handle)
		end
		handle = timer.delay(n, false, function()
			handle = nil
			fn()
		end)
	end

	c.init = function()
		start_timer(n, fn)
	end

	c.wait = function(n, fn)
		start_timer(n, fn)
	end

	c.destroy = function()
		if handle then
			timer.cancel(handle)
			handle = nil
		end
	end

	return c
end


return M