local vector = require("../util/vector")

Test("Length", function()
    local value = math.sqrt(5)
    Assert(vector.len(1, 2), value)
    Assert(vector.len(-1, 2), value)
    Assert(vector.len(1, -2), value)
end)

Test("Normalization", function()
    local x, y = vector.normalize(3, 3)
    local l = tostring(1 / math.sqrt(2))
    Assert(tostring(x), l, "same length")
    Assert(tostring(y), l, "same length")

    local x, y = vector.normalize(3, 2)
    Assert(tostring(x), tostring(0.83205029433784), "different lengths")
    Assert(tostring(y), tostring(0.55470019622523), "different lengths")
end)

Test("Dot product", function()
    Assert(vector.dot(2, 3, 2, 0), 4)
    Assert(vector.dot(-1, 2, 0, -3), -6)
end)

Test("Rotate", function()
    local x, y = vector.rotate(1, 0, math.pi)

    -- fix floating point  error
    y = math.floor(y * 10000) / 10000

    Assert(x, -1)
    Assert(y, 0)
end)