local gameobject = require "boom.gameobject.gameobject"
local vec2 = require "boom.math.vec2"
local pos = require "boom.components.pos"

local M = {}


--- Construct a level based on symbols.
-- @table map List of strings presenting horizontal rows of tiles
-- @table options Level options (tile_width, tile_height, pos, tiles)
-- @treturn GameObject level Game object with tiles as children
function M.add_level(map, options)
	local level = gameobject.add({ options.pos and pos.pos(options.pos) or pos.pos(0, 0) })
	local tile_width = options.tile_width
	local tile_height = options.tile_height
	local tiles = options.tiles or {}

	for y=#map,1,-1 do
		local row = map[#map - y + 1]
		for x=1,#row do
			local c = row:sub(x, x)
			local tile = tiles[c]
			if tile then
				local comps = tile()
				local tx = ((x - 1) * tile_width)
				local ty = ((y - 1) * tile_height)
				comps[#comps + 1] = pos.pos(tx, ty)
				level.add(comps)
			end
		end
	end

	return level
end


return M