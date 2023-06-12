local M = {}

local timer = _G.timer

local timers = {}

local function cancel(handle)
	if timers[handle] then
		timer.cancel(handle)
		timers[handle] = nil
	end
end

--- Run a callback after a certain nummber of seconds.
-- @number seconds Number of seconds to wait
-- @function cb Function to call
-- @treturn function cancel Call to cancel the timer
function M.wait(seconds, cb)
	local handle = timer.delay(seconds, false, function(self, handle, dt)
		timers[handle] = nil
		cb()
	end)
	timers[handle] = true
	return function() cancel(handle) end
end

--- Run a callback repeatedly with a certain interval
-- @number seconds Interval between calls
-- @function cb Function to call
-- @treturn function cancel Call to cancel the timer
function M.loop(seconds, cb)
	local handle = timer.delay(seconds, true, function(self, handle, dt)
		cb()
	end)
	timers[handle] = true
	return function() cancel(handle) end
end

function M.__destroy()
	for handle,_ in pairs(timers) do
		cancel(handle)
	end
end

return M