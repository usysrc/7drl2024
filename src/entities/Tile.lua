local SpriteMap = require "src.entities.SpriteMap"

local Tile = function(char, x, y, blocked)
    ---@class Tile
    local tile = {
        char = char or 50,
        x = x or 0,
        y = y or 0,
        draw = function(self)
            SpriteMap.setChar(self.char, self.x, self.y, { 1, 1, 1 })
        end,
        blocked = blocked,
    }
    return tile
end

return Tile
