--
-- Inventory
--

local Gamestate = require("libs.hump.gamestate")
local World     = require("src.entities.World")

local Inventar  = Gamestate.new()

function Inventar:enter()

end

function Inventar:update(dt)

end

function Inventar:draw()
    Gamestate.peek():draw()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1)
    World.hero.inventory:draw()
end

function Inventar:keypressed(key)
    World.hero.inventory:keypressed(key)
    if key == "escape" or key == "e" or key == "i" then
        Gamestate.pop()
    end
end

return Inventar
