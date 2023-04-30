local gameobject = require("boom.gameobject.gameobject")

return function()

	describe("gameobject", function()

		before(function()
			gameobject.__init(msg.url("test:/boom/boom#gameobjectfactory"))
		end)

		after(function()
			gameobject.__destroy()
		end)

		test("adding gameobjects", function()
			local o1 = gameobject.add({})
			local o2 = gameobject.add({})
			assert(o1)
			assert(o2)
			assert(o1 ~= o2)
		end)

		test("gameobjects have ids", function()
			local o1 = gameobject.add({})
			local o2 = gameobject.add({})
			assert(o1.id)
			assert(o2.id)
		end)

		test("getting gameobjects", function()
			local o1 = gameobject.add({})
			local o2 = gameobject.add({})

			assert(o1 == gameobject.object(o1.id))
			assert(o2 == gameobject.object(o2.id))

			local objects = gameobject.objects()
			assert(o1 == objects[o1.id])
			assert(o2 == objects[o2.id])
		end)

		test("destroying gameobjects", function()
			local o1 = gameobject.add({})
			local o2 = gameobject.add({})
			gameobject.destroy(o1)
			gameobject.__update(0)
			assert(nil == gameobject.object(o1.id))
			assert(o2 == gameobject.object(o2.id))
		end)

		test("destroying gameobject", function()
			local o1 = gameobject.add({})
			local o2 = gameobject.add({})
			o1.destroy()
			gameobject.__update(0)
			assert(nil == gameobject.object(o1.id))
			assert(o2 == gameobject.object(o2.id))
		end)

		test("destroying all gameobjects", function()
			local o1 = gameobject.add({})
			local o2 = gameobject.add({})
			gameobject.destroy_all()
			gameobject.__update(0)
			assert(nil == gameobject.object(o1.id))
			assert(nil == gameobject.object(o2.id))
		end)

		test("tagging gameobjects", function()
			local o1 = gameobject.add({ "foo" })
			local o2 = gameobject.add({ "foo", "bar" })
			assert(o1.tags.foo == true)
			assert(o1.tags.bar == nil)
			assert(o2.tags.foo == true)
			assert(o2.tags.bar == true)

			assert(o1.is("foo") == true)
			assert(o1.is("nope") == false)
			assert(o2.is("foo") == true)
			assert(o2.is("bar") == true)
		end)

		test("getting tagged gameobjects", function()
			gameobject.add({ "foo" })
			gameobject.add({ "foo", "bar" })
			local foo = gameobject.get("foo")
			assert(#foo == 2)
			local bar = gameobject.get("bar")
			assert(#bar == 1)
			local none = gameobject.get("none")
			assert(#none == 0)
		end)

		test("running function on tagged gameobjects", function()
			gameobject.add({ "foo" })
			gameobject.add({ "foo", "bar" })
			local foo_count = 0
			local bar_count = 0
			gameobject.every("foo", function() foo_count = foo_count + 1 end)
			gameobject.every("bar", function() bar_count = bar_count + 1 end)
			assert(foo_count == 2)
			assert(bar_count == 1)
		end)

		test("destroying all tagged gameobjects", function()
			local o1 = gameobject.add({ "foo" })
			local o2 = gameobject.add({ "foo", "bar" })
			local o3 = gameobject.add({ "foo", "bar" })
			gameobject.destroy_all("none")
			gameobject.__update(0)
			assert(gameobject.object(o1.id))
			assert(gameobject.object(o2.id))
			assert(gameobject.object(o3.id))
			gameobject.destroy_all("bar")
			gameobject.__update(0)
			assert(gameobject.object(o1.id))
			assert(not gameobject.object(o2.id))
			assert(not gameobject.object(o3.id))
			gameobject.destroy_all("foo")
			gameobject.__update(0)
			assert(not gameobject.object(o1.id))
		end)

		test("adding children", function()
			local parent1 = gameobject.add({})
			local parent2 = gameobject.add({})
			assert(next(parent1.children) == nil)
			assert(next(parent2.children) == nil)
			local child1 = parent1.add({})
			local child2 = parent1.add({})
			assert(child1)
			assert(child2)
			assert(parent1.children[child1.id])
			assert(parent1.children[child2.id])
			local grandchild1 = child1.add({})
			assert(grandchild1)
			assert(child1.children[grandchild1.id])

			assert(parent1 == gameobject.object(parent1.id))
			assert(parent2 == gameobject.object(parent2.id))
			assert(child1 == gameobject.object(child1.id))
			assert(child2 == gameobject.object(child2.id))
			assert(grandchild1 == gameobject.object(grandchild1.id))
		end)

		test("destroying children", function()
			local parent1 = gameobject.add({})
			local parent2 = gameobject.add({})
			local child1 = parent1.add({})
			local child2 = parent1.add({})
			local grandchild1 = child1.add({})
			local grandchild2 = child1.add({})

			child1.destroy()
			gameobject.__update(0)

			assert(parent1 == gameobject.object(parent1.id))
			assert(parent2 == gameobject.object(parent2.id))
			assert(nil == gameobject.object(child1.id))
			assert(child2 == gameobject.object(child2.id))
			assert(nil == gameobject.object(grandchild1.id))
			assert(nil == gameobject.object(grandchild2.id))
		end)
	end)
end