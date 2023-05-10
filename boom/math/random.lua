local M = {}

--- Get a random number.
-- If called with no arguments the function returns
-- a number between 0 and 1. If called with a single argument 'a' a number
-- between 0 and 'a' is returned. If called with two arguments 'a' and 'b' a
-- number between 'a' and 'b' is returned.
-- @number a
-- @number b
-- @treturn number number Random number
function M.rand(a, b)
	local r = math.random()
	if not a then return r end
	if not b then return r * a end
	return (r * (b - a + 1)) + a
end

--- Same as rand() but floored.
-- @number a
-- @number b
-- @treturn number number Random integer number
function M.randi(a, b)
	return math.floor(M.rand(a, b))
end

return M