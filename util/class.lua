-- Inheritance

--- Extends object's index metatable and optionally apply properties
-- Note that properities that are not explicitily defined will call the parent
-- @param object object to extend
-- @param properties
function Class(super)
    local o = {}
    setmetatable(o, {
        __index = super or {},
        __call = function(self, ...)
            local o = Class(self)
            if o._init then o:_init(...) end
            return o
        end
    })
    return o
end

--- Makes property unique
-- Usually used for lifting a property from super to child
-- so you dont overwrite the prototype when changing its value.
-- Changes the object in the process
-- @param object which object to
-- @param ... properties to lift
-- @return original object
function MakeUnique(object, ...)
    for _, prop in pairs(arg) do
        local value = object[prop]
        object[prop] = value
    end
    return object
end

return Class, MakeUnique
