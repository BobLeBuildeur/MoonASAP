--- Vector
-- Minimal vector functions
-- @module Vector
Vector = {

    --- Gets the length of a vector
    -- @param a
    -- @param b
    -- @return length
    len = function(a, b)
        return math.sqrt(a * a + b * b)
    end,

    --- Normalizes vector to unit, so that its length is 1
    -- @param a
    -- @param b
    -- @return normalized a, b tuple
    normalize = function(a, b)
        local len = Vector.len(a, b)
        return a / len, b / len
    end,

    --- Dot product
    -- @param a1
    -- @param a2
    -- @param b1
    -- @param b2
    -- @return scalar value
    dot = function(a1, b1, a2, b2)
        return a1 * a2 + b1 * b2
    end,

    --- Rotates a vector by a given angle (deg)
    -- @param a
    -- @param b
    -- @param angle
    -- @return a, b tuple of rotated vector
    rotate = function(a, b, angle)
        return a * math.cos(angle) - b * math.sin(angle),
            a * math.sin(angle) + b * math.cos(angle)
    end,
}

return Vector