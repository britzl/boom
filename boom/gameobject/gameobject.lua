local M = {}

local objects = {}
local objects_to_delete = {}

local OBJECT_FACTORY = nil


local ROOT = hash("/root")
local SPRITE = hash("/sprite")
local LABEL_LEFT = hash("/label_left")
local LABEL_RIGHT = hash("/label_right")
local LABEL_CENTER = hash("/label_center")

---
-- Add a game object with a set of components
-- @param comps The components for the game object
-- @return The created game object
function M.add(comps)
	local ids = collectionfactory.create(OBJECT_FACTORY)
	local id = ids[ROOT]
	msg.post(ids[SPRITE], "disable")
	msg.post(ids[LABEL_LEFT], "disable")
	msg.post(ids[LABEL_RIGHT], "disable")
	msg.post(ids[LABEL_CENTER], "disable")

	local object = {}
	objects[id] = object
	object.id = id
	object.ids = ids
	object.comps = {}
	object.tags = {}
	object.children = {}

	-- set the game object id as a tag
	object.tags[id] = true

	-- add components to object
	for i=1,#comps do
		local comp = comps[i]
		-- convert tag into comp object
		if type(comp) == "string" then
			comp = {
				tag = comp
			}
		end

		-- data components don't have an id, assign one!
		-- example: { score = 0 }
		if not comp.tag then
			comp.tag = "data" .. i
		end

		-- apply comp properties to object
		for k,v in pairs(comp) do
			-- ignore tag
			-- ignore private properties (starting with __)
			-- ignore component lifecycle functions (init, update, destroy, on_input)
			if k ~= "update" and k ~= "init" and k ~= "destroy" and k ~= "on_input" and k ~= "tag" and k:sub(1,2) ~= "__" then
				if object[k] then error(("Object '%s' already has key '%s'"):format(object.id, k)) end
				object[k] = v
				comp[k] = nil
			end
		end

		-- assign object to comp and vice versa
		object.comps[i] = comp
		object.comps[comp.tag] = comp
		comp.object = object

		-- set tag on object
		object.tags[comp.tag] = true
	end

	object.add = function(...)
		local o = M.add(...)
		go.set_parent(o.id, object.id)
		object.children[#object.children + 1] = o
	end

	-- init components
	for i=1,#object.comps do
		local comp = object.comps[i]
		if comp.init then
			comp.init()
		end
	end

	return object
end

---
-- Destroy a game object and all of its components
-- @param object The object to destroy
function M.destroy(object)
	assert(object)
	if object.destroyed then
		return
	end

	-- delete the game object and flag the game object as deleted
	-- the object will not actually be removed from the system
	-- until the next update
	go.delete(object.id, true)
	object.destroyed = true
	objects_to_delete[#objects_to_delete + 1] = object.id

	-- destroy object components
	for tag,comp in pairs(object.comps) do
		if comp.destroy then
			comp.destroy()
		end
	end
end

---
-- Destroy all objects with a certain tag
-- @param tag The tag to destroy or nil to destroy all objects
function M.destroy_all(tag)
	for _,object in pairs(objects) do
		if not tag or object.tags[tag] then
			M.destroy(object)
		end
	end
end

--- 
-- Get game object with specific id
-- @param id
-- @return The object or nil if it doesn't exist
function M.object(id)
	return objects[id]
end


function M.objects()
	return objects
end

---
-- Get all game objects with the specified tag
-- @param tag The tag to get objects for, nil to get all objects
-- @return List of objects
function M.get(tag)
	if not tag then
		return objects
	end
	local tagged = {}
	for _,object in pairs(objects) do
		if object.tags[tag] then
			tagged[#tagged + 1] = object
		end
	end
	return tagged
end

---
-- Run callback on every object with a certain tag
-- @param tag
-- @param cb
function M.every(tag, cb)
	for _,object in pairs(objects) do
		if object.tags[tag] then
			cb(object)
		end
	end
end

---- lifecycle functions

function M.__init()
	OBJECT_FACTORY = msg.url("#objectfactory")
end

function M.__update(dt)
	-- delete objects
	for i=#objects_to_delete,1,-1 do
		local id_to_delete = objects_to_delete[i]
		objects_to_delete[i] = nil
		local object = objects[id_to_delete]
		-- the hash might have been reused in the same frame for a new object
		-- make sure to only remove the object if it has the 'destroyed' flag
		if object.destroyed then
			objects[id_to_delete] = nil
		end
	end

	-- update active objects
	for id,object in pairs(objects) do
		if not object.destroyed then
			for tag,comp in pairs(object.comps) do
				if comp.update then comp.update(dt) end
			end
		end
	end
end

function M.__on_input(action_id, action)
	for id,object in pairs(objects) do
		if not object.destroyed then
			for tag,comp in pairs(object.comps) do
				if comp.on_input then comp.on_input(action_id, action) end
			end
		end
	end
end


function M.__destroy()
	for id,object in pairs(objects) do
		go.delete(id, true)
	end
	objects = {}
	objects_to_delete = {}
end

return M