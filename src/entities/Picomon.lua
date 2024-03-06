local Entity    = require "src.entities.Entity"
local World     = require "src.entities.World"
local SpriteMap = require "src.entities.SpriteMap"
local Items     = require "src.entities.Items"

local Picomon   = function()
    ---@class Picomon:Entity
    local picomon = Entity()
    picomon.name = "missingno"
    picomon.maxhp = 5
    picomon.hp = picomon.maxhp
    picomon.char = 4
    picomon.color = { 1, 1, 1 }
    picomon.x = 24
    picomon.y = 28

    picomon:register("death", function(self)
        -- drop a picoball
        -- TODO: drop other items here
        local pos = { Items.Picoball, Items.Potion }
        World.map:set(self.x, self.y, pos[math.random(1, #pos)](self.x, self.y))
    end)

    picomon.calculateDamage = function(self)
        return 1
    end

    picomon.turn = function(self)
        if math.random() < 0.5 then return end
        local dx, dy = 0, 0
        local smallest = math.huge
        local possibilities = {
            { i = -1, j = 0 },
            { i = 1,  j = 0 },
            { i = 0,  j = 1 },
            { i = 0,  j = -1 },
        }
        for pos in all(possibilities) do
            local num = World.dijkstra.get(pos.i + picomon.x, pos.j + picomon.y)
            if num and num < smallest then
                smallest = num
                dx, dy = pos.i, pos.j
            end
        end
        local tx, ty = picomon.x + dx, picomon.y + dy

        if World.hero.x == tx and World.hero.y == ty then
            World.hero:takeDamage(1, self)
            return
        end
        for obj in all(World.objects) do
            ---@cast obj Entity
            if obj.x == tx and obj.y == ty then
                return
            end
        end
        if World.map:isBlocked(tx, ty) then
            return
        end

        picomon.x = picomon.x + dx
        picomon.y = picomon.y + dy
    end
    return picomon
end
return Picomon
