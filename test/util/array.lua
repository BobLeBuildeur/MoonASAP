local array = require("../util/array")

Test("Gets index or -1 if not found", function()
    Assert(array.index({ 1, 2, 3 }, 2), 2)
    Assert(array.index({ "a", "b", "c", "d" }, "c"), 3)

    local a = {}
    local b = {}
    local c = {}

    Assert(array.index({ a, b, c }, a), 1)

    Assert(array.index({ 1, 2, 3 }, "nope"), -1)
end)

Test("Finds index and element, or -1 and {} if not found", function()
    
    local i, el = array.find({ 1, 2, 3 }, function(v) return v > 1 end)
    Assert(i, 2)
    Assert(el, 2)

    local a = {v = 'a'}
    local b = {v = 'b'}
    local c = {v = 'c'}

    i, el = array.find({ a, b, c }, function(v) return v.v == "c" end)
    Assert(i, 3)
    Assert(el, c)

    i, el = array.find({1, 2, 3}, function() return false end)
    Assert(i, -1)
end)