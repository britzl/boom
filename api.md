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
* scene
  * [scene](#scene)
* timer
  * [timer](#timer)

# boom
Boom is a game framework built on top of Defold. It is heavily inspired by the Kaboom.js game framework.


## boom.boom(game)
Start a boom game Call this from your own game script

PARAMS
* `game` - Game loop function


---

# anchor
Anchor component. Use this component to offset any rendered component such as a SpriteComp from the center of the game object.


## anchor.anchor(anchor)
Anchor point for render.

PARAMS
* `anchor` [`string`] - Anchor (center, topleft, left, topright, right, bottomright, bottom, bottomleft)

RETURNS
* `component` [`Anchor`] - The anchor component.


---

# area
Area component. Use this component to define a collider area and bounds for a game object.


## area.area(options)
Create a collider area and enabled collision detection. This will create an area component which is used to describe an area which can collide with other area components.

PARAMS
* `options` [`table`] - Component options (width and height)

RETURNS
* `area` [`AreaComp`] - The area component


## AreaComp.get_collisions()
Get all collisions currently happening for this component. 

RETURNS
* `collisions` [`table`] - List of collisions


## AreaComp.check_collision(other_object)
Check collision between this component and another object. 

PARAMS
* `other_object` [`GameObject`] - The game object to check collisions with.

RETURNS
* `collision` [`bool`] - Return true if colliding with the other object
* `data` [`table`] - Collision data


## AreaComp.on_collide(tagcb)
Register event listener when this component is colliding. 

PARAMS
* `tag` [`string`] - Optional tag which colliding object must have, nil for all collisions
* `cb` [`function`] - Function to call when collision is detected


## AreaComp.on_click(cb)
Register event listener when this component is clicked. 

PARAMS
* `cb` [`function`] - Function to call when clicked


## AreaComp.has_point(point)
Check if a point is within the area of this component. 

PARAMS
* `point` - The point to check

RETURNS
* `result` [`bool`] - Will return true if point is within area


---

# body



## body.body(options)
Physical body that responds to gravity. Requires AreaComp and PosComp components on the game object. This also makes the object solid.

PARAMS
* `options` [`table`] - Component options (jump_force, is_static)

RETURNS
* `component` [`BodyComp`] - The body component


## BodyComp.jump(force)
Add upward force 

PARAMS
* `force` [`number`] - The upward force to apply


---

# color
Component to control the color of the game object 


## color.color(...)
Create a color component 

PARAMS
* `...` - R,g,b components or color

RETURNS
* `component` [`ColorComp`] - The color component


---

# double_jump



## double_jump.double_jump(options)
Enables double jump. Requires &quot;body&quot; component

PARAMS
* `options` [`table`] - Component options

RETURNS
* `component` [`DoubleJumpComp`] - The double jump component


## DoubleJumpComp.double_jump(force)


PARAMS
* `force` [`number`] - The upward force to apply


---

# fadein
Fade in game object visual components such as sprites. 


## fadein.fadein(time)
Fade object in. 

PARAMS
* `time` [`number`] - In seconds

RETURNS
* `component` [`FadeInComp`] - The fade in component.


---

# fixed
Make object unaffected by camera. 


## fixed.fixed()
Create a fixed component 

RETURNS
* `component` [`Fixed`] - The component


---

# health
Handles health related logic. 


## health.health(hp)
Create a health component 

PARAMS
* `hp` [`number`] - Initial health

RETURNS
* `component` [`HealthComp`] - The health component


## HealthComp.on_heal(cb)
Register an event that runs when heal() is called. 

PARAMS
* `cb` [`function`] - Function to call


## HealthComp.on_hurt(cb)
Register an event that runs when hurt() is called. 

PARAMS
* `cb` [`function`] - Function to call


## HealthComp.on_death(cb)
Register an event that runs when health is 0 or less. 

PARAMS
* `cb` [`function`] - Function to call


## HealthComp.heal(n)
Increase hp. Will trigger on_heal.

PARAMS
* `n` [`number`] - Amount to increase


## HealthComp.hurt(n)
Decrease hp. Will trigger on_hurt

PARAMS
* `n` [`number`] - Amount to decrease


---

# lifespan
Destroy the game object after certain amount of time. Use this component when you need a game object to be destroyed after a period of time.


## lifespan.lifespan(timeoptions)
Create a Lifespan component. 

PARAMS
* `time` [`number`] - In seconds
* `options` [`table`] - (fade)

RETURNS
* `component` [`Lifespan`] - The created component


---

# move
Move towards a direction infinitely, and destroys when it leaves the game view. 


## move.move(directionspeed)
Create a move component. 

PARAMS
* `direction` [`vec2`] - Direction of movement.
* `speed` [`number`] - Speed of movement in pixels per second.

RETURNS
* `component` [`Move`] - The created component.


---

# offscreen
Control the behavior of a game object when it goes out of view 


## offscreen.offscreen(options)
Create an offscreen component. 

PARAMS
* `options` [`table`] - (distance, destroy)

RETURNS
* `component` [`Offscreen`] - The created component


## Offscreen.on_exit_screen(cb)
Register a callback that runs when the object goes out of view 

PARAMS
* `cb` [`function`] - Function to call when the object goes out of view


## Offscreen.on_enter_screen(cb)
Register a callback that runs when the object enters view 

PARAMS
* `cb` [`function`] - Function to call when the object enters view


---

# opacity
Component to control the opacity of a game object. 


## opacity.opacity(opacity)
Create an opacity component. 

PARAMS
* `opacity` [`number`] - The opacity from 0.0 to 1.0

RETURNS
* `component` [`Opacity`] - The created component


## Opacity.opacity
The opacity of the component instance. 


---

# pos
Position of a game object. 
```
-- this game object will draw a &quot;bean&quot; sprite at (100, 200)
add({
   pos(100, 200),
   sprite(&quot;bean&quot;)
})
```

## pos.pos(xy)
Create a position component. 

PARAMS
* `x` [`number`] - 
* `y` [`number`] - 

RETURNS
* `component` [`Pos`] - The created component


## Pos.move(xy)
Move a number of pixels per second. 

PARAMS
* `x` [`number`] - 
* `y` [`number`] - 


---

# rotate



## rotate.rotate(angle)
Apply rotation to object

PARAMS
* `angle` - Angle in degrees

RETURNS
* `The` - Component


---

# scale



## scale.scale(xy)
Apply a scale to the object

PARAMS
* `x` - 
* `y` - 

RETURNS
* `The` - Component


---

# sprite



## sprite.sprite(animoptions)
Render as a sprite

PARAMS
* `anim` - Which animation or image to use
* `options` - Extra options (flip_x, flip_y, width, height)

RETURNS
* `The` - Component


## sprite.play(anim)
Play an animation

PARAMS
* `anim` - The animation to play


## sprite.stop()
Stop the current animation


---

# stay



## stay.stay()
Do not get destroyed on scene switch

RETURNS
* `component` - The created component


---

# text



## text.text(textoptions)
A text component

PARAMS
* `text` - The text to show
* `options` - Text options (width, font, align)

RETURNS
* `The` - Component


---

# timer



## timer.timer(nfn)
Run certain action after some time.

PARAMS
* `n` - Number of seconds to wait
* `fn` - The function to call

RETURNS
* `The` - Component


---

# z



## z.z(z)
Determines the draw order for objects. Object will be drawn on top if z value is bigger.

PARAMS
* `z` - Z-value of the object.

RETURNS
* `The` - Component


---

# collision



## collision.on_collide(tag1tag2fn)
Register an event that runs when two game objects collide

PARAMS
* `tag1` - Tag which the first game object must have
* `tag2` - Optional tag which the second game object must have
* `fn` - Will receive (collision, cancel) as args

RETURNS
* `Cancel` - Event function


---

# key



## key.on_key_press(key_idcb)
Register callback that runs when a certain key is pressed

PARAMS
* `key_id` - The key that must be pressed or nil for any key
* `cb` - The callback

RETURNS
* `Cancel` - Callback


## key.on_key_release(key_idcb)
Register callback that runs when a certain key is released

PARAMS
* `key_id` - The key that must be released or nil for any key
* `cb` - The callback

RETURNS
* `Cancel` - Callback


## key.is_key_down(key_id)
Check if a certain key is down

PARAMS
* `key_id` - The key that must be down, or nil for any key

RETURNS
* `True` - If down


---

# mouse



## mouse.on_click(tagcb)
Set mouse click listener

PARAMS
* `tag` - Optional click on object with tag filter
* `cb` - Callback when mouse button is clicked

RETURNS
* `Cancel` - Listener function


## mouse.mouse_pos()
Get mouse position (screen coordinates)

RETURNS
* `Mouse` - Position (vec2)


---

# update



## update.on_update(tagfn)
Run a function every frame Register an event that runs every frame, optionally for all game objects with certain tag

PARAMS
* `tag` - [optional] run event for all objects matching tag
* `fn` - Event function to call. Will receive object and cancel function


---

# gameobject



## gameobject.add(comps)
Add a game object with a set of components

PARAMS
* `comps` [`table`] - The components for the game object

RETURNS
* `object` [`GameObject`] - The created game object


## GameObject.add(comps)
Add a game object as a child of this game object

PARAMS
* `comps` [`table`] - The game object components

RETURNS
* `object` - The game object


## GameObject.destroy()
Destroy this game object


## GameObject.is(tag)
Check if there is a certain tag on this game object

PARAMS
* `tag` [`string`] - The tag to check

RETURNS
* `result` [`bool`] - Returns true if the tag exists on the game object


## GameObject.use(comp)
Add a component to this game object

PARAMS
* `comp` [`table`] - The component to use


## GameObject.unuse(tag)
Remove a component from this game object

PARAMS
* `tag` [`string`] - The component tag to remove


## GameObject.c(tag)
Get state for a specific component on this game object

PARAMS
* `tag` [`string`] - The component to get state for

RETURNS
* `state` [`table`] - The component state


## gameobject.destroy(object)
Destroy a game object and all of its components

PARAMS
* `object` [`table`] - The object to destroy


## gameobject.destroy_all(tag)
Destroy all objects with a certain tag

PARAMS
* `tag` [`string`] - The tag to destroy or nil to destroy all objects


## gameobject.object(id)
Get game object with specific id

PARAMS
* `id` [`string`] - 

RETURNS
* `id` - String The object or nil if it doesn&#x27;t exist


## gameobject.objects()
Get all game objects

RETURNS
* `objects` - Table All game objects


## gameobject.get(tag)
Get all game objects with the specified tag

PARAMS
* `tag` [`string`] - The tag to get objects for, nil to get all objects

RETURNS
* `objects` - Table List of objects


## gameobject.every(tagcb)
Run callback on every object with a certain tag.

PARAMS
* `tag` [`string`] - The tag that must exist on the object
* `cb` [`function`] - The callback to run


---

# camera



## camera.cam_pos(xy)
Get or set camera position.

PARAMS
* `x` - Or vec2
* `y` - 

RETURNS
* `position` - Camera position


## camera.cam_rot(angle)
Get or set camera rotation. 

PARAMS
* `angle` - The angle to set or nil to get current rotation

RETURNS
* `rotation` - The camera rotation in degrees


## camera.cam_zoom(zoom)
Get or set the camera zoom. 

PARAMS
* `zoom` - The zoom to set or nil to get the current zoom.

RETURNS
* `The` - Camera zoom


---

# gravity



## gravity.get_gravity()
Get gravity

RETURNS
* `gravity` - The gravity in pixels per seconds


## gravity.set_gravity(gravity)
Set gravity

PARAMS
* `gravity` - Gravity in pixels per seconds


---

# screen



## screen.width()
Get screen width

RETURNS
* `Width` - Of screen


## screen.height()
Get screen height

RETURNS
* `Height` - Of screen


## screen.center()
Get screen center position

RETURNS
* `Center` - Of screen (vec2)


---

# time



## time.dt()
Get the delta time

RETURNS
* `dt` - Delta time


## time.time()
Get time since start

RETURNS
* `time` - Time since start in seconds


---

# level



## level.add_level(mapoptions)
Construct a level based on symbols

PARAMS
* `map` - List of strings presenting horizontal rows of tiles
* `options` - Level options (tile_width, tile_height, pos, tiles)

RETURNS
* `Game` - Object with tiles as children


---

# random



## random.rand(ab)
Get a random number. If called with no arguments the function returns a number between 0 and 1. If called with a single argument &#x27;a&#x27; a number between 0 and &#x27;a&#x27; is returned. If called with two arguments &#x27;a&#x27; and &#x27;b&#x27; a number between &#x27;a&#x27; and &#x27;b&#x27; is returned.

PARAMS
* `a` - 
* `b` - 

RETURNS
* `Random` - Number


## random.randi(ab)
Same as rand() but floored

PARAMS
* `a` - 
* `b` - 

RETURNS
* `Random` - Integer number


---

# tween



## tween.tween(fromtodurationeasingset_value)
Tween a value from one to another over a certain duration using a specific easing function

PARAMS
* `from` - Start value (number or vec2)
* `to` - End value (same as from)
* `duration` - Time in seconds to go from start to end value
* `easing` - Which easing algorithm to use
* `set_value` - Function to call when the value has changed

RETURNS
* `tween` - A tween object


## tween.on_end(fn)
Register an event when finished

PARAMS
* `fn` - The function to call when the tween has finished


## tween.finish()
Finish tween now


## tween.cancel()
Cancel tween


---

# scene



## scene.scene(idfn)
Create a scene

PARAMS
* `id` - Unique id of the scene
* `fn` - The scene code


## scene.show(id)
Show a scene

PARAMS
* `id` - Id of the scene to show


---

# timer



## timer.wait(secondscb)
Run a callback after a certain nummber of seconds

PARAMS
* `seconds` - Number of seconds to wait
* `cb` - Function to call

RETURNS
* `cancel` - Call to cancel the timer


## timer.loop(secondscb)
Run a callback repeatedly with a certain interval

PARAMS
* `seconds` - Interval between calls
* `cb` - Function to call

RETURNS
* `cancel` - Call to cancel the timer


---

