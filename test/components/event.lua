require("../entity")
local event = require("../components/event")

Test("Adds on and emit functions", function()
    local entity = Entity()
    entity:add_component(event)

    Assert(type(entity.on), "function", "on function")
    Assert(type(entity.emit), "function", "emit function")
end)

Test("Allows setting up and calling envents on and object", function() 
    local ticked = ""
    
    local p = {
        fn = function(_self, value)
            ticked = value
        end
    }

    local entity = Entity()
    entity:add_component(event)

    entity:on("tick", p, "fn")
    entity:emit("tick", "test")

    Assert(ticked, "test", "calls object")
end)

Test("Allows multiple of the same event", function()
    local ta = false
    local tb = false
    local p = {
        fa = function() ta = true end,
        fb = function() tb = true end
    }

    local entity = Entity()
    entity:add_component(event)

    entity:on("tick", p, "fa")
    entity:on("tick", p, "fb")

    entity:emit("tick")

    Assert(ta, true, "tick calls fa")
    Assert(tb, true, "simultaneously, tick calls fb")
end)

Test("Allows multiple different events", function()
    local ta = false
    local tb = false
    local p = {
        fa = function() ta = true end,
        fb = function() tb = true end
    }

    local entity = Entity()
    entity:add_component(event)

    entity:on("tick", p, "fa")
    entity:on("tock", p, "fb")

    entity:emit("tick")

    Assert(ta, true, "tick calls fa")
    Assert(tb, false, "does not call fb yet")

    entity:emit("tock")

    Assert(tb, true, "tock calls fb")
end)

Test("Removes all events", function()
    local entity = Entity()
    entity:add_component(event)

    local ta = false
    local tb = false
    local p = {
        fa = function() ta = true end,
        fb = function() tb = true end
    }

    entity:on("tick", p, "fa")
    entity:on("tick", p, "fb")

    entity:off("tick")

    entity:emit("tick")

    Assert(ta, false, "does not change ta")
    Assert(tb, false, "does not change tb")
end)

Test("Removes a single event", function()
    local entity = Entity()
    entity:add_component(event)

    local ta = false
    local tb = false
    local p = {
        fa = function() ta = true end,
        fb = function() tb = true end
    }

    entity:on("tick", p, "fa")
    entity:on("tick", p, "fb")

    entity:off("tick", p, "fb")

    entity:emit("tick")

    Assert(ta, true, "changes ta")
    Assert(tb, false, "does not change tb")
end)

Test("Does not break when event is not found", function()
    local entity = Entity()
    entity:add_component(event)

    local ta = false
    local p = {
        fa = function() ta = true end
    }

    entity:on("tick", p, "fa")

    entity:off("tock")
    entity:off("tick", {}, "none")
    entity:off("tick", p, "none")

    -- it no errors, we're good
end)