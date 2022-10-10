local vector = require("../util/vector") -- require('util/vector')
require("../class") -- require('util/class')
require("../entity") -- require('entity')
local tree = require("../components/tree") -- require('components/tree')


-- This is a game where you run away from Zombies
-- towards your mouse position

-- It demonstrates inheritance and the Scene Tree
-- pattern using love2D.

-- The Scene tree is a hierarchy of nodes.
-- Each node is an entity and has 0..1 parents
-- And 0..N children

-- The advantage of using this pattern is that we delegate
-- responsibilities such as rendering and updating to the
-- tree itself, rather than having to manage individual components.
-- This will be very familiar if you've ever used a fully featured
-- game engine like Unity, Unreal, Godot, etc.

-- What we will do:
--   * Create an actor class that can be drawn and move in the world
--   * Create actor and player classes that extend the actor and add
--     controllers (player control and ai)
--   * Have a little fun with the player's hairdo

-- To start, we some parameters before
-- we use CamelCase names for global properties
-- and snake_case for local as convention
Width = love.graphics.getWidth()
Height = love.graphics.getHeight()
ZombieSpeed = 30

-- use a random seed to shuffle things around
math.randomseed(os.time())

-- Lets define a few compnents
-- we'll use a table to namespace them, making it easier
Components = {

    -- Our first compnent moves entities in the game world
    -- it is a table with two keys: init and process.
    -- Init gets applied when the comopnent is added to the entity.
    -- Process gets added to a list of components
    -- and runs along with the other compnoents when the
    -- `process` function is called on the entity
    motor = {
        init = function(self)
            -- Lets set a direction vector and speed
            -- these are private, as indicated by the `_`
            self._dx = 0
            self._dy = 0
            self._speed = 40

            -- Next, we create public function to set direction
            -- which normalizes the input to make sure speed
            -- will always be consistent
            self.set_direction = function(self, dx, dy)
                self._dx, self._dy = vector.normalize(dx, dy)
            end
        end,

        -- This is the process function applies the direction
        -- and speed, taking into consideration the frame time
        process = function(self, delta)
            self.x = self.x + self._dx * self._speed * delta
            self.y = self.y + self._dy * self._speed * delta
        end
    },

    -- The character controller is a simple functional component
    -- it will set the direction of the caracter towards the mouse
    character_controller = function(self)
        if love.mouse.isDown(1) then
            local mx, my = love.mouse.getPosition()
            self:set_direction(mx - self.x, my - self.y)
        else
            self._dx = 0
            self._dy = 0
        end
    end,

    -- For the drawing routine, we'll use a factory pattern
    -- this allows us to pass arguments to the component when
    -- creating it. in this case, we simply use the component
    -- initialization to set a draw method on the entity
    sprite = function(character)
        return {
            init = function(self)
                -- In the get_global_position function we will
                -- walk up the scene tree adding up the positions
                -- of the entities. This allows us to place children
                -- in relative position to their parents
                -- NOTE: this is an example, and very much not optimized!
                self.get_global_position = function(self)
                    local x, y = self.x, self.y
                    if self._parent and self._parent.get_global_position then
                        local px, py = self._parent:get_global_position()
                        x = x + px
                        y = y + py
                    end
                    return x, y
                end


                -- The draw function uses the global position for drawing
                self.draw = function(self)
                    local x, y = self:get_global_position()
                    love.graphics.print(character, x, y)
                end
            end
        }
    end,

    -- Our ai is also a factory, but returns a simple function
    ai_controller = {
        -- The init function creates a `set_target` function
        -- that does exactly that
        init = function(self)
            self.set_target = function(self, target)
                self._target = target
            end
        end,

        -- And in our process, we move towards the target. Easy
        process = function(self)
            self:set_direction(self._target.x - self.x, self._target.y - self.y)
        end
    },

    -- This is a silly component that bobs an actor up and down
    -- if the player is moving. We'll use it for the hairdo
    bobber = {
        init = function(self)
            self._time = 0
            self._original_y = self.y
        end,

        process = function(self, delta)
            if vector.len(self._parent._dx, self._parent._dy) > 0 then
                self._time = self._time + delta * 3

                self.y = self._original_y - math.cos(self._time * 6)
            else
                self.y = self._original_y
                self._time = 0
            end
        end
    }

}

-- Now, to setup the game, we start by creating
-- a root node to keep our entities
Game = Entity()
Game:add_component(tree)

-- We setup an actor class that will have
-- shared logic between Zombie and Player
-- it's constructor takes an X and Y position,
-- and the sprite to draw on screen
Actor = Class(Entity)
function Actor._init(self, sprite, x, y)
    -- Call super constructor
    Entity._init(self)

    -- Set a starting position
    self.x = x
    self.y = y

    -- Add the tree component, to make sure it is traversable
    self:add_component(tree)

    -- Add components: sprite, motor and controller.
    -- since sprite is a factory, we pass what we
    -- want to draw as an argument
    self:add_component(Components.sprite(sprite))
    self:add_component(Components.motor)
end

-- Next, we setup a Zombie class that extends the actor
Zombie = Class(Actor)
function Zombie._init(self)
    -- call constructor, with sprite and random position
    Actor._init(
        self,
        "!",
        math.random(Width),
        math.random(Height)
    )

    -- we'll also add the Ai controller
    -- motor and
    self:add_component(Components.ai_controller)

    -- finally, we'll make the zombies a bit slower
    self._speed = ZombieSpeed
end

-- with everything bootstrapped, we setup the game
function love.load()
    -- we'll create a player, from the actor class]
    -- setting the sprite as appropriate and
    -- setting the position to the middle of the screen
    local player = Actor(
        "O",
        Width / 2,
        Height / 2
    )

    -- Like the zombie, we need to add the controller
    player:add_component(Components.character_controller)

    -- Lets give the player a hairdo (for the memes),
    -- this time its position will be relative to the player,
    -- not the world
    local hairdo = Actor("~", 1, -6)
    hairdo:add_component(Components.bobber)
    player:add_child(hairdo)

    -- lets add the player to the game
    Game:add_child(player)

    -- lets generate a bunch of zombies,
    -- set the player as a target and add them to the game
    for _ = 1, 10 do
        local zombie = Zombie()
        zombie:set_target(player)
        Game:add_child(zombie)
    end

end

-- for the game logic update, we'll proces all of
-- the components in game and its children
-- by using the walk function from node
-- every component that is registered will get the arguments
-- we pass, in this case the delta time
function love.update(delta)
    Game:walk("process", delta)
end

-- we do the same for draw, but there is
-- no delta time in this case
function love.draw()
    Game:walk("draw")
end
