local World = require "src.entities.World"

-- Calculates the distances from the hero
-- to all other objects
-- excludes blocked tiles and mobs
local Dijkstra = function()
    local dijkstramap
    local calculate = function()
        local guys = {}
        for obj in all(World.objects) do
            if obj ~= World.hero then
                guys[obj.x .. "," .. obj.y] = true
            end
        end

        dijkstramap = {}

        local check
        check = function(x, y, k)
            local t = dijkstramap[x .. "," .. y]
            if not World.map:isBlocked(x, y) and (not t or k < t) and not guys[x .. "," .. y] then
                dijkstramap[x .. "," .. y] = k
            else
                return
            end
            if k > 30 then return end
            check(x + 1, y, k + 1)
            check(x - 1, y, k + 1)
            check(x, y + 1, k + 1)
            check(x, y - 1, k + 1)
        end
        local x = World.hero.x
        local y = World.hero.y
        local k = 0
        check(x, y, k)
    end

    ---@class Dijkstra
    local map = {}
    map.turn = calculate
    map.get = function(x, y)
        if dijkstramap ~= nil then
            return dijkstramap[x .. "," .. y]
        end
    end
    return map
end

return Dijkstra
