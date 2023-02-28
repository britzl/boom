local factories = require "boom.factories"

local M = {}


local objects = {}

function M.init()
end

function M.update(dt)
	for id,object in pairs(objects) do
		for tag,comp in pairs(object.comps) do
			if comp.update then comp.update(dt) end
		end
	end
end

function M.add(comps)
	local id = factory.create(factories.OBJECT)
	msg.post(msg.url(nil, id, "sprite"), "disable")
	msg.post(msg.url(nil, id, "label"), "disable")

	local object = {}
	objects[id] = object
	object.id = id
	object.comps = {}

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
		if not comp.tag then
			comp.tag = "data" .. i
		end

		-- apply comp properties to object
		for k,v in pairs(comp) do
			if k ~= "update" and k ~= "init" and k ~= "tag" then
				if object[k] then error(("Object '%s' already has key '%s'"):format(object.id, k)) end
				object[k] = v
				comp[k] = nil
			end
		end

		-- assign object to comp and vice versa
		object.comps[comp.tag] = comp
		comp.object = object
	end

	-- init components
	for tag,comp in pairs(object.comps) do
		if comp.init then
			comp.init()
		end
	end

	return object
end


function M.destroy(object)
	assert(object)
	print("destroy", object.id)
	go.delete(object.id)
	objects[object.id] = nil
end

function M.object(id)
	return objects[id]
end

function M.get(tag)
	if not tag then
		return objects
	end
	local tagged = {}
	for _,object in pairs(objects) do
		if object[tag] then
			tagged[#tagged + 1] = object
		end
	end
	return tagged
end

return M