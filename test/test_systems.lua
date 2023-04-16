local systems = require("boom.systems")

local function create_system(name)
	local s = {}
	s.name = name
	s.init_count = 0
	s.update_count = 0
	s.on_message_count = 0
	s.on_input_count = 0
	s.destroy_count = 0
	s.__init = function(...)
		s.init_count = init_count + 1
		s.init_args = { ... }	
	end
	s.__update = function(...)
		s.update_count = s.update_count + 1
		s.update_args = { ... }
	end
	s.__on_message = function(...)
		s.on_message_count = s.on_message_count + 1
		s.on_message_args = { ... }
	end
	s.__on_input = function(...)
		s.on_input_count = s.on_input_count + 1
		s.on_input_args = { ... }
	end
	s.__destroy = function(...)
		s.destroy_count = s.destroy_count + 1
		s.destroy_args = { ... }
	end
	return s
end


return function()
	describe("systems", function()

		before(function()
		end)

		after(function()
			systems.destroy()
		end)

		test("adding systems", function()
			local s1 = create_system("system1")
			s1.foo = function() end
			s1.bar = function() end
			systems.add({ s1 })
			-- lifecycle functions should be removed
			assert(s1.__init == nil)
			assert(s1.__update == nil)
			assert(s1.__on_message == nil)
			assert(s1.__on_input == nil)
			assert(s1.__destroy == nil)
			-- other values should be kept
			assert(s1.foo)
			assert(s1.bar)
		end)

		test("calling lifecycle functions", function()
			local s1 = create_system("system1")
			local s2 = create_system("system2")
			systems.add({ s1, s2 })

			systems.init()
			assert(s1.init_count == 1)
			assert(s2.init_count == 1)

			systems.update(0.16)
			systems.update(0.16)
			assert(s1.update_count == 2)
			assert(s2.update_count == 2)
			assert(s1.update_args[1] == 0.16)
			assert(s2.update_args[1] == 0.16)

			local message_id = hash("foobar")
			local message = { a = "b", c = 123}
			local sender = msg.url()
			systems.on_message(message_id, message, sender)
			assert(s1.on_message_count == 1)
			assert(s2.on_message_count == 1)
			assert(s1.on_message_args[1] == message_id)
			assert(s1.on_message_args[2].a == message.a)
			assert(s1.on_message_args[2].c == message.c)
			assert(s1.on_message_args[3].socket == sender.socket)
			assert(s1.on_message_args[3].path == sender.path)
			assert(s1.on_message_args[3].fragment == sender.fragment)

			local action_id = hash("attack")
			local action = { pressed = true, x = 123}
			systems.on_input(action_id, action)
			assert(s1.on_input_count == 1)
			assert(s2.on_input_count == 1)
			assert(s1.on_input_args[1] == action_id)
			assert(s1.on_input_args[2].pressed == action.pressed)
			assert(s1.on_input_args[2].x == action.x)

			systems.destroy()
			assert(s1.destroy_count == 1)
			assert(s2.destroy_count == 1)
		end)
	end)
end