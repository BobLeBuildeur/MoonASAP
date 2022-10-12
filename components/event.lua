local array = require("util/array")

return {
    init = function(self)
        self._listeners = {}

        --- Adds a listener to this object
        -- @param self
        -- @param event the event name
        -- @param object the object will be triggered when the event happens
        -- @param handler_ref a reference to a function on the object
        --        which will be called with the object and any other arguments
        self.on = function(self, event, object, handler_ref)
            if not self._listeners[event] then self._listeners[event] = {} end

            table.insert(self._listeners[event], {
                object = object,
                handler = handler_ref
            })
        end

        --- Removes a listener from this object
        -- if object is not defined, will remove all events
        -- @param event the event name
        -- @return removed event(s)
        self.off = function(self, event, object, handler_ref)
            if not self._listeners[event] then return end

            if object == nil then
                local events = self._listeners[event]
                self._listeners[event] = {}
                return events
            end

            local index = array.find(self._listeners[event],
                function(v) return v.object == object and v.handler == handler_ref end)

            if index == -1 then return end

            table.remove(self._listeners[event], index)
        end

        --- Emits and event, triggering any connected listeners
        -- @param self
        -- @param event the event name
        -- @param ... arbitrary params to pass to the listeners
        self.emit = function(self, event, ...)
            if not self._listeners[event] then return end

            for _, listener in ipairs(self._listeners[event]) do
                listener.object[listener.handler](listener.object, ...)
            end
        end
    end
}
