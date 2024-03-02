local World = require("src.entities.World")
local Goblin = require("src.entities.Goblin")

local Spawner = function()
    local spawner = {}
    spawner.turn = function()
        if math.random() < 0.1 then
            local x, y = math.random(20, 30), math.random(20, 30)
            local blocked = World:getObjectAt(x, y)
            if blocked then return end
            local goblin = Goblin()
            add(World.objects, goblin)
            goblin.x, goblin.y = x, y
        end
    end
    return spawner
end
return Spawner
