local M = {}

M.OBJECT= nil
M.AREA_RECT = nil
M.AREA_SPHERE = nil

function M.init()
	M.OBJECT = msg.url("#objectfactory")
	M.AREA_RECT = msg.url("#arearectfactory")
end



return M