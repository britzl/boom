local M = {}

local components = {
	require("boom.components.pos"),
	require("boom.components.scale"),
	require("boom.components.rotate"),
	require("boom.components.text"),
	require("boom.components.sprite"),
	require("boom.components.move"),
	require("boom.components.opacity"),
	require("boom.components.color"),
	require("boom.components.area"),
}

function M.init()
	for _,comp in ipairs(components) do
		if comp.init then
			comp.init()
			comp.init = nil
		end
		for name,fn in pairs(comp) do
			M[name] = fn
		end
	end
end

return M