--- Run an action once or repeatedly at a set interval

local M = {}

local timer = _G.timer

--- Run certain action after some time.
-- @number n Number of seconds to wait
-- @function fn The function to call
-- @treturn component Timer The created component
function M.timer(n, fn)
	local c = {}
	c.tag = "timer"

	local handle = nil

	local function cancel_timer()
		if handle then
			timer.cancel(handle)
			handle = nil
		end
	end

	local function start_timer(n, fn, loop)
		if loop == nil then loop = false end
		cancel_timer()
		handle = timer.delay(n, loop, function()
			handle = nil
			fn()
		end)
	end

	c.init = function()
		start_timer(n, fn, false)
	end

	--- Run a callback function after n seconds
	-- @type Timer
	-- @number n Seconds
	-- @function fn The function to call
	c.wait = function(n, fn)
		start_timer(n, fn, false)
	end

	--- Run a callback function every n seconds
	-- @type Timer
	-- @number n Seconds
	-- @function fn The function to call
	c.loop = function(n, fn)
		start_timer(n, fn, true)
	end

	--- Cancel the timer
	-- @type Timer
	c.cancel = function(n, fn)
		cancel_timer()
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