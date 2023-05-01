# Boom

* boom
  * [boom](#boom)
* components
  * [anchor](#anchor)
  * [area](#area)
  * [body](#body)
  * [color](#color)
  * [double_jump](#double_jump)
  * [fadein](#fadein)
  * [fixed](#fixed)
  * [health](#health)
  * [lifespan](#lifespan)
  * [move](#move)
  * [offscreen](#offscreen)
  * [opacity](#opacity)
  * [pos](#pos)
  * [rotate](#rotate)
  * [scale](#scale)
  * [sprite](#sprite)
  * [stay](#stay)
  * [text](#text)
  * [timer](#timer)
  * [z](#z)
* events
  * [collision](#collision)
  * [key](#key)
  * [mouse](#mouse)
  * [update](#update)
* gameobject
  * [gameobject](#gameobject)
* info
  * [camera](#camera)
  * [gravity](#gravity)
  * [screen](#screen)
  * [time](#time)
* level
  * [level](#level)
* math
  * [random](#random)
  * [tween](#tween)
  * [vec2](#vec2)
* scene
  * [scene](#scene)
* timer
  * [timer](#timer)

# boom
*File: `boom/boom.lua`*

Boom is a game framework built on top of Defold. It is heavily inspired by the Kaboom.js game framework.


## boom(game, )
Start a boom game Call this from your own game script


PARAMS
* `game` - Game loop function


---

# anchor
*File: `boom/components/anchor.lua`*

Anchor component. Use this component to offset any rendered component such as a SpriteComp from the center of the game object.


## anchor(anchor, )
Anchor point for render.


PARAMS
* `anchor` [`string`] - Anchor (center, topleft, left, topright, right, bottomright, bottom, bottomleft)

RETURNS
* `component` [`Anchor`] - The anchor component.


---

# area
*File: `boom/components/area.lua`*

Area component. Use this component to define a collider area and bounds for a game object.


## area(options, )
Create a collider area and enabled collision detection. This will create an area component which is used to describe an area which can collide with other area components.


PARAMS
* `options` [`table`] - Component options (width and height)

RETURNS
* `area` [`AreaComp`] - The area component


## AreaComp.get_collisions()
Get all collisions currently happening for this component. 


RETURNS
* `collisions` [`table`] - List of collisions


## AreaComp.check_collision(other_object, )
Check collision between this component and another object. 


PARAMS
* `other_object` [`GameObject`] - The game object to check collisions with.

RETURNS
* `collision` [`bool`] - Return true if colliding with the other object
* `data` [`table`] - Collision data


## AreaComp.on_collide(tag, cb, )
Register event listener when this component is colliding. 


PARAMS
* `tag` [`string`] - Optional tag which colliding object must have, nil for all collisions
* `cb` [`function`] - Function to call when collision is detected


## AreaComp.on_click(cb, )
Register event listener when this component is clicked. 


PARAMS
* `cb` [`function`] - Function to call when clicked


## AreaComp.has_point(point, )
Check if a point is within the area of this component. 


PARAMS
* `point` - The point to check

RETURNS
* `result` [`bool`] - Will return true if point is within area


---

# body
*File: `boom/components/body.lua`*




## body(options, )
Physical body that responds to gravity. Requires AreaComp and PosComp components on the game object. This also makes the object solid.


PARAMS
* `options` [`table`] - Component options (jump_force, is_static)

RETURNS
* `component` [`BodyComp`] - The body component


## BodyComp.jump(force, )
Add upward force 


PARAMS
* `force` [`number`] - The upward force to apply


---

# color
*File: `boom/components/color.lua`*

Component to control the color of the game object 


## color(..., )
Create a color component 


PARAMS
* `...` - R,g,b components or color

RETURNS
* `component` [`ColorComp`] - The color component


---

# double_jump
*File: `boom/components/double_jump.lua`*




## double_jump(options, )
Enables double jump. Requires &quot;body&quot; component


PARAMS
* `options` [`table`] - Component options

RETURNS
* `component` [`DoubleJumpComp`] - The double jump component


## DoubleJumpComp.double_jump(force, )



PARAMS
* `force` [`number`] - The upward force to apply


---

# fadein
*File: `boom/components/fadein.lua`*

Fade in game object visual components such as sprites. 


## fadein(time, )
Fade object in. 


PARAMS
* `time` [`number`] - In seconds

RETURNS
* `component` [`FadeInComp`] - The fade in component.


---

# fixed
*File: `boom/components/fixed.lua`*

Make object unaffected by camera. 


## fixed()
Create a fixed component 


RETURNS
* `component` [`Fixed`] - The component


---

# health
*File: `boom/components/health.lua`*

Handles health related logic. 


## health(hp, )
Create a health component 


PARAMS
* `hp` [`number`] - Initial health

RETURNS
* `component` [`HealthComp`] - The health component


## HealthComp.on_heal(cb, )
Register an event that runs when heal() is called. 


PARAMS
* `cb` [`function`] - Function to call


## HealthComp.on_hurt(cb, )
Register an event that runs when hurt() is called. 


PARAMS
* `cb` [`function`] - Function to call


## HealthComp.on_death(cb, )
Register an event that runs when health is 0 or less. 


PARAMS
* `cb` [`function`] - Function to call


## HealthComp.heal(n, )
Increase hp. Will trigger on_heal.


PARAMS
* `n` [`number`] - Amount to increase


## HealthComp.hurt(n, )
Decrease hp. Will trigger on_hurt


PARAMS
* `n` [`number`] - Amount to decrease


---

# lifespan
*File: `boom/components/lifespan.lua`*

Destroy the game object after certain amount of time. Use this component when you need a game object to be destroyed after a period of time.


## lifespan(time, options, )
Create a Lifespan component. 


PARAMS
* `time` [`number`] - In seconds
* `options` [`table`] - (fade)

RETURNS
* `component` [`Lifespan`] - The created component


---

# move
*File: `boom/components/move.lua`*

Move towards a direction infinitely, and destroys when it leaves the game view. 
```
projectile = add({
    sprite("bullet"),
    pos(player.pos),
    move(vec2(0, 1), 1200),
})
```

## move(direction, speed, )
Create a move component. 


PARAMS
* `direction` [`vec2`] - Direction of movement.
* `speed` [`number`] - Speed of movement in pixels per second.

RETURNS
* `component` [`Move`] - The created component.


---

# offscreen
*File: `boom/components/offscreen.lua`*

Control the behavior of a game object when it goes out of view 


## offscreen(options, )
Create an offscreen component. 


PARAMS
* `options` [`table`] - (distance, destroy)

RETURNS
* `component` [`Offscreen`] - The created component


## Offscreen.on_exit_screen(cb, )
Register a callback that runs when the object goes out of view 


PARAMS
* `cb` [`function`] - Function to call when the object goes out of view


## Offscreen.on_enter_screen(cb, )
Register a callback that runs when the object enters view 


PARAMS
* `cb` [`function`] - Function to call when the object enters view


---

# opacity
*File: `boom/components/opacity.lua`*

Component to control the opacity of a game object. 


## opacity(opacity, )
Create an opacity component. 


PARAMS
* `opacity` [`number`] - The opacity from 0.0 to 1.0

RETURNS
* `component` [`Opacity`] - The created component


## Opacity.opacity [`number`]
The opacity of the component instance. 



---

# pos
*File: `boom/components/pos.lua`*

Position of a game object. 
```
-- this game object will draw a "bean" sprite at (100, 200)
add({
   pos(100, 200),
   sprite("bean")
})
```

## pos(x, y, )
Create a position component. 


PARAMS
* `x` [`number`] - 
* `y` [`number`] - 

RETURNS
* `component` [`Pos`] - The created component


## Pos.move(x, y, )
Move a number of pixels per second. 


PARAMS
* `x` [`number`] - 
* `y` [`number`] - 


---

# rotate
*File: `boom/components/rotate.lua`*




## rotate(angle, )
Apply rotation to object


PARAMS
* `angle` - Angle in degrees

RETURNS
* `The` - Component


---

# scale
*File: `boom/components/scale.lua`*




## scale(x, y, )
Apply a scale to the object


PARAMS
* `x` - 
* `y` - 

RETURNS
* `The` - Component


---

# sprite
*File: `boom/components/sprite.lua`*




## sprite(anim, options, )
Render a sprite. 


PARAMS
* `anim` [`string`] - Which animation or image to use
* `options` [`table`] - Extra options (flip_x, flip_y, width, height)

RETURNS
* `component` [`Sprite`] - The created component


## Sprite.anim [`string`]
The current animation 



## Sprite.width [`number`]
The width of the sprite 



## Sprite.height [`number`]
The height of the sprite 



## Sprite.flip_x [`bool`]
If sprite should be flipped horizontally 



## Sprite.flip_y [`bool`]
If the sprite should be flipped vertically 



## Sprite.play(anim, )
Play an animation 


PARAMS
* `anim` [`string`] - The animation to play


## Sprite.stop()
Stop the current animation 



---

# stay
*File: `boom/components/stay.lua`*




## stay()
Do not get destroyed on scene switch. 


RETURNS
* `component` [`Stay`] - The created component


---

# text
*File: `boom/components/text.lua`*




## text(text, options, )
Render text. 


PARAMS
* `text` [`string`] - The text to show
* `options` [`table`] - Text options (width, font, align)

RETURNS
* `component` [`Text`] - The created component


## Text.text [`string`]
The text to render 



---

# timer
*File: `boom/components/timer.lua`*

Run an action once or repeatedly at a set interval 


## timer(n, fn, )
Run certain action after some time. 


PARAMS
* `n` [`number`] - Number of seconds to wait
* `fn` [`function`] - The function to call

RETURNS
* `component` [`Timer`] - The created component


## Timer.wait(n, fn, )
Run a callback function after n seconds 


PARAMS
* `n` [`number`] - Seconds
* `fn` [`function`] - The function to call


## Timer.loop(n, fn, )
Run a callback function every n seconds 


PARAMS
* `n` [`number`] - Seconds
* `fn` [`function`] - The function to call


## Timer.cancel()
Cancel the timer 



---

# z
*File: `boom/components/z.lua`*




## z(z, )
Determines the draw order for objects. Object will be drawn on top if z value is bigger.


PARAMS
* `z` [`number`] - Z-value of the object.

RETURNS
* `component` [`Z`] - The created component


## Z.z [`number`]
The z value 



---

# collision
*File: `boom/events/collision.lua`*




## on_collide(tag1, tag2, fn, )
Register an event that runs when two game objects collide


PARAMS
* `tag1` - Tag which the first game object must have
* `tag2` - Optional tag which the second game object must have
* `fn` - Will receive (collision, cancel) as args

RETURNS
* `Cancel` - Event function


---

# key
*File: `boom/events/key.lua`*




## on_key_press(key_id, cb, )
Register callback that runs when a certain key is pressed. 


PARAMS
* `key_id` [`string`] - The key that must be pressed or nil for any key
* `cb` [`function`] - The callback

RETURNS
* `fn` [`function`] - Cancel callback


## on_key_release(key_id, cb, )
Register callback that runs when a certain key is released. 


PARAMS
* `key_id` [`string`] - The key that must be released or nil for any key
* `cb` [`function`] - The callback

RETURNS
* `fn` [`function`] - Cancel callback


## is_key_down(key_id, )
Check if a certain key is down. 


PARAMS
* `key_id` [`string`] - The key that must be down, or nil for any key

RETURNS
* `down` [`bool`] - True if down


---

# mouse
*File: `boom/events/mouse.lua`*




## on_click(tag, cb, )
Set mouse click listener. 


PARAMS
* `tag` [`string`] - Optional click on object with tag filter
* `cb` [`function`] - Callback when mouse button is clicked

RETURNS
* `fn` [`function`] - Cancel listener function


## mouse_pos()
Get mouse position (screen coordinates). 


RETURNS
* `pos` [`vec2`] - Mouse position


---

# update
*File: `boom/events/update.lua`*




## on_update(tag, fn, )
Run a function every frame. Register an event that runs every frame, optionally for all game objects with certain tag


PARAMS
* `tag` [`string`] - Run event for all objects matching tag (optional)
* `fn` [`function`] - The event function to call. Will receive object and cancel function.


---

# gameobject
*File: `boom/gameobject/gameobject.lua`*




## add(comps, )
Add a game object with a set of components. 


PARAMS
* `comps` [`table`] - The components for the game object

RETURNS
* `object` [`GameObject`] - The created game object


## GameObject.add(comps, )
Add a game object as a child of this game object. 


PARAMS
* `comps` [`table`] - The game object components

RETURNS
* `object` [`table`] - The game object


## GameObject.destroy()
Destroy this game object



## GameObject.is(tag, )
Check if there is a certain tag on this game object. 


PARAMS
* `tag` [`string`] - The tag to check

RETURNS
* `result` [`bool`] - Returns true if the tag exists on the game object


## GameObject.use(comp, )
Add a component to this game object. 


PARAMS
* `comp` [`table`] - The component to use


## GameObject.unuse(tag, )
Remove a component from this game object. 


PARAMS
* `tag` [`string`] - The component tag to remove


## GameObject.c(tag, )
Get state for a specific component on this game object. 


PARAMS
* `tag` [`string`] - The component to get state for

RETURNS
* `state` [`table`] - The component state


## destroy(object, )
Destroy a game object and all of its components. 


PARAMS
* `object` [`GameObject`] - The object to destroy


## destroy_all(tag, )
Destroy all objects with a certain tag


PARAMS
* `tag` [`string`] - The tag to destroy or nil to destroy all objects


## object(id, )
Get game object with specific id. 


PARAMS
* `id` [`string`] - 

RETURNS
* `id` [`string`] - The object or nil if it doesn&#x27;t exist


## objects()
Get all game objects. 


RETURNS
* `objects` [`table`] - All game objects


## get(tag, )
Get all game objects with the specified tag. 


PARAMS
* `tag` [`string`] - The tag to get objects for, nil to get all objects

RETURNS
* `objects` [`table`] - List of objects


## every(tag, cb, )
Run callback on every object with a certain tag. 


PARAMS
* `tag` [`string`] - The tag that must exist on the object
* `cb` [`function`] - The callback to run


---

# camera
*File: `boom/info/camera.lua`*




## cam_pos(x, y, )
Get or set camera position.


PARAMS
* `x` - Or vec2
* `y` - 

RETURNS
* `position` - Camera position


## cam_rot(angle, )
Get or set camera rotation. 


PARAMS
* `angle` - The angle to set or nil to get current rotation

RETURNS
* `rotation` - The camera rotation in degrees


## cam_zoom(zoom, )
Get or set the camera zoom. 


PARAMS
* `zoom` - The zoom to set or nil to get the current zoom.

RETURNS
* `The` - Camera zoom


---

# gravity
*File: `boom/info/gravity.lua`*




## get_gravity()
Get gravity


RETURNS
* `gravity` - The gravity in pixels per seconds


## set_gravity(gravity, )
Set gravity


PARAMS
* `gravity` - Gravity in pixels per seconds


---

# screen
*File: `boom/info/screen.lua`*




## width()
Get screen width


RETURNS
* `Width` - Of screen


## height()
Get screen height


RETURNS
* `Height` - Of screen


## center()
Get screen center position


RETURNS
* `Center` - Of screen (vec2)


---

# time
*File: `boom/info/time.lua`*




## dt()
Get the delta time


RETURNS
* `dt` - Delta time


## time()
Get time since start


RETURNS
* `time` - Time since start in seconds


---

# level
*File: `boom/level/level.lua`*




## add_level(map, options, )
Construct a level based on symbols


PARAMS
* `map` - List of strings presenting horizontal rows of tiles
* `options` - Level options (tile_width, tile_height, pos, tiles)

RETURNS
* `Game` - Object with tiles as children


---

# random
*File: `boom/math/random.lua`*




## rand(a, b, )
Get a random number. If called with no arguments the function returns a number between 0 and 1. If called with a single argument &#x27;a&#x27; a number between 0 and &#x27;a&#x27; is returned. If called with two arguments &#x27;a&#x27; and &#x27;b&#x27; a number between &#x27;a&#x27; and &#x27;b&#x27; is returned.


PARAMS
* `a` - 
* `b` - 

RETURNS
* `Random` - Number


## randi(a, b, )
Same as rand() but floored


PARAMS
* `a` - 
* `b` - 

RETURNS
* `Random` - Integer number


---

# tween
*File: `boom/math/tween.lua`*




## tween(from, from, to, to, duration, easing, set_value, )
Tween a value from one to another. The transition will happen over a certain duration using a specific easing function.


PARAMS
* `from` [`number`] - Start value
* `from` [`vec2`] - Start value
* `to` [`number`] - End value
* `to` [`vec2`] - End value
* `duration` [`number`] - Time in seconds to go from start to end value
* `easing` [`string`] - Which easing algorithm to use
* `set_value` [`function`] - Function to call when the value has changed

RETURNS
* `component` [`Tween`] - A tween object.


## Tween.on_end(fn, )
Register an event when finished 


PARAMS
* `fn` [`function`] - The function to call when the tween has finished


## Tween.finish()
Finish tween now. 



## Tween.cancel()
Cancel tween. 



---

# vec2
*File: `boom/math/vec2.lua`*

Vector type for a 2D point (backed by Defold vmath.vector3()) 


## vec2(x, y, )
Create a Vec2 


PARAMS
* `x` [`number`] - Horizontal position
* `y` [`number`] - Vertical position

RETURNS
* `v2` [`Vec2`] - The created vec2


## Vec2.UP [`Vec2`]
UP vector 



## Vec2.DOWN [`Vec2`]
DOWN vector 



## Vec2.LEFT [`Vec2`]
LEFT vector 



## Vec2.RIGHT [`Vec2`]
RIGHT vector 



---

# scene
*File: `boom/scene/scene.lua`*




## scene(id, fn, )
Create a scene


PARAMS
* `id` - Unique id of the scene
* `fn` - The scene code


## show(id, )
Show a scene


PARAMS
* `id` - Id of the scene to show


---

# timer
*File: `boom/timer/timer.lua`*




## wait(seconds, cb, )
Run a callback after a certain nummber of seconds


PARAMS
* `seconds` - Number of seconds to wait
* `cb` - Function to call

RETURNS
* `cancel` - Call to cancel the timer


## loop(seconds, cb, )
Run a callback repeatedly with a certain interval


PARAMS
* `seconds` - Interval between calls
* `cb` - Function to call

RETURNS
* `cancel` - Call to cancel the timer


---

