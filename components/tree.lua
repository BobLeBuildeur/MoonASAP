local array = require("util/array")

return {
    init = function(self)
        self._children = {}
        self._parent = {}

        --- adds a child to the current tree
        -- @param self
        -- @param entity the child to add
        self.add_child = function(self, entity)
            entity._parent = self
            table.insert(self._children, entity)
        end

        --- Removes child
        -- @param self
        -- @param entity the child to remove
        -- @return returns removed child or nil if not found
        self.remove_child = function(self, entity)
            local index = array.index(self._children, entity)

            if index == -1 then return nil end

            local removed = self._children[index]
            self._children[index] = nil
            return removed
        end

        --- walks the tree apllying a function to every node
        -- @param self
        -- @param apply function or reference to a function to apply
        -- @param ... any params to pass to the apply function
        self.walk = function(self, apply, ...)
            if type(apply) == "function" then
                apply(self, ...)
            elseif type(self[apply]) ~= "nil" then
                self[apply](self, ...)
            end

            for _, child in ipairs(self._children) do
                child:walk(apply, ...)
            end
        end
    end,
}
