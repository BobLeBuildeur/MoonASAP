
Color = {
    apply = function(text, color)
        return string.format("\27[%sm%s\27[0m", color, text)
    end,
    green = function(text) return Color.apply(text, "32") end,
    red = function(text) return Color.apply(text, "31") end,
    yellow = function(text) return Color.apply(text, 33) end,
}

return Color