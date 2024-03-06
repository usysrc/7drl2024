local World  = require "src.entities.World"
local Item   = require "src.entities.Item"

local Potion = function(x, y)
    ---@class Potion:Item
    local potion = Item("potion", 19, x, y)
    potion.consumable = true
    potion.use = function(self, hero)
        if not hero.activeMonster then return end
        if hero.activeMonster.hp >= hero.activeMonster.maxhp then return end
        local heal = 5
        if hero.activeMonster.hp + heal > hero.activeMonster.maxhp then
            heal = hero.activeMonster.maxhp - hero.activeMonster.hp
        end
        hero.activeMonster.hp = math.min(hero.activeMonster.maxhp, hero.activeMonster.hp + heal)
        add(World.log, "Your " .. hero.activeMonster.name .. " heals " .. heal .. " hp.")
        return true
    end
    return potion
end
return Potion
