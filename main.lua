--
-- main.lua
--
require("libs.strict")
require("globals")
local Game = require("src.states.Game")
local Gamestate = require("libs.hump.gamestate")

math.randomseed(os.time())

-- Initialization
function love.load()
	love.keyboard.setKeyRepeat(true)
	math.randomseed(os.time())
	love.graphics.setFont(love.graphics.newFont("fonts/super.ttf", 8))
	love.graphics.setDefaultFilter("nearest", "nearest")
	Gamestate.registerEvents()
	Gamestate.switch(Game)
end

-- Get console output working with some terminals
io.stdout:setvbuf("no")
