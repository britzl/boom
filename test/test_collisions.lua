local area = require("boom.components.area")
local pos = require("boom.components.pos")
local gameobject = require("boom.gameobject.gameobject")
local collisions = require("boom.internal.collisions")

local function wait(delay)
	local co = coroutine.running()
	timer.delay(delay, false, function()
		coroutine.resume(co)
	end)
	coroutine.yield()
end

return function()

	describe("collisions", function()

		before(function()
			gameobject.__init({}, msg.url("test:/boom/boom#gameobjectfactory"))
			area.__init()
		end)

		after(function()
			gameobject.__destroy()
		end)

		test("collisions are detected between all objects with specific tags", function()
			local TAG1 = "tag1"
			local TAG2 = "tag2"
			local TAG3 = "tag3"
			local TAG4 = "tag4"
			local o1 = gameobject.add({ pos(10, 10), area({ shape = "circle", radius = 5 }), TAG1 })
			local o2 = gameobject.add({ pos(10, 10), area({ shape = "circle", radius = 5 }), TAG2 })
			local o3 = gameobject.add({ pos(10, 10), area({ shape = "circle", radius = 5 }), TAG3 })
			local o4 = gameobject.add({ pos(10, 10), area({ shape = "circle", radius = 5 }), TAG4 })

			local collision_count = 0
			local ok = true
			collisions.on_tag_collision(TAG1, TAG2, function(info, _)
				collision_count = collision_count + 1
				if not ok then return end
				ok = (info.source.id == o1.id) and (info.target.id == o2.id)
			end)
			collisions.on_tag_collision(TAG4, TAG1, function(info, _)
				collision_count = collision_count + 1
				if not ok then return end
				ok = (info.source.id == o4.id) and (info.target.id == o1.id)
			end)
			wait(0) -- end of first component update, collisions happen after this
			wait(0) -- end of second component update, we can now check collisions
			assert(ok)
			assert(collision_count == 2)
		end)

		test("collisions are detected for all objects with a specific tag", function()
			local TAG1 = "tag1"
			local TAG2 = "tag2"
			local TAG3 = "tag3"
			local TAG4 = "tag4"
			local o1 = gameobject.add({ pos(10, 10), area({ shape = "circle", radius = 5 }), TAG1 })
			local o2 = gameobject.add({ pos(10, 10), area({ shape = "circle", radius = 5 }), TAG2 })
			local o3 = gameobject.add({ pos(10, 10), area({ shape = "circle", radius = 5 }), TAG3 })
			local o4 = gameobject.add({ pos(10, 10), area({ shape = "circle", radius = 5 }), TAG4 })

			local collision_count = 0
			local ok = true
			collisions.on_tag_collision(TAG1, nil, function(info, _)
				collision_count = collision_count + 1
				if not ok then return end
				ok = (info.source.id == o1.id)
			end)
			wait(0) -- end of first component update, collisions happen after this
			wait(0) -- end of second component update, we can now check collisions
			assert(ok)
			assert(collision_count == 3)
		end)


		test("collisions are detected between a specific object and objects with a certain tag", function()
			local TAG1 = "tag1"
			local TAG2 = "tag2"
			local TAG3 = "tag3"
			local o1 = gameobject.add({ pos(10, 10), area({ shape = "circle", radius = 5 }), TAG1 })
			local o21 = gameobject.add({ pos(10, 10), area({ shape = "circle", radius = 5 }), TAG2 })
			local o22 = gameobject.add({ pos(10, 10), area({ shape = "circle", radius = 5 }), TAG2 })
			local o3 = gameobject.add({ pos(10, 10), area({ shape = "circle", radius = 5 }), TAG3 })

			local collision_count = 0
			local ok = true
			collisions.on_object_collision(o1, TAG2, function(info, _)
				collision_count = collision_count + 1
				if not ok then return end
				ok = (info.source.id == o1.id) and ((info.target.id == o21.id) or (info.target.id == o22.id))
			end)
			wait(0) -- end of first component update, collisions happen after this
			wait(0) -- end of second component update, we can now check collisions
			assert(ok)
			assert(collision_count == 2)
		end)
	end)
end