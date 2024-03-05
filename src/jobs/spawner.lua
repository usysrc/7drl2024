local World = require("src.entities.World")
local Feuxdeux = require("src.entities.Feuxdeux")
local SpriteMap = require("src.entities.SpriteMap")

local Spawner = function()
    ---@class Spawner
    local spawner = {}
    spawner.turn = function()
        if math.random() < 0.1 then
            local x, y = math.random(11, SpriteMap.width - 11), math.random(1, SpriteMap.height)
            local blocked = World:getObjectAt(x, y)
            if blocked then return end
            local tile = World.map:get(x, y)
            if tile and tile.blocked then return end
            local ent = Feuxdeux()
            add(World.objects, ent)
            ent.x, ent.y = x, y
        end
    end
    return spawner
end
return Spawner
