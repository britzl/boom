local systems = require("boom.systems")

local M = {}

local input_pool = {}
local input_queue = {}


function M.queue(action_id, action)
	local input = input_pool[#input_pool]
	if input then
		input_pool[#input_pool] = nil
	else
		input = {}
	end
	input.action_id = action_id
	input.action = action
	input_queue[#input_queue + 1] = input
end

function M.process()
	local count = #input_queue
	for i=1,count do
		local input = input_queue[i]
		input_queue[i] = nil
		input_pool[#input_pool + 1] = input
		systems.on_input(input.action_id, input.action)
	end
end


return M