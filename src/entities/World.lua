local Map = require "src.entities.Map"

local World = function()
    local world = {}

    world.objects = {}
    world.map = Map()
    world.name = "1234"
    world.jobs = {}

    world.reset = function()
        world.objects = {}
        world.map = Map()
        world.name = "1234"
    end

    world.getObjectAt = function(self, x, y, except)
        for obj in all(self.objects) do
            if obj ~= except and obj.x == x and obj.y == y then
                return obj
            end
        end
    end

    return world
end


return World()
