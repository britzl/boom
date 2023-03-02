local gameobject = require "boom.gameobject.gameobject"
local systems = require "boom.systems"

local M = {}

local scenes = {}

---
-- Create a scene
-- @param id Unique id of the scene
-- @param fn The scene code
function M.scene(id, fn)
	assert(id, "You must provide a scene id")
	assert(fn, "You must provide a scene function")
	assert(not scenes[id], "There is already a scene with id " .. id)
	local scene = {}
	scenes[id] = scene
	scene.id = id
	scene.fn = fn
end


---
-- Show a scene
-- @param id Id of the scene to show
function M.show(id)
	assert(id, "You must provide a scene id")
	assert(scenes[id], "There is no scene with id " .. id)
	systems.destroy()

	local scene = scenes[id]
	scene.fn()
end


return M