local gameobject = require "boom.gameobject.gameobject"
local vec2 = require "boom.math.vec2"
local pos = require "boom.components.pos"

local M = {}



function M.add_level(map, options)
	local tile_width = options.tile_width
	local tile_height = options.tile_height
	local first_tile_pos = options.pos or vec2(0, 0)
	local tiles = options.tiles or {}

	for y=#map,1,-1 do
		local row = map[#map - y + 1]
		for x=1,#row do
			local c = row:sub(x, x)
			local tile = tiles[c]
			if tile then
				local comps = tile()
				local tx = first_tile_pos.x + (x * tile_width)
				local ty = first_tile_pos.y + (y * tile_height)
				comps[#comps + 1] = pos.pos(tx, ty)
				local object = gameobject.add(comps)
			end
		end
	end
end


return M