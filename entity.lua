-- ECS
Entity = Class()


Entity._init = function(self)
    self._components = {}
end

--- Adds component
-- Accepts both functions or tables.
-- In case of a table, we expect a process function, otherwise it is ignored
-- optionally, an init function can be provided, which runs when it is added
-- @param self
-- @param component function or table with process function (and optional init) that take in self
function Entity.add_component(self, component)
    if type(component) == "function" then
        table.insert(self._components, component)
        return
    end

    if type(component) == "table" then
        if component.init then
            component.init(self)
        end
        if component.process then
            table.insert(self._components, component.process)
        end
    end
end

function Entity.process(self, delta)
    for _, component in ipairs(self._components) do
        component(self, delta)
    end
end

return Entity