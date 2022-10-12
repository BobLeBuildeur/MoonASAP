return {
    --- Returns index of a value in a table
    -- @param table the input table
    -- @param value the value to compare
    -- @return the index of the element of -1 if not found
    index = function(table, value)
        for i, v in ipairs(table) do
            if v == value then
                return i
            end
        end
        return -1
    end,


    --- Finds first element and index in a table where 
    -- matching function resolves to true
    -- example: find({1, 2, 3}, function(v) return v > 1 end) returns 2, 2
    -- @param table the input table
    -- @param fn the matching function, should return boolean 
    -- @return index, element tuple or an -1 and an empty table if none found
    find = function(table, fn)
        for i, v in ipairs(table) do
            if fn(v) then
                return i, v
            end
        end
        return -1, {}
    end
}