local World = require "src.entities.World"

local ItemStack = function(item)
    ---@class ItemStack
    local itemStack = {}
    itemStack.item = item ---@type Item
    itemStack.count = 1
    return itemStack
end

local Inventory = function()
    ---@class Inventory
    local inventory = {}
    inventory.itemBag = {}
    inventory.itemStacks = {} ---@type ItemStack[]

    inventory.selector = 1
    inventory.get = function(itemName)
        local itemStack = inventory.itemBag[itemName]
        return itemStack
    end
    inventory.add = function(item)
        if not inventory.itemBag[item.name] then
            inventory.itemBag[item.name] = ItemStack(item)
            add(inventory.itemStacks, inventory.itemBag[item.name])
        end
        inventory.itemBag[item.name].count = inventory.itemBag[item.name].count + 1
    end
    inventory.draw = function(self)
        for i, itemStack in pairs(self.itemStacks) do
            if i == self.selector then
                love.graphics.rectangle("fill", 128 - 16, 128 + i * 16, 8, 8)
            end
            love.graphics.print(itemStack.item.name .. " x" .. itemStack.count, 128, 128 + i * 16)
        end
    end
    inventory.removeSelected = function(self)
        self.itemStacks[self.selector].count = self.itemStacks[self.selector].count - 1
        if self.itemStacks[self.selector].count == 0 then
            self.itemBag[self.itemStacks[self.selector].item.name] = nil
            del(self.itemStacks, self.itemStacks[self.selector])
        end
    end

    inventory.keypressed = function(self, key)
        if key == "return" or key == "enter" then
            if not self.itemStacks[self.selector] then goto continue end
            local used = self.itemStacks[self.selector].item:use(World.hero)
            if used and self.itemStacks[self.selector].item.consumable then
                inventory:removeSelected()
            end
        end
        :: continue ::
        if key == "down" then
            self.selector = self.selector + 1
        end
        if key == "up" then
            self.selector = self.selector - 1
        end
        if self.selector > #self.itemStacks then
            self.selector = 1
        end
        if self.selector < 1 then
            self.selector = #self.itemStacks
        end
    end

    return inventory
end

return Inventory
