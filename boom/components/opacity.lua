--- Component to control the opacity of a game object.

local M = {}

--- Create an opacity component.
-- @number opacity The opacity from 0.0 to 1.0
-- @treturn component Opacity The created component
function M.opacity(opacity)
	local c = {}
	c.tag = "opacity"

	--- The opacity of the component instance.
	-- @type Opacity
	-- @field number
	c.opacity = opacity
	return c
end

return M