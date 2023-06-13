local M = {}

local function is_observable(object)
	if not type(object) == "table" then return false end
	local mt = getmetatable(object)
	return mt and mt.__observers
end

local function notify_observers(observers, k, v)
	for _,cb in pairs(observers) do
		cb(k, v)
	end
end

local function stop_observing(observable, observer)
	local mt = getmetatable(observable)
	assert(mt and mt.__observers, "The object is not observable")
	mt.__observers[observer] = nil
end

local function start_observing(observable, observer, onchange)
	local mt = getmetatable(observable)
	assert(mt and mt.__observers, "The object is not observable")
	mt.__observers[observer] = onchange
end


function M.create(object, properties)
	if not properties then
		properties = {}
		for k,v in pairs(object) do
			properties[k] = v
			object[k] = nil
		end
	end

	local observers = {}

	for k,v in pairs(properties) do
		if is_observable(v) then
			start_observing(v, object, function(...)
				notify_observers(observers, ...)
			end)
		end
	end

	local mt = getmetatable(object) or {}
	-- get value
	mt.__index = function(o, k)
		local v = rawget(o, k)
		if v then return v end
		return properties[k]
	end
	-- set value
	mt.__newindex = function(o, k, v)
		local current = properties[k]
		if current ~= v then
			if is_observable(current) then
				stop_observing(current, o)
			end
			properties[k] = v
			if is_observable(v) then
				start_observing(v, o, function(...)
					notify_observers(observers, ...)
				end)
			end
			notify_observers(observers, k, v)
		end
	end
	mt.__observers = observers
	return setmetatable(object, mt)
end



function M.observe(observable, observer, onchange)
	start_observing(observable, observer, onchange)
end



return M