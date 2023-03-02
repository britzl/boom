local M = {}

-- this function will be run once on game startup in the context of the
-- boom game object
function M.__init()
end

-- this is the main component function, it will be set as a global and can be
-- uses when creating game objects
-- it can take any number of component specific arguments
function M.example(foo, bar)
	local c = {}
	c.tag = "example"

	c.init = function()
		-- will be run when the game object is created
	end

	c.do_foobar = function(a, b)
		-- a function which will be available on the game object
	end

	f.destroy = function()
		-- will be run when the game object is destroyed
	end

	return c
end

return M