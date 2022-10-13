
local tree = require("../components/tree")

Test("Adds child", function()
    local trunk = Entity()
    trunk:add_component(tree)

    local leaf = Entity()
    leaf:add_component(tree)

    trunk:add_child(leaf)

    Assert(#trunk._children, 1, "child added")
    Assert(trunk._children[1], leaf, "correct child")
end)

Test("Removes child", function()
    local trunk = Entity()
    trunk:add_component(tree)

    local leaf = Entity()
    leaf:add_component(tree)

    trunk:add_child(leaf)

    Assert(#trunk._children, 1, "child_added")

    local removed = trunk:remove_child(leaf)

    Assert(#trunk._children, 0, "child removed")
    Assert(removed, leaf, "removed correct child")
end)

Test("Returns nil if no child to be removed", function ()
    local trunk = Entity()
    trunk:add_component(tree)
    local leaf = Entity()

    local removed = trunk:remove_child(leaf)

    Assert(removed, nil, "nil, nothing to remove")
end)

Test("Walk with function", function()
    local named = Class(Entity)
    named._init = function(self, name)
        Entity._init(self)

        self.name = name

        self:add_component(tree)
    end

    local trunk = named("t")
    local branch1 = named("b1")
    local leaf = named("l")
    local branch2 = named("b2")

    local visits = ""

    branch1:add_child(leaf)
    trunk:add_child(branch1)
    trunk:add_child(branch2)

    trunk:walk(function(self)
        visits = visits .. self.name
    end)

    Assert(visits, "tb1lb2", "walks visitng all nodes")
end)


Test("Walk with reference (process children)", function()
    local Node = Class(Entity)
    Node._init = function(self)
        Entity._init(self)

        self:add_component(tree)
    end

    local parent = Node()
    local childA = Node()
    local childB = Node()
    local childAA = Node()

    local ticks = {}

    local function componentFactory(name)
        return function()
            table.insert(ticks, "Hello from " .. name)
        end
    end

    childA:add_component(componentFactory("childA"))
    childB:add_component(componentFactory("childB"))
    childAA:add_component(componentFactory("childAA"))

    childA:add_child(childAA)
    parent:add_child(childA)
    parent:add_child(childB)

    parent:walk("process")

    Assert(ticks[1], "Hello from childA")
    Assert(ticks[2], "Hello from childAA")
    Assert(ticks[3], "Hello from childB")
end)

Test("Does not fail when walking with a non-existent reference", function()
    local Node = Class(Entity)
    Node._init = function(self)
        Entity._init(self)
        self:add_component(tree)
    end

    local entity = Node()

    entity:walk("nonexistent")

    -- If no errors are thrown, we golden
end)