--
--  Game
--

local Gamestate = require("libs.hump.gamestate")
local Timer     = require("libs.hump.timer")
local Hero      = require("src.entities.Hero")
local Goblin    = require("src.entities.Goblin")
local Win       = require("src.states.Win")
local SpriteMap = require("src.entities.SpriteMap")
local World     = require("src.entities.World")
local Spawner   = require("src.jobs.spawner")
local Game      = Gamestate.new()

function Game:enter()
	SpriteMap.clear()

	local hero = Hero()
	add(World.objects, hero)

	add(World.jobs, Spawner())

	Game:drawToSpriteMap()
end

function Game:update(dt)
	Timer.update(dt)
	for obj in all(World.objects) do
		obj:update()
	end
end

function Game:draw()
	love.graphics.clear(245 / 255, 245 / 255, 245 / 255, 1)
	SpriteMap.draw()
	love.graphics.print(love.timer.getFPS(), 0, 0)
end

function Game:drawToSpriteMap()
	SpriteMap.clear()
	for obj in all(World.objects) do
		obj:draw()
	end
end

function Game:turn()
	for job in all(World.jobs) do
		job:turn()
	end
	for obj in all(World.objects) do
		obj:turn()
	end
	Game:drawToSpriteMap()
end

function Game:mousepressed(x, y, button)
	Gamestate.switch(Win)
end

function Game:keypressed(key)
	for obj in all(World.objects) do
		obj:keypressed(key)
	end
	Game:turn()
end

return Game
