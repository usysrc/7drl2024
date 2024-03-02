local Entity = require "src.entities.Entity"
local World  = require "src.entities.World"


local Hero = function()
    local hero = Entity()
    hero.hp = 32
    hero.char = "A"
    hero.x = 32
    hero.y = 32

    hero.update = function(self)

    end

    hero.moveInput = function(self, key)
        local dx, dy = 0, 0
        if key == "left" then
            dx = dx - 1
        end
        if key == "right" then
            dx = dx + 1
        end
        if key == "up" then
            dy = dy - 1
        end
        if key == "down" then
            dy = dy + 1
        end
        return dx, dy
    end

    hero.keypressed = function(self, key)
        local dx, dy = self:moveInput(key)

        local tx = hero.x + dx
        local ty = hero.y + dy

        if World.map:isBlocked(tx, ty) then
            return
        end

        local obj = World:getObjectAt(tx, ty)
        if obj then
            obj:takeDamage(1)
            return
        end

        -- actually move the hero
        hero.x, hero.y = tx, ty
    end
    return hero
end

return Hero
