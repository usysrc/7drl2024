local SpriteMap = require "src.entities.SpriteMap"

local Item = function(name, char, x, y)
    ---@class Item
    local item = {
        x = x or 0,
        y = y or 0,
        name = name,
        char = char,
        draw = function(self)
            SpriteMap.setChar(self.char, self.x, self.y, { 1, 1, 1 })
        end,
        blocked = true,
        pickup = true,
        consumable = false,
    }
    item.use = function(self, other) end
    return item
end
return Item
