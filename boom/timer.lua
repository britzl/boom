local M = {}

function M.wait(seconds, fn)
	timer.delay(seconds, false, function(self, handle, dt)
		fn(function() timer.cancel(handle) end)
	end)
end

function M.loop(seconds, fn)
	timer.delay(seconds, true, function(self, handle, dt)
		fn(function() timer.cancel(handle) end)
	end)
end

return M