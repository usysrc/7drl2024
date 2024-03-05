local Entity    = require "src.entities.Entity"
local World     = require "src.entities.World"
local SpriteMap = require "src.entities.SpriteMap"

local Feuxdeux  = function()
    ---@class Feuxdeux:Entity
    local feuxdeux = Entity()
    feuxdeux.name = "feuxdeux"
    feuxdeux.maxhp = 5
    feuxdeux.hp = feuxdeux.maxhp
    feuxdeux.char = 4
    feuxdeux.color = { 1, 1, 1 }
    feuxdeux.x = 24
    feuxdeux.y = 28

    feuxdeux:register("death", function(self)
        -- drop a picoball
        World.map:set(self.x, self.y, {
            draw = function()
                SpriteMap.setChar(18, self.x, self.y, { 1, 1, 1 })
            end,
            blocked = true,
            pickup = true,
        })
    end)

    feuxdeux.turn = function(self)
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
            local num = World.dijkstra.get(pos.i + feuxdeux.x, pos.j + feuxdeux.y)
            if num and num < smallest then
                smallest = num
                dx, dy = pos.i, pos.j
            end
        end
        local tx, ty = feuxdeux.x + dx, feuxdeux.y + dy

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

        feuxdeux.x = feuxdeux.x + dx
        feuxdeux.y = feuxdeux.y + dy
    end
    return feuxdeux
end
return Feuxdeux
