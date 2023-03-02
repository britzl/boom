local M = {}


function M.register(listeners, event, cb)
	assert(event)
	assert(cb)
	listeners[event] = listeners[event] or {}

	local cancel = nil
	cancel = function()
		listeners[event][cancel] = nil
	end

	listeners[event][cancel] = cb
	return cancel
end

function M.trigger(listeners, event, data)
	if not listeners[event] then return end
	for cancel,cb in pairs(listeners[event]) do
		if data then
			cb(data, cancel)
		else
			cb(cancel)
		end
	end
end


return M