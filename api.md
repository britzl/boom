# Boom

Boom is a game framework built on top of Defold, heavily inspired by the Kaboom.js game framework.

* [boom](#boom)
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
* [collision](#collision)
* [key](#key)
* [mouse](#mouse)
* [update](#update)
* [gameobject](#gameobject)
* [camera](#camera)
* [gravity](#gravity)
* [screen](#screen)
* [time](#time)
* [level](#level)
* [random](#random)
* [tween](#tween)
* [scene](#scene)
* [timer](#timer)


# boom

## boom.boom(game)
Start a boom game Call this from your own game script

PARAMS
* game - Game loop function


---


# anchor

## anchor.anchor(anchor)
Anchor point for render.

PARAMS
* anchor [string] - Anchor (center, topleft, left, topright, right, bottomright, bottom, bottomleft)

RETURNS
* component [Anchor] - The anchor component.


---


# area

## area.area(options)
Create a collider area and enabled collision detection. This will create an area component which is used to describe an area which can collide with other area components.

PARAMS
* options [table] - Component options (width and height)

RETURNS
* area [AreaComp] - The area component


## AreaComp.get_collisions()
Get all collisions currently happening for this component. 

RETURNS
* collisions [table] - List of collisions


## AreaComp.check_collision(other_object)
Check collision between this component and another object. 

PARAMS
* other_object [GameObject] - The game object to check collisions with.

RETURNS
* collision [bool] - Return true if colliding with the other object
* data [table] - Collision data


## AreaComp.on_collide(cb)
Register event listener when this component is colliding. 

PARAMS
* cb [function] - Function to call when collision is detected


## AreaComp.on_click(cb)
Register event listener when this component is clicked. 

PARAMS
* cb [function] - Function to call when clicked


## AreaComp.has_point(point)
Check if a point is within the area of this component. 

PARAMS
* point - The point to check

RETURNS
* result [bool] - Will return true if point is within area


---


# body

## body.body(options)
Physical body that responds to gravity. Requires AreaComp and PosComp components on the game object. This also makes the object solid.

PARAMS
* options [table] - Component options (jump_force, is_static)

RETURNS
* component [BodyComp] - The body component


## BodyComp.jump(force)
Add upward force 

PARAMS
* force [number] - The upward force to apply


---


# color

## color.color(...)
Color of object

PARAMS
* ... - R,g,b components or color

RETURNS
* component [ColorComp] - The color component


---


# double_jump

## double_jump.double_jump(options)
Enables double jump. Requires &quot;body&quot; component

PARAMS
* options [table] - Component options

RETURNS
* component [DoubleJumpComp] - The double jump component


## DoubleJumpComp.double_jump(force)


PARAMS
* force [number] - The upward force to apply


---


# fadein

## fadein.fadein(time)
Fade object in

PARAMS
* time - 

RETURNS
* The - Component


---


# fixed

## fixed.fixed()
Make object unaffected by camera

RETURNS
* The - Component


---


# health

## health.health(hp)
Handles health related logic

PARAMS
* hp - Initial health

RETURNS
* The - Component


## health.on_heal(cb)
Register an event that runs when heal() is called

PARAMS
* cb - Function to call


## health.on_hurt(cb)
Register an event that runs when hurt() is called

PARAMS
* cb - Function to call


## health.on_death(cb)
Register an event that runs when health is 0 or less

PARAMS
* cb - Function to call


## health.heal(n)
Increase hp. Will trigger on_heal.

PARAMS
* n - Amount to increase


## health.hurt(n)
Decrease hp. Will trigger on_hurt

PARAMS
* n - Amount to decrease


---


# lifespan

## lifespan.lifespan(time)
Destroy the game obj after certain amount of time param options (fade)

PARAMS
* time - 


---


# move

## move.move(speed)
Move towards a direction infinitely, and destroys when it leaves game view

PARAMS
* speed - Speed of movement in pixels per second

RETURNS
* The - Component


---


# offscreen

## offscreen.offscreen(options)
Control the behavior of object when it goes out of view

PARAMS
* options - (distance, destroy)

RETURNS
* The - Component


---


# opacity

## opacity.opacity(opacity)
Opacity of object

PARAMS
* opacity - 0.0 to 1.0

RETURNS
* The - Component


---


# pos

## pos.pos(y)
Position an object

PARAMS
* y - 

RETURNS
* The - Component


---


# rotate

## rotate.rotate(angle)
Apply rotation to object

PARAMS
* angle - Angle in degrees

RETURNS
* The - Component


---


# scale

## scale.scale(y)
Apply a scale to the object

PARAMS
* y - 

RETURNS
* The - Component


---


# sprite

## sprite.sprite(options)
Render as a sprite

PARAMS
* options - Extra options (flip_x, flip_y, width, height)

RETURNS
* The - Component


## sprite.play(anim)
Play an animation

PARAMS
* anim - The animation to play


## sprite.stop()
Stop the current animation


---


# stay

## stay.stay()
Do not get destroyed on scene switch

RETURNS
* component - The created component


---


# text

## text.text(options)
A text component

PARAMS
* options - Text options (width, font, align)

RETURNS
* The - Component


---


# timer

## timer.timer(fn)
Run certain action after some time.

PARAMS
* fn - The function to call

RETURNS
* The - Component


---


# z

## z.z(z)
Determines the draw order for objects. Object will be drawn on top if z value is bigger.

PARAMS
* z - Z-value of the object.

RETURNS
* The - Component


---


# collision

## collision.on_collide(fn)
Register an event that runs when two game objects collide

PARAMS
* fn - Will receive (collision, cancel) as args

RETURNS
* Cancel - Event function


---


# key

## key.on_key_press(cb)
Register callback that runs when a certain key is pressed

PARAMS
* cb - The callback

RETURNS
* Cancel - Callback


## key.on_key_release(cb)
Register callback that runs when a certain key is released

PARAMS
* cb - The callback

RETURNS
* Cancel - Callback


## key.is_key_down(key_id)
Check if a certain key is down

PARAMS
* key_id - The key that must be down, or nil for any key

RETURNS
* True - If down


---


# mouse

## mouse.on_click(cb)
Set mouse click listener

PARAMS
* cb - Callback when mouse button is clicked

RETURNS
* Cancel - Listener function


## mouse.mouse_pos()
Get mouse position (screen coordinates)

RETURNS
* Mouse - Position (vec2)


---


# update

## update.on_update(fn)
Run a function every frame Register an event that runs every frame, optionally for all game objects with certain tag

PARAMS
* fn - Event function to call. Will receive object and cancel function


---


# gameobject

## gameobject.add(comps)
Add a game object with a set of components

PARAMS
* comps [table] - The components for the game object

RETURNS
* object [GameObject] - The created game object


## GameObject.add(comps)
Add a game object as a child of this game object

PARAMS
* comps [table] - The game object components

RETURNS
* object - The game object


## GameObject.destroy()
Destroy this game object


## GameObject.is(tag)
Check if there is a certain tag on this game object

PARAMS
* tag [string] - The tag to check

RETURNS
* result [bool] - Returns true if the tag exists on the game object


## GameObject.use(comp)
Add a component to this game object

PARAMS
* comp [table] - The component to use


## GameObject.unuse(tag)
Remove a component from this game object

PARAMS
* tag [string] - The component tag to remove


## GameObject.c(tag)
Get state for a specific component on this game object

PARAMS
* tag [string] - The component to get state for

RETURNS
* state [table] - The component state


## gameobject.destroy(object)
Destroy a game object and all of its components

PARAMS
* object [table] - The object to destroy


## gameobject.destroy_all(tag)
Destroy all objects with a certain tag

PARAMS
* tag [string] - The tag to destroy or nil to destroy all objects


## gameobject.object(id)
Get game object with specific id

PARAMS
* id [string] - 

RETURNS
* id - String The object or nil if it doesn&#x27;t exist


## gameobject.objects()
Get all game objects

RETURNS
* objects - Table All game objects


## gameobject.get(tag)
Get all game objects with the specified tag

PARAMS
* tag [string] - The tag to get objects for, nil to get all objects

RETURNS
* objects - Table List of objects


## gameobject.every(cb)
Run callback on every object with a certain tag.

PARAMS
* cb [function] - The callback to run


---


# camera

## camera.cam_pos(y)
Get or set camera position.

PARAMS
* y - 

RETURNS
* position - Camera position


## camera.cam_rot(angle)
Get or set camera rotation. 

PARAMS
* angle - The angle to set or nil to get current rotation

RETURNS
* rotation - The camera rotation in degrees


## camera.cam_zoom(zoom)
Get or set the camera zoom. 

PARAMS
* zoom - The zoom to set or nil to get the current zoom.

RETURNS
* The - Camera zoom


---


# gravity

## gravity.get_gravity()
Get gravity

RETURNS
* gravity - The gravity in pixels per seconds


## gravity.set_gravity(gravity)
Set gravity

PARAMS
* gravity - Gravity in pixels per seconds


---


# screen

## screen.width()
Get screen width

RETURNS
* Width - Of screen


## screen.height()
Get screen height

RETURNS
* Height - Of screen


## screen.center()
Get screen center position

RETURNS
* Center - Of screen (vec2)


---


# time

## time.dt()
Get the delta time

RETURNS
* dt - Delta time


## time.time()
Get time since start

RETURNS
* time - Time since start in seconds


---


# level

## level.add_level(options)
Construct a level based on symbols

PARAMS
* options - Level options (tile_width, tile_height, pos, tiles)

RETURNS
* Game - Object with tiles as children


---


# random

## random.rand(b)
Get a random number. If called with no arguments the function returns a number between 0 and 1. If called with a single argument &#x27;a&#x27; a number between 0 and &#x27;a&#x27; is returned. If called with two arguments &#x27;a&#x27; and &#x27;b&#x27; a number between &#x27;a&#x27; and &#x27;b&#x27; is returned.

PARAMS
* b - 

RETURNS
* Random - Number


## random.randi(b)
Same as rand() but floored

PARAMS
* b - 

RETURNS
* Random - Integer number


---


# tween

## tween.tween(set_value)
Tween a value from one to another over a certain duration using a specific easing function

PARAMS
* set_value - Function to call when the value has changed

RETURNS
* tween - A tween object


## tween.on_end(fn)
Register an event when finished

PARAMS
* fn - The function to call when the tween has finished


## tween.finish()
Finish tween now


## tween.cancel()
Cancel tween


---


# scene

## scene.scene(fn)
Create a scene

PARAMS
* fn - The scene code


## scene.show(id)
Show a scene

PARAMS
* id - Id of the scene to show


---


# timer

## timer.wait(cb)
Run a callback after a certain nummber of seconds

PARAMS
* cb - Function to call

RETURNS
* cancel - Call to cancel the timer


## timer.loop(cb)
Run a callback repeatedly with a certain interval

PARAMS
* cb - Function to call

RETURNS
* cancel - Call to cancel the timer


---

