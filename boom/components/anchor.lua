--- Anchor component.
-- Use this component to offset any rendered component such as a SpriteComp from the
-- center of the game object.
--
-- @usage
-- local bullet = add({
--     sprite("bullet"),
--     anchor("left")
-- })


local vec2 = require "boom.math.vec2"
local callable = require "boom.internal.callable"

local M = {}

local V2_ZERO = vec2(0)
local V2_ONE = vec2(1)

local ANCHORS = {
	center = vec2(0),

	topleft = vec2(-1, 1),
	top = vec2(0, 1),
	topright = vec2(1, 1),

	left = vec2(-1, 0),
	right = vec2(1, 0),

	bottomleft = vec2(-1, -1),
	bottom = vec2(0, -1),
	bottomright = vec2(1, -1),
}

---
-- Anchor point for render.
-- @string anchor Anchor (center, topleft, left, topright, right, bottomright, bottom, bottomleft)
-- @treturn AnchorComp component The anchor component.
function M.anchor(anchor)
	local c = {}
	c.tag = "anchor"

	--- Anchor point.
	-- @type AnchorComp
	-- @field string
	c.anchor = ANCHORS[anchor] or V2_ZERO
	return c
end

return callable.make(M, M.anchor)