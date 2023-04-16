local boom = require("boom.boom")

return function()
	describe("boom", function()

		before(function()
		end)

		after(function()
			boom.final()
		end)

		test("no game start without init", function()
			local started = false
			boom.boom(function()
				started = true
			end)
			assert(not started)
		end)

		test("init and then game start", function()
			boom.init(msg.url("test:/boom/boom#boom"), true)
			local started = false
			boom.boom(function()
				started = true
			end)
			assert(started)
		end)

		test("game start then init should start game", function()
			local started = false
			boom.boom(function()
				started = true
			end)
			assert(not started)
			boom.init(msg.url("test:/boom/boom#boom"), true)
			assert(started)
		end)
	end)
end