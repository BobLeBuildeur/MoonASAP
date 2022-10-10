
local text = {
    _apply = function(str, color)
        return string.format("\27[%sm%s\27[0m", color, str)
    end,
    green = function(self, str) return self._apply(str, "32") end,
    red = function(self, str) return self._apply(str, "31") end,
    yellow = function(self, str) return self._apply(str, 33) end,
}

return text