local Inventory = function()
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
    return inventory
end

return Inventory
