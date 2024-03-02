--
--  Game
--

local Gamestate   = require("libs.hump.gamestate")
local Timer       = require("libs.hump.timer")
local Hero        = require("src.entities.Hero")
local Goblin      = require("src.entities.Goblin")
local Win         = require("src.states.Win")
local SpriteMap   = require("src.entities.SpriteMap")
local World       = require("src.entities.World")
local Spawner     = require("src.jobs.spawner")
local Game        = Gamestate.new()
local DijkstraMap = require("src.jobs.dijkstra")

local canvas      = love.graphics.newCanvas()
canvas:setFilter("nearest", "nearest")
function Game:enter()
	SpriteMap.clear()

	local hero = Hero()
	add(World.objects, hero)
	World.hero = hero

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
	love.graphics.setCanvas(canvas)
	love.graphics.clear(255 / 255, 241 / 255, 232 / 255, 1)
	SpriteMap.draw()

	love.graphics.setCanvas()
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(canvas, 0, 0, 0, 3, 3)
	love.graphics.setColor(1, 1, 1)

	love.graphics.print("HP: " .. World.hero.hp, 0, 100)
end

function Game:drawToSpriteMap()
	SpriteMap.clear()
	for _, cell in pairs(World.map.data) do
		cell:draw()
	end
	for obj in all(World.objects) do
		obj:draw()
	end
end

function Game:turn()
	DijkstraMap:update()
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
