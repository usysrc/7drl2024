local Item     = require "src.entities.Item"
local Potion   = require "src.entities.Potion"

local Picoball = function(x, y)
    ---@class Picoball:Item
    local picoball = Item("picoball", 18, x, y)
    return picoball
end

return {
    Potion = Potion,
    Picoball = Picoball,
}
