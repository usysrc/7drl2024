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
local Dijkstra  = require("src.jobs.dijkstra")
local Camera    = require("libs.hump.camera")

local canvas    = love.graphics.newCanvas()
local zoom      = 2
canvas:setFilter("nearest", "nearest")
function Game:enter()
	SpriteMap.clear()

	World.camera = Camera()

	local hero = Hero()
	add(World.objects, hero)
	World.hero = hero

	add(World.jobs, Spawner())

	local dijkstra = Dijkstra()
	add(World.jobs, dijkstra)
	World.dijkstra = dijkstra

	Game:drawToSpriteMap()
end

function Game:update(dt)
	World.camera.x = World.hero.x * SpriteMap.tileWidth + love.graphics.getWidth() / (2 * zoom)
	World.camera.y = World.hero.y * SpriteMap.tileHeight + love.graphics.getHeight() / (2 * zoom)
	Timer.update(dt)
	for obj in all(World.objects) do
		obj:update()
	end
end

function Game:draw()
	love.graphics.setCanvas(canvas)
	World.camera:attach()
	love.graphics.clear(0, 0, 0, 1)
	SpriteMap.draw()

	for obj in all(World.objects) do
		obj:drawOverlay()
	end
	World.camera:detach()
	love.graphics.setCanvas()
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(canvas, 0, 0, 0, zoom, zoom)
	love.graphics.setColor(1, 1, 1)



	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", 0, love.graphics.getHeight() - 96, love.graphics.getWidth(), 96)
	love.graphics.setColor(1, 1, 1)
	for i = 0, 4 do
		local log = World.log[#World.log - i]
		if log then
			love.graphics.print(log, 0, love.graphics.getHeight() - 96 + i * 16)
		end
	end

	love.graphics.print("HP: " .. World.hero.hp, 0, 100)
	love.graphics.print("Route 1", love.graphics.getWidth() / 2, 0)
	local i = 0
	for itemName, itemStack in pairs(World.hero.inventory.itemStacks) do
		i = i + 1
		love.graphics.print(itemName .. " x" .. itemStack.count, 0, 100 + i * 16)
	end
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
	for job in all(World.jobs) do
		job:turn()
	end
	for obj in all(World.objects) do
		obj:turn()
	end
	if SpriteMap.dirty then Game:drawToSpriteMap() end
end

function Game:mousepressed(x, y, button)
	Gamestate.switch(Win)
end

function Game:keypressed(key)
	local skipTurn = false
	for obj in all(World.objects) do
		local skip = obj:keypressed(key)
		if skip then
			skipTurn = true
		end
	end
	if skipTurn then return end
	Game:turn()
end

return Game
