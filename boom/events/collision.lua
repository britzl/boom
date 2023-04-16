local collisions = require "boom.collisions"

local M = {}

---
-- Register an event that runs when two game objects collide
-- @param tag1 Tag which the first game object must have
-- @param tag2 Optional tag which the second game object must have
-- @param fn Will receive (collision, cancel) as args
-- @return Cancel event function
function M.on_collide(tag1, tag2, fn)
	assert(tag1)
	assert(fn)
	return collisions.on_tag_collision(tag1, tag2, fn)
end

return M