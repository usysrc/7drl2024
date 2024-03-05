local Map       = require "src.entities.Map"
local SpriteMap = require "src.entities.SpriteMap"
local Tiles     = require "src.entities.Tiles"

local World     = function()
    local world = {}

    world.objects = {} ---@type Entity[]
    world.map = Map()
    world.name = "1234"
    world.jobs = {}
    world.hero = nil ---@type Hero
    world.dijkstra = nil ---@type Dijkstra
    world.log = {}
    world.camera = nil

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

    world.generateRoute = function(self)
        local doors = {}
        for j = 0, SpriteMap.height do
            doors[j] = math.random(12, SpriteMap.width - 12)
        end
        for i = 0, SpriteMap.width do
            for j = 0, SpriteMap.height do
                if j % 8 == 0 and j < SpriteMap.height - 5 and i ~= doors[j] and i + 1 ~= doors[j] then
                    self.map:set(i, j, Tiles.ledge(i, j))
                end
                if i == doors[j] or i + 1 == doors[j] then
                    self.map:set(i, j, Tiles.tallgrass(i, j))
                end
                if i < 10 or i > SpriteMap.width - 10 then
                    self.map:set(i, j, Tiles.grass(i, j))
                end
                if i == 10 or i == SpriteMap.width - 10 then
                    self.map:set(i, j, Tiles.stone(i, j))
                end
            end
        end
    end
    world:generateRoute()

    return world
end


return World()
