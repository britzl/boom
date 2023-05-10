--- Component to control the opacity of a game object.

local M = {}

--- Create an opacity component.
-- @number opacity The opacity from 0.0 to 1.0
-- @treturn OpacityComp component The created component
function M.opacity(opacity)
	local c = {}
	c.tag = "opacity"

	--- The opacity of the component instance.
	-- @type OpacityComp
	-- @field number
	c.opacity = opacity
	return c
end

return M