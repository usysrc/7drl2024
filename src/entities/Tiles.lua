local Tile = require "src.entities.Tile"

local Tiles = {
    tree = function(x, y) return Tile(50, x, y, true) end,
    stone = function(x, y) return Tile(51, x, y, true) end,
    grass = function(x, y) return Tile(53, x, y, false) end,
    tallgrass = function(x, y) return Tile(54, x, y, false) end,
    ledge = function(x, y) return Tile(55, x, y, true) end,
}
return Tiles
