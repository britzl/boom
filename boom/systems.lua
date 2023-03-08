local M = {}

local update = {}
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
		if module.__on_message then
			on_message[#on_message + 1] = module.__on_message
			module.__on_message = nil
		end
		if module.__on_input then
			on_input[#on_input + 1] = module.__on_input
			module.__on_input = nil
		end
		for name,fn in pairs(module) do
			_G[name] = fn
		end
	end
end

function M.init(game_url)
	for _,fn in ipairs(init) do
		fn(game_url)
	end
end

function M.destroy()
	for _,fn in ipairs(destroy) do
		fn()
	end
end

function M.update(dt)
	for _,fn in ipairs(update) do
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