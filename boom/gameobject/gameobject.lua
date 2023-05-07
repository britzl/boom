local M = {}

local objects = {}
local objects_to_delete = {}
local components_on_input = {}

local GAMEOBJECT_FACTORY = nil

local ROOT = hash("/root")
local SPRITE = hash("/sprite")
local LABEL_LEFT = hash("/label_left")
local LABEL_RIGHT = hash("/label_right")
local LABEL_CENTER = hash("/label_center")


local function destroy_component(comp)
	if comp.destroy then
		comp.destroy()
	end
	if comp.on_input then
		components_on_input[comp] = nil
	end
end

local function use(object, comp_or_tag)
	local comp = comp_or_tag

	-- convert tag into comp object
	if type(comp_or_tag) == "string" then
		comp = {
			tag = comp_or_tag
		}
	end

	-- data components don't have an id, assign one!
	-- example: { score = 0 }
	if not comp.tag then
		comp.tag = "data" .. #object.comps
	end

	-- apply comp properties to object
	for k,v in pairs(comp) do
		-- ignore tag
		-- ignore private properties (starting with __)
		-- ignore component lifecycle functions init, update and destroy
		-- handle component lifecycle functions on_input
		-- for all others we set the component key and value on the object itself
		if k == "update" or k == "init" or k == "destroy" or k == "tag" or k:sub(1,2) == "__" then
			-- no-op
		elseif k == "on_input" then
			components_on_input[comp] = v
		else
			if object[k] or object.properties[k] then error(("Object '%s' already has key '%s'"):format(object.id, k)) end
			if type(v) == "function" then
				object[k] = v
			else
				object.properties[k] = v
			end
			comp[k] = nil
		end
	end

	-- assign object to comp and vice versa
	object.comps[#object.comps + 1] = comp
	object.comps[comp.tag] = comp
	comp.object = object

	-- set tag on object
	object.tags[comp.tag] = true
end


local function unuse(object, tag)
	for i=1,#object.comps do
		local comp = object.comps[i]
		if comp.tag == tag then
			table.remove(object.comps, i)
			destroy_component(comp)
			break
		end
	end
	object.comps[tag] = nil
	object.tags[tag] = nil
end


--- Add a game object with a set of components.
-- @table comps The components for the game object
-- @treturn object GameObject The created game object
function M.add(comps)
	local ids = collectionfactory.create(GAMEOBJECT_FACTORY)
	local id = ids[ROOT]
	msg.post(ids[SPRITE], "disable")
	msg.post(ids[LABEL_LEFT], "disable")
	msg.post(ids[LABEL_RIGHT], "disable")
	msg.post(ids[LABEL_CENTER], "disable")

	local object = {}
	objects[id] = object
	object.id = id
	object.ids = ids
	object.parent = nil
	object.comps = {}
	object.tags = {}
	object.children = {}
	object.properties = {}

	-- set the game object id as a tag
	object.tags[id] = true

	-- add components to object
	for i=1,#comps do
		local comp = comps[i]
		use(object, comp)
	end

	--- Add a game object as a child of this game object.
	-- @type GameObject
	-- @table comps The game object components
	-- @treturn object table The game object
	object.add = function(comps)
		local child = M.add(comps)
		child.parent = object.id
		go.set_parent(child.id, object.id)
		object.children[child.id] = child
		return child
	end

	---
	-- Destroy this game object
	-- @type GameObject
	object.destroy = function()
		M.destroy(object)
	end

	--- Check if there is a certain tag on this game object.
	-- @type GameObject
	-- @string tag The tag to check
	-- @treturn result bool Returns true if the tag exists on the game object
	object.is = function(tag)
		return object.tags[tag] ~= nil
	end

	--- Add a component to this game object.
	-- @type GameObject
	-- @table comp The component to use
	object.use = function(comp)
		use(object, comp)
	end

	--- Remove a component from this game object.
	-- @type GameObject
	-- @string tag The component tag to remove
	object.unuse = function(tag)
		unuse(object, tag)
	end

	--- Get state for a specific component on this game object.
	-- @type GameObject
	-- @string tag The component to get state for
	-- @treturn state table The component state
	object.c = function(tag)
		return object.comps[tag]
	end

	local properties = object.properties
	local mt = {}
	mt.__index = function(t, k)
		local v = rawget(t, k)
		if v then return v end
		if properties[k] ~= nil then return properties[k] end
	end
	mt.__newindex = function(t, k, v)
		local current = rawget(t, k)
		if current then
			rawset(t, k, v)
		elseif properties[k] ~= v then
			properties[k] = v
			rawset(object, "dirty", true)
			--print("object", rawget(object, "id"), "became dirty when setting", k, "to", v)
		end
	end
	object = setmetatable(object, mt)

	-- init components
	for i=1,#object.comps do
		local comp = object.comps[i]
		if comp.init then
			comp.init()
		end
	end

	return object
end

--- Destroy a game object and all of its components.
-- @tparam object GameObject The object to destroy
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
		destroy_component(comp)
	end

	-- destroy children
	for _,child in pairs(object.children) do
		M.destroy(child)
	end

	-- remove from parent
	if object.parent then
		local parent = objects[object.parent]
		parent.children[object.id] = nil
	end
end

--- Destroy all objects with a certain tag.
-- @string tag The tag to destroy or nil to destroy all objects
function M.destroy_all(tag)
	for _,object in pairs(objects) do
		if not tag or object.tags[tag] then
			M.destroy(object)
		end
	end
end

--- Get game object with specific id.
-- @string id
-- @treturn id string The object or nil if it doesn't exist
function M.object(id)
	return objects[id]
end

--- Get all game objects.
-- @treturn objects table All game objects
function M.objects()
	return objects
end

--- Get all game objects with the specified tag.
-- @string tag The tag to get objects for, nil to get all objects
-- @treturn objects table List of objects
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

--- Run callback on every object with a certain tag.
-- @string tag The tag that must exist on the object
-- @function cb The callback to run
function M.every(tag, cb)
	for _,object in pairs(objects) do
		if object.tags[tag] then
			cb(object)
		end
	end
end

--[[ lifecycle functions ]]

function M.__init(config, url)
	GAMEOBJECT_FACTORY = url or msg.url("#gameobjectfactory")
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
		if not object.destroyed and object.dirty then
			--print("update", object.name)
			object.dirty = false
			for tag,comp in pairs(object.comps) do
				if comp.update then comp.update(dt) end
			end
		end
	end
end

function M.__on_input(action_id, action)
	for _,fn in pairs(components_on_input) do
		fn(action_id, action)
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