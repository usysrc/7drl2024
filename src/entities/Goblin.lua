local Entity = require "src.entities.Entity"
local World = require "src.entities.World"

local Goblin = function()
    local goblin = Entity()
    goblin.hp = 1
    goblin.char = "G"
    goblin.color = { 1, 0, 0 }
    goblin.x = 24
    goblin.y = 28
    goblin.turn = function()
    end
    return goblin
end
return Goblin
