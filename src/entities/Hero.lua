local Entity    = require "src.entities.Entity"
local World     = require "src.entities.World"
local vector    = require "libs.hump.vector"
local SpriteMap = require "src.entities.SpriteMap"

local Hero      = function()
    ---@class Hero:Entity
    local hero = Entity()
    hero.name = "hero"
    hero.maxhp = 32
    hero.hp = hero.maxhp
    hero.char = 2
    hero.x = SpriteMap.width / 2
    hero.y = SpriteMap.height - 1
    hero.target = nil ---@type Entity
    hero.monsters = {}

    local inventory = {}
    inventory.itemStacks = {}
    inventory.get = function(itemName)
        local itemStack = inventory.itemStacks[itemName]
        return itemStack
    end
    inventory.add = function(item)
        if not inventory.itemStacks[item.name] then
            inventory.itemStacks[item.name] = {
                item = item,
                count = 0
            }
        end
        inventory.itemStacks[item.name].count = inventory.itemStacks[item.name].count + 1
    end

    for i = 1, 3 do
        inventory.add({ name = "picoball", color = { 1, 1, 1 }, char = 18 })
    end

    hero.inventory = inventory

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

    local _draw = hero.drawOverlay
    hero.drawOverlay = function(self)
        _draw(self)
        if self.target and self.target.alive then
            SpriteMap.drawSingle(34, self.target.x, self.target.y, { 1, 1, 1 })
        end
    end

    hero.keypressed = function(self, key)
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
                add(self.monsters, self.target)
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
            World.map:set(tx, ty, nil)
            -- TODO: don't hardcode the ball here
            inventory.add({ name = "picoball", color = { 1, 1, 1 }, char = 18 })
            return
        end

        if World.map:isBlocked(tx, ty) then
            return
        end

        local obj = World:getObjectAt(tx, ty, self)
        if obj then
            obj:takeDamage(1, self)
            return
        end

        -- actually move the hero
        hero.x, hero.y = tx, ty
    end
    return hero
end

return Hero
