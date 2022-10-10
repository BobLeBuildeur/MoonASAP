require("../entity")

Test("components are added", function()
    local entity = Entity()

    local function componentFn(self) end

    entity:add_component(componentFn)

    Assert(entity._components[1], componentFn, "add function straight away")

    local componentTable = {
        init = function(self) self.ticked = true end,
        process = function(self) end
    }

    Assert(entity.ticked, nil, "does not have ticket yet")

    entity:add_component(componentTable)

    Assert(entity.ticked, true, "init function runs when it is added")
    Assert(entity._components[2], componentTable.process, "only process function gets addded")
end)

Test("get processed", function()
    local entity = Entity()
    local ticked = 0
    local function component() ticked = ticked + 1 end

    entity:add_component(component)
    entity:add_component(component)

    entity:process()

    Assert(ticked, 2, "Ticked once per component")
end)

Test("access entity", function()
    local entity = Entity()
    local function component(entity)
        entity.ticked = true
    end

    entity:add_component(component)

    Assert(entity.ticked, nil)

    entity:process()

    Assert(entity.ticked, true)
end)

Test("process gets delta", function()
    local entity = Entity()

    local last_delta = 0

    local function component(_, delta)
        last_delta = delta
    end

    entity:add_component(component)

    entity:process(100)

    Assert(last_delta, 100)

    entity:process(30)

    Assert(last_delta, 30)
end)