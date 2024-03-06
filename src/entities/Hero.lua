local Entity    = require "src.entities.Entity"
local World     = require "src.entities.World"
local vector    = require "libs.hump.vector"
local SpriteMap = require "src.entities.SpriteMap"
local Inventory = require "src.entities.Inventory"
local Feuxdeux  = require "src.entities.Feuxdeux"
local Gamestate = require "libs.hump.gamestate"
local Inventar  = require "src.states.Inventar"
local Items     = require "src.entities.Items"
local Death     = require "src.states.Death"

local Hero      = function()
    ---@class Hero:Entity
    local hero = Entity()
    hero.name = "hero"
    hero.maxhp = 32
    hero.hp = hero.maxhp
    hero.char = 2
    hero.x = SpriteMap.width / 2
    hero.y = SpriteMap.height - 1
    hero.target = nil ---@type Picomon
    hero.monsters = {
        Feuxdeux()
    }
    hero.box = {}
    hero.activeMonster = hero.monsters[1] ---@type Picomon

    hero.inventory = Inventory()

    for i = 1, 3 do
        hero.inventory.add(Items.Picoball())
        hero.inventory.add(Items.Potion())
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

    hero.drawOverlay = function(self)
        SpriteMap.drawSingle(self.char, self.x, self.y, { 1, 1, 1 })
        if self.activeMonster then
            love.graphics.setColor(1, 0, 0)
            love.graphics.rectangle("fill", self.x * SpriteMap.tileWidth, self.y * SpriteMap.tileHeight - 2,
                SpriteMap.tileWidth * (self.activeMonster.hp / self.activeMonster.maxhp), 2)
        end
        if self.target and self.target.alive then
            SpriteMap.drawSingle(34, self.target.x, self.target.y, { 1, 1, 1 })
        end
    end

    hero.takeDamage = function(self, dmg, other)
        if not self.activeMonster then return end
        self.activeMonster:takeDamage(dmg, other)
        -- check for death
        if self.activeMonster.hp <= 0 then
            append(World.log, " Your " .. self.activeMonster.name .. " is dead.")
            del(self.monsters, self.activeMonster)
            self.activeMonster = self.monsters[1]
        end
        if not self.activeMonster then
            Gamestate.switch(Death)
        end
    end

    hero.keypressed = function(self, key)
        -- hotkeys
        if key == "1" then
            self.inventory.selector = 1
            self.inventory:keypressed("enter")
            return
        end
        if key == "2" then
            self.inventory.selector = 2
            self.inventory:keypressed("enter")
            return
        end

        if key == "i" or key == "e" then
            Gamestate.push(Inventar)
            return
        end
        -- target an entity
        if key == "f" then
            local smallest, target = math.huge, nil
            for obj in all(World.objects) do
                if obj == hero then goto continue end
                local dist = vector(obj.x, obj.y):dist(vector(hero.x, hero.y))
                if dist < smallest then
                    smallest = dist
                    target = obj
                end
                :: continue ::
            end
            if target then self.target = target end
            return true
        end

        -- try to capture
        if key == "c" then
            if not self.target then return end
            local picoballs = self.inventory.get("picoball")
            if not picoballs then return end
            if picoballs.count > 0 then
                picoballs.count = picoballs.count - 1
            elseif picoballs.count <= 0 then
                return
            end
            if math.random() < 0.5 then
                add(World.log, "You catch a " .. self.target.name .. ".")
                if #self.monsters >= 3 then
                    append(World.log, " You put it in your pico-box.")
                    add(self.box, self.target)
                else
                    add(self.monsters, self.target)
                    if not self.activeMonster then self.activeMonster = self.target end
                end
                del(World.objects, self.target)
                self.target = nil
            else
                add(World.log, "The picoball misses the target!")
            end
        end

        local dx, dy = self:moveInput(key)
        local tx = hero.x + dx
        local ty = hero.y + dy

        if tx <= 0 or ty <= 0 or tx > SpriteMap.width or ty > SpriteMap.height then
            return
        end

        if World.map:get(tx, ty) and World.map:get(tx, ty).pickup then
            local item = World.map:get(tx, ty)
            World.map:set(tx, ty, nil)
            hero.inventory.add(item)
            return
        end

        if World.map:isBlocked(tx, ty) then
            return
        end

        local obj = World:getObjectAt(tx, ty, self)
        if obj then
            local dmg = 0
            if self.activeMonster then
                dmg = self.activeMonster:calculateDamage()
            else
                dmg = 1
            end
            obj:takeDamage(dmg, self.activeMonster or self)
            return
        end

        -- actually move the hero
        hero.x, hero.y = tx, ty
    end
    return hero
end

return Hero
