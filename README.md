## Moon ASAP

**Your lua game ASAP - as small as possible!**

- Small footprint
- Easily portable
- Extremely Modular

A minimal and flexible lua-based Entity-Component System

Great match for Love2D, Pico8, LOVR, TIC80, you name it!

## Getting started

```lua
require("entity")

local player = Entity()

local health = {
    init = function(self)
        self._health = 30
        self.is_alive = true
    
        self.hit = function(self, amount)
            print("Health: " .. self._health .. "/30")

            self._health = self._health - amount

            if self._heath <= 0 then
                self._alive = false
            end
        end
    end
}

player:add_component(health)

print(player.is_alive) -- true

player:hit(20) -- Health: 10/30
player:hit(20) -- Health: -10/30

print(player.is_alive) -- false

```
### How it works

**Everything is a component!**

At its core, there is a single class: Entity.

It allows you to add components which modify its behavior.

Because of how lua manages memory and data structures, this simple implementation
makes it so you can create very complex systems and behaviors.


### Examples

TIC80 and Love2D examples are available in the `examples` folder:

- [Begginer tutorial with TIC80](/examples/tic80/tic80.md)
- [Advanced tutorial with Love2d](/examples/love2d/love2d.md)

### Testing

To run tests:

`lua test.lua`

That easy.

## Features and Roadmap

### 😎 Delivered

**Entity Component System**

Define and reuse behaviors in components.

**Super minimal Inheritance system**

The smallest implementation that makes sense

**Scene tree**

Build up scenes in branches.

Update everything it with a single call.

**2D Vector math**

A library that helps with common vector functions.

### 🏗️ Now

_What we are working on now_

**Event system**

Great way to decouple your code so it does not break.

**Cookbook**

Reference and patterns to help you get started.

### ⏳ Next

_Things we want to do, eventually._

**Vectors Class**

A Vector2D class in addition to the functional library.

**Graphics Server abstraction**

Simple abstraction to handle render calls separate from update loop.

**Physics Server abstraction** 

A framework do add your own physics.

**State Machine**

Minimal implementation, hack to make game managers, AI... whatever you want!

### 🌠 Later

_Some cool ideas we are considering._

**Simple Physics Server**

AABB and circle collisions; Nothing fancy, but gets the job done.

Support for Rigid and Kinematic bodies.

**Physics World**

Hash grid physics world, to support more entities.

Maybe even open worlds...?

**Serialization**

Serializable human readable format for scene description.
