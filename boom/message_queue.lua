local systems = require("boom.systems")

local M = {}

local message_pool = {}
local message_queue = {}

function M.queue(message_id, message, sender)
	local m = message_pool[#message_pool]
	if m then
		message_pool[#message_pool] = nil
	else
		m = {}
	end
	m.message_id = message_id
	m.message = message
	m.sender = sender
	message_queue[#message_queue + 1] = m
end

function M.process()
	local count = #message_queue
	for i=1,count do
		local m = message_queue[i]
		message_queue[i] = nil
		message_pool[#message_pool + 1] = m
		systems.on_message(m.message_id, m.message, m.sender)
	end
end


return M