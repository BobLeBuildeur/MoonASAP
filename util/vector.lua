--- Vector
-- Minimal vector functions
-- @module Vector
local vector = {}

--- Gets the length of a vector
-- @param a
-- @param b
-- @return length
function vector.len(a, b)
    return math.sqrt(a * a + b * b)
end

--- Normalizes vector to unit, so that its length is 1
-- @param a
-- @param b
-- @return normalized a, b tuple
function vector.normalize(a, b)
    local len = vector.len(a, b)
    return a / len, b / len
end

--- Dot product
-- @param a1
-- @param a2
-- @param b1
-- @param b2
-- @return scalar value
function vector.dot(a1, b1, a2, b2)
    return a1 * a2 + b1 * b2
end

--- Rotates a vector by a given angle (radians)
-- @param a
-- @param b
-- @param angle
-- @return a, b tuple of rotated vector
function vector.rotate(a, b, angle)
    return a * math.cos(angle) - b * math.sin(angle),
        a * math.sin(angle) + b * math.cos(angle)
end

return vector
