# Boom

Boom is a game framework built on top of Defold. It is heavily inspired by the [Kaboom.js game framework](https://github.com/replit/kaboom).


## Setup and Installation

* Add Boom as a project dependency. Use one of the versions on the [releases page](https://github.com/britzl/boom/releases).
* Add `boom/boom.collection` to your project
* Set `boom/render/boom.render` as your render script
* Set `boom/boom.input_bindings` as your input bindings


## Usage

Boom can be started from any script in your project. For setup in a new project simply create a new script file and add the following code:

```lua
local boom = require("boom.boom")

function init(self)
	boom(function()
		-- add your boom game code here
	end)
end
```

## Concepts

Just like Defold, Boom is based around the concept of game objects and components. Boom uses Defold game objects and components under the hood, and adds its own constructs on top of it.

You create a Boom game object with a sprite and a position component like this:

```lua
	-- create a player game object
	local player = add({
		sprite("hero"),
		pos(100, 100)
	})
```

Once you have created a game object you can use the components on the object:

```lua
	-- set the player x position to 200
	player.pos.x = 200

	-- move the player left 100 pixels per second
	player.move(LEFT, 100)
```

### Tags

You can assign tags to game objects and use these to perform operations on game objects with a specific tag:

```lua
	-- create a bunch of balls
	for i=1,10 do
		add({
			sprite("ball"),
			pos(rand(0, width()), rand(0, height()))
			"ball"
		})
	end

	-- call a function on all balls and start moving them up at 100px/s
	every("ball", function(ball)
		ball.move(UP, 100)
	end)
```


## API Reference

Full [API reference here](api.md).


## Examples

Several examples of how to use Boom can be found in the [`examples/`](examples) folder.