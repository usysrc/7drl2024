--
-- Death
--

local Gamestate = require("libs.hump.gamestate")

local Death = Gamestate.new()

function Death:enter()

end

function Death:update(dt)

end

function Death:draw()
    love.graphics.print("You died!", love.graphics.getWidth() / 2 - 32, love.graphics.getHeight() / 2)
end

return Death
