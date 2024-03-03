local SpriteMap = require "src.entities.SpriteMap"
local World = require "src.entities.World"
local Gamestate = require "libs.hump.gamestate"
local Death = require "src.states.Death"

local Entity = function()
    ---@class Entity
    local entity = {}
    entity.name = "entity"
    entity.x = 0
    entity.y = 0
    entity.char = 40
    entity.color = { 1, 1, 1 }
    entity.maxhp = 10
    entity.hp = entity.maxhp
    entity.alive = true
    entity.events = {}

    entity.draw = function(self)
        SpriteMap.setChar(self.char, self.x, self.y, self.color)
    end

    entity.register = function(self, what, fn)
        if not self.events[what] then
            self.events[what] = {}
        end
        add(self.events[what], fn)
    end

    entity.emit = function(self, what)
        if not self.events[what] then return end
        for event in all(self.events[what]) do
            event(self)
        end
    end

    entity.drawOverlay = function(self)
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", self.x * SpriteMap.tileWidth, self.y * SpriteMap.tileHeight - 2,
            SpriteMap.tileWidth * (self.hp / self.maxhp), 2)
    end

    entity.takeDamage = function(self, dmg)
        self.hp = self.hp - (dmg or 0)
        if self.hp <= 0 then
            if self.name == "hero" then
                Gamestate.switch(Death)
            end
            entity:emit("death")
            self.alive = false
            del(World.objects, self)
        end
    end

    entity.update = function() end

    entity.turn = function(self) end

    entity.keypressed = function(self, key) end

    return entity
end

return Entity
