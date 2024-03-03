local Entity    = require "src.entities.Entity"
local World     = require "src.entities.World"
local SpriteMap = require "src.entities.SpriteMap"

local Goblin    = function()
    ---@class Goblin:Entity
    local goblin = Entity()
    goblin.name = "goblin"
    goblin.maxhp = 5
    goblin.hp = goblin.maxhp
    goblin.char = 3
    goblin.color = { 1, 1, 1 }
    goblin.x = 24
    goblin.y = 28

    goblin:register("death", function(self)
        World.map:set(self.x, self.y, {
            draw = function()
                SpriteMap.setChar(18, self.x, self.y, { 1, 1, 1 })
            end,
            blocked = true,
            pickup = true,
        })
    end)

    goblin.turn = function(self)
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
            local num = World.dijkstra.get(pos.i + goblin.x, pos.j + goblin.y)
            if num and num < smallest then
                smallest = num
                dx, dy = pos.i, pos.j
            end
        end
        local tx, ty = goblin.x + dx, goblin.y + dy

        if World.hero.x == tx and World.hero.y == ty then
            World.hero:takeDamage(1)
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

        goblin.x = goblin.x + dx
        goblin.y = goblin.y + dy
    end
    return goblin
end
return Goblin
