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
    love.graphics.print("All your picomon fainted, you lost!", love.graphics.getWidth() / 2 - 128,
        love.graphics.getHeight() / 2)
end

return Death
