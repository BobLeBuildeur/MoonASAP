require("../class")

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
