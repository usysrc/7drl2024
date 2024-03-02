local SpriteMap = require "src.entities.SpriteMap"
local World = require "src.entities.World"

local Entity = function()
    local entity = {}

    entity.x = 0
    entity.y = 0
    entity.char = "A"
    entity.color = { 0, 0, 0 }

    entity.draw = function(self)
        SpriteMap.set(self.char, self.x, self.y, self.color)
    end

    entity.takeDamage = function(self, dmg)
        self.hp = self.hp - dmg
        if self.hp < 0 then
            del(World.objects, self)
        end
    end

    entity.update = function() end

    entity.turn = function() end

    entity.keypressed = function() end

    return entity
end

return Entity
