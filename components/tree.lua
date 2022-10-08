return {
    init = function(self)
        self._children = {}
        self._parent = {}

        self.add_child = function(self, entity)
            entity._parent = self
            table.insert(self._children, entity)
        end

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
