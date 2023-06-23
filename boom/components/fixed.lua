--- Make object unaffected by camera.
-- @usage
-- local score = 100
-- local score_text = add({
--     text("SCORE: " .. score),
--     anchor("topleft"),
--     pos(5, height() - 5)
-- })

local callable = require "boom.internal.callable"

local M = {}

--- Create a fixed component
-- @treturn FixedComp component The component
function M.fixed(...)
	local c = {}
	c.tag = "fixed"
	return c
end

return callable.make(M, M.fixed)