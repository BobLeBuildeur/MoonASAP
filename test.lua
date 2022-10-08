require("util/text")
require("util/vector")
require("util/class")
require("entity")
local tree = require("components/tree")

Data = {
    errors = 0,
    categories = 0,
    tests = 0,
    assertions = 0,
}


function Category(case)
    print(Color.yellow(case))
    Data.categories = Data.categories + 1
end

function Assert(value, eq, message)
    Data.assertions = Data.assertions + 1
    assert(value == eq,
        Color.red(
            (message or "") ..
            string.format(". [expected %s (%s) to be %s (%s)]", tostring(eq), type(eq), tostring(value), type(value)))
    )
    print("    " .. (message and message .. " " or "") .. "asserted " .. tostring(eq))
end

function AssertNot(value, neq, message)
    Data.assertions = Data.assertions + 1
    assert(value ~= neq,
        Color.red(
            (message or "") ..
            string.format(". [expected %s (%s) not to be %s (%s)]", tostring(eq), type(eq), tostring(value), type(value)))
    )
    print("    " .. (message and message .. " " or "") .. "asserted different value to " .. tostring(eq))

end

function Test(case, fn)
    print("  " .. Color.yellow(case))
    Data.tests = Data.tests + 1
    local status, err = pcall(fn)
    if not status then
        print("    [!] " .. Color.red(err))
        Data.errors = Data.errors + 1
    else
        print("    " .. Color.green("All good!"))
    end
end

-----------------------------------------------------
--               TESTS START HERE                  --
-----------------------------------------------------


Category("Vector")

Test("Length", function()
    local value = math.sqrt(5)
    Assert(Vector.len(1, 2), value)
    Assert(Vector.len(-1, 2), value)
    Assert(Vector.len(1, -2), value)
end)

Test("Normalization", function()
    local x, y = Vector.normalize(3, 3)
    local l = tostring(1 / math.sqrt(2))
    Assert(tostring(x), l, "same length")
    Assert(tostring(y), l, "same length")

    local x, y = Vector.normalize(3, 2)
    Assert(tostring(x), tostring(0.83205029433784), "different lengths")
    Assert(tostring(y), tostring(0.55470019622523), "different lengths")
end)

Test("Dot product", function()
    Assert(Vector.dot(2, 3, 2, 0), 4)
    Assert(Vector.dot(-1, 2, 0, -3), -6)
end)

Test("Rotate", function()
    local x, y = Vector.rotate(1, 0, math.pi)

    -- fix floating point  error
    y = math.floor(y * 10000) / 10000

    Assert(x, -1)
    Assert(y, 0)
end)

Category("Inheritance")

Test("Extends", function()
    local p = { inherited = true }
    local o = Class(p)

    Assert(o.inherited, true, "can access prototype")

    p.inherited = false

    Assert(o.inherited, false, "ovewritten")
end)

Test("Extends with properties", function()
    local p = { inherited = true }
    local o = Class(p)
    o.has_own = true
    o.inherited = false

    Assert(o.has_own, true, "has properites")
    Assert(o.inherited, false, "self superseeds parent")
    Assert(p.inherited, true, "does not change prototype")
end)

Test("Calls constructor if any", function()
    local p = Class()

    p._init = function(self)
        self.value = "from constructor"
    end

    local o1 = p()

    Assert(o1.value, "from constructor", "value gets assigned in constructor")

    local o2 = Class(p)

    o1.value = "has changed"

    AssertNot(o1.value, o2.value, "values set in constructor do not affect prototype")

end)

Test("Constructor can take properties", function()
    local p = Class()
    p._init = function(self, arg1, arg2)
        self.arg1 = arg1
        self.arg2 = arg2
    end

    local o = p("hello", 123)

    Assert(o.arg1, "hello", "first argument")
    Assert(o.arg2, 123, "second argument")
end)

Test("makes property unique", function()
    local p = { shared = "yes", unique = false }

    local o1 = Class(p)

    MakeUnique(o1, "shared")

    Assert(o1.shared, "yes", "value is copied")

    o1.shared = "no"

    Assert(o1.shared, "no", "value can be adjusted")
    Assert(p.shared, "yes", "original value intact")

    local o2 = Class(p)

    MakeUnique(o2, "shared", "unique")

    o2.shared = "never"
    o2.unique = true

    Assert(o2.shared, "never")
    Assert(o2.unique, true)
    Assert(o1.shared, "no", "does not change other objects")
end)



Category("Entity")

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

Category("Scene Tree")

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


-----------------------------------------------------
--                 TESTS END HERE                  --
-----------------------------------------------------

print()
print(Data.categories, "categories")
print(Data.tests, "tests")
print(Data.assertions, "assertions")
print(Data.errors, "errors")
print()
print(Data.errors > 0 and Color.red("Fail!") or Color.green("Pass!"))
print()

if Data.errors > 0 then
    os.exit(1)
end
