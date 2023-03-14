local vec2 = require "boom.math.vec2"

local M = {}

local V2_ZERO = vec2(0)
local V2_ONE = vec2(1)

local ANCHORS = {
	center = vec2(0),
	topleft = vec2(-1, 1),
	left = vec2(-1, 0),
	topright = vec2(1, 1),
	right = vec2(1, 0),
	bottomright = vec2(1, -1),
	bottom = vec2(0, -1),
	bottomleft = vec2(-1, 0),
}
---
-- Anchor point for render
-- @param anchor Anchor
-- @return The component
function M.anchor(anchor)
	local c = {}
	c.tag = "anchor"
	c.anchor = ANCHORS[anchor] or V2_ZERO
	return c
end

return M