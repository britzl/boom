local M = {}

local pre_update = {}
local update = {}
local post_update = {}
local init = {}
local destroy = {}
local on_message = {}
local on_input = {}

function M.add(modules)	
	for _,module in ipairs(modules) do
		if module.__init then
			init[#init + 1] = module.__init
			module.__init = nil
		end
		if module.__destroy then
			destroy[#destroy + 1] = module.__destroy
			module.__destroy = nil
		end
		if module.__update then
			update[#update + 1] = module.__update
			module.__update = nil
		end
		if module.__pre_update then
			pre_update[#pre_update + 1] = module.__pre_update
			module.__pre_update = nil
		end
		if module.__post_update then
			post_update[#post_update + 1] = module.__post_update
			module.__post_update = nil
		end
		if module.__on_message then
			on_message[#on_message + 1] = module.__on_message
			module.__on_message = nil
		end
		if module.__on_input then
			on_input[#on_input + 1] = module.__on_input
			module.__on_input = nil
		end
		for key,val in pairs(module) do
			local t = type(val)
			if t == "function" then
				_G[key] = val
			elseif t == "table" then
				_G[key] = val
				for k,v in pairs(val) do
					_G[k] = v
				end
			end
		end
	end
end

local current_config = nil
function M.init(config)
	config = config or current_config
	for _,fn in ipairs(init) do
		fn(config)
	end
	current_config = config
end

function M.destroy()
	for _,fn in ipairs(destroy) do
		fn()
	end
end

function M.update(dt)
	for i=1,#pre_update do
		local fn = pre_update[i]
		fn(dt)
	end
	for i=1,#update do
		local fn = update[i]
		fn(dt)
	end
	for i=1,#post_update do
		local fn = post_update[i]
		fn(dt)
	end
end

function M.on_message(message_id, message, sender)
	for _,fn in ipairs(on_message) do
		fn(message_id, message, sender)
	end
end

function M.on_input(action_id, action)
	for _,fn in ipairs(on_input) do
		fn(action_id, action)
	end
end

return M