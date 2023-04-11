local M = {}

local TWEEN_FACTORY = nil

local tweens = {}

function M.__init()
	TWEEN_FACTORY = msg.url("#tweenfactory")
end

function M.__update()
	for _,tween in pairs(tweens) do
		local value = go.get(tween.url, tween.property)
		tween.set_value(value)
	end
end

---
-- Tween a value from one to another over a certain duration using a specific
-- easing function
-- @param from Start value (number or vec2)
-- @param to End value (same as from)
-- @param duration Time in seconds to go from start to end value
-- @param easing Which easing algorithm to use
-- @param set_value Function to call when the value has changed
-- @return tween A tween object
function M.tween(from, to, duration, easing, set_value)
	assert(from)
	assert(to)
	assert(duration and duration >= 0)
	assert(set_value)
	local delay = 0
	local id = factory.create(TWEEN_FACTORY)
	local url = msg.url(nil, id, "tween")
	local property = type(from) == "number" and "value.x" or "value"
	easing = easing or go.EASING_LINEAR

	local tween = {
		id = id,
		url = url,
		from = from,
		to = to,
		duration = duration,
		set_value = set_value,
		easing = easing,
		property = property,
	}
	tweens[id] = tween


	local tween_controller = {}
	---
	-- Register an event when finished
	-- @param fn The function to call when the tween has finished
	tween_controller.on_end = function(fn)
		if tweens[id] then
			tween.finish_cb = fn
		end
	end

	---
	-- Finish tween now
	tween_controller.finish = function()
		if tweens[id] then
			set_value(to)
			go.cancel_animations(url)
			go.delete(id)
			tweens[id] = nil
			if tween.finish_cb then
				tween.finish_cb()
			end
		end
	end

	---
	-- Cancel tween
	tween_controller.cancel = function()
		if tweens[id] then
			go.cancel_animations(url)
			go.delete(id)
			tweens[id] = nil
		end
	end

	go.set(url, property, from)
	go.animate(url, property, go.PLAYBACK_ONCE_FORWARD, to, easing, duration, delay, tween_controller.finish)

	return tween_controller
end

return M