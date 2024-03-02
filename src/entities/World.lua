local Map = require "src.entities.Map"
local SpriteMap = require "src.entities.SpriteMap"

local World = function()
    local world = {}

    world.objects = {} ---@type Entity[]
    world.map = Map()
    world.name = "1234"
    world.jobs = {}
    world.hero = nil ---@type Hero
    world.dijkstra = nil ---@type Dijkstra

    world.reset = function()
        world.objects = {}
        world.map = Map()
        world.name = "1234"
    end

    world.getObjectAt = function(self, x, y, except)
        for obj in all(self.objects) do
            ---@cast obj Entity
            if obj ~= except and obj.x == x and obj.y == y then
                return obj
            end
        end
    end

    world.generateMap = function(self)
        for i = 1, 32 do
            for j = 1, 32 do
                if math.random() < 0.1 then
                    self.map:set(i, j, {
                        draw = function()
                            SpriteMap.setChar(50, i, j, { 1, 1, 1 })
                        end,
                        blocked = true,
                    })
                end
            end
        end
    end
    world:generateMap()

    return world
end


return World()
