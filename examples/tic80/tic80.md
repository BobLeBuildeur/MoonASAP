
# Boxer Game

Silly little game where you punch a bag.

## Before you begin

This code runs in TIC80, an open source fantasy console. A `cart.tic` is available along with this code.

`Class` and `Entity` are required to be imported. You can do this by
simply copying and pasting their respective codes into the project 
(as we have done in `cart.tic`)

## The code

```lua

-- This is a silly little game where you are a boxer and you punch
-- a bag until its out of health. Thrilling!

-- It serves to demonstrate how entities and components work using the
-- TIC80 fantasy console.

-- What we will do:
--   * Define a few components that will get used (and reused) in game
--   * Create a boxer and a punching bag

-- Lets get started, defining our components!!!

-- The health component does two things:
-- 1. It will setup the initial health and a function that takes it away
-- 2. It draws a health bar when processed
HealthComponent = {
    init = function(self)
        self._health = 30

        self.hit = function(self, amount)
            self._health = self._health - amount

            if self._health < 0 then
                State = "finished"
            end
        end
    end,

    process = function(self)
        rect(self.x - 3, self.y - 3, 30, 2, 3)
        rect(self.x - 3, self.y - 3, self._health, 2, 2)
    end
}


-- The punch component is a factory pattern,
-- this means it is a function that returns the component.
-- This allows us to pass parameters to the component.
-- In this case we will get a target (Entity) and an
-- user action (button) that triggers the punch 
function PunchComponent(target, action) 
    return {
        init = function(self)
            self._time_left_in_pose = 3
            self._original_spr = self._spr
        end,
        process = function(self)
            if btnp(action) then
                self._spr = self._original_spr + 64
                self._time_left_in_pose = 3

                target:hit(10)
            end

            self._time_left_in_pose = self._time_left_in_pose - 1

            if self._time_left_in_pose <= 0 then
                self._spr = self._original_spr
            end
        end
    }
end

-- The draw component is very verbose... 
-- but very straightforward; It draws
-- 4x4 sprites from and idex on the top left
function DrawComponent(self)
    spr(self._spr,      self.x,      self.y)
    spr(self._spr + 1,  self.x + 8,  self.y)
    spr(self._spr + 2,  self.x + 16, self.y)
    spr(self._spr + 3,  self.x + 24, self.y)
    spr(self._spr + 16, self.x,      self.y + 8)
    spr(self._spr + 17, self.x + 8,  self.y + 8)
    spr(self._spr + 18, self.x + 16, self.y + 8)
    spr(self._spr + 19, self.x + 24, self.y + 8)
    spr(self._spr + 32, self.x,      self.y + 16)
    spr(self._spr + 33, self.x + 8,  self.y + 16)
    spr(self._spr + 34, self.x + 16, self.y + 16)
    spr(self._spr + 35, self.x + 24, self.y + 16)
    spr(self._spr + 48, self.x,      self.y + 24)
    spr(self._spr + 49, self.x + 8,  self.y + 24)
    spr(self._spr + 50, self.x + 16, self.y + 24)
    spr(self._spr + 51, self.x + 24, self.y + 24)
end

-- Now, lets get this game going!

-- The first thing we need is to keep track about where we are
-- in the game (its state)
State = "setup"


-- TIC80 only has a single function for its loop
-- which does all the processing and rendering
function TIC()
    -- Every frame we clear the screen
    cls()

    -- And depending on our state, we will do different things...
    
    -- Setting up the game, we create the entities
    if State == "setup" then
        -- Create the punch bag
        -- it has a sprite index and position
        PunchBag = Entity()
        PunchBag._spr = 5
        PunchBag.x = 110
        PunchBag.y = 20

        -- Next, we'll add its components.
        -- It will be drawn and has health
        PunchBag:add_component(DrawComponent)
        PunchBag:add_component(HealthComponent)

        -- We also need our boxer
        -- Much like the punching bag it has a 
        -- sprite index and the draw component.
        -- Unlike the former, it gets the punch component
        -- which gets initialized with a reference to the
        -- punch bag and the action 6 (button A)
        Boxer = Entity()
        Boxer._spr = 1
        Boxer.x = 80
        Boxer.y = 20
        Boxer:add_component(DrawComponent)
        Boxer:add_component(PunchComponent(PunchBag, 6))

        -- The last thing to do is start the game proper
        State = "playing"
    else if State == "playing" then
        -- Playing the game, we process the entities
        print("Punch that bag!") -- text indicating what to do

        -- Process both entities
        -- All components will be processed
        Boxer:process()
        PunchBag:process()
    else
        -- any other state will fall here in the end game
        -- which just gives some feedback and allows the game to restart
        print("You punched that bag real good!")

        if btnp(7) then
            State = "setup"
        end
    end
end
```