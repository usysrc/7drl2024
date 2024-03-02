local SpriteMap = require "src.entities.SpriteMap"
local World = require "src.entities.World"

local Entity = function()
    ---@class Entity
    local entity = {}
    entity.name = "entity"
    entity.x = 0
    entity.y = 0
    entity.char = 40
    entity.color = { 1, 1, 1 }
    entity.hp = 10

    entity.draw = function(self)
        SpriteMap.setChar(self.char, self.x, self.y, self.color)
    end

    entity.takeDamage = function(self, dmg)
        self.hp = self.hp - (dmg or 0)
        if self.hp < 0 then
            del(World.objects, self)
        end
    end

    entity.update = function() end

    entity.turn = function(self) end

    entity.keypressed = function(self, key) end

    return entity
end

return Entity
