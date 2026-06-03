local colors = require("dark-config.ui.bars.colors")

---@class dark-config.bars.Bar
local Bar = {}

---@return dark-config.bars.Bar
function Bar:new()
    local o = { out = "" }
    setmetatable(o, self)
    self.__index = self
    return o
end

function Bar:add(item)
    self.out = self.out .. item
end

function Bar:pad(amount)
    self:add(string.rep(" ", amount))
end

function Bar:module(color, text)
    self:add(color)
    self:pad(1)
    self:add(text)
    self:pad(1)
    self:add(colors.reset)
end

function Bar:module_opt(color, text)
    self:add("%(")
    self:add(color)
    self:pad(1)
    self:add(text)
    self:pad(1)
    self:add(colors.reset)
    self:add("%)")
end

function Bar:colored_opt(color, text)
    self:add("%(")
    self:add(color)
    self:add(text)
    self:add(colors.reset)
    self:add("%)")
end

function Bar:spacer()
    self:add("%=")
end

function Bar:get()
    return self.out
end

return Bar
