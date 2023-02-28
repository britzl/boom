local M = {}

local WIDTH = sys.get_config_int("display.width")
local HEIGHT = sys.get_config_int("display.height")

function M.width()
	return WIDTH
end

function M.height()
	return HEIGHT
end

return M