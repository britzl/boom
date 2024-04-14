local gameobject = require "boom.gameobject.gameobject"
local systems = require "boom.internal.systems"

local M = {}

local scenes = {}

--- Create a scene.
-- @string id Unique id of the scene
-- @function fn The scene code
function M.scene(id, fn)
	assert(id, "You must provide a scene id")
	assert(fn, "You must provide a scene function")
	assert(not scenes[id], "There is already a scene with id " .. id)
	local scene = {}
	scenes[id] = scene
	scene.id = id
	scene.fn = fn
end


--- Show a scene.
-- @string id Id of the scene to show
-- @param ... Additional arguments to pass to the scene function
function M.show(id, ...)
	assert(id, "You must provide a scene id")
	assert(scenes[id], "There is no scene with id " .. id)

	-- get the objects that should stay on scene switch
	local stay = gameobject.get("stay")

	-- remove the objects that should stay on scene switch
	-- from the main list of objects (so that they are not
	-- deleted on system destroy below)
	local objects = gameobject.objects()
	for i=1,#stay do
		local object = stay[i]
		objects[object.id] = nil
	end

	-- destroy all systems (incl game objects)
	systems.destroy()

	-- add the objects that should stay after scene switch
	objects = gameobject.objects()
	for i=1,#stay do
		local object = stay[i]
		objects[object.id] = object
	end

	-- init all systems again
	systems.init()

	-- run new scene
	local scene = scenes[id]
	scene.fn(...)
end


return M