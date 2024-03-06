local World     = require "src.entities.World"
local SpriteMap = require "src.entities.SpriteMap"
local Picomon   = require "src.entities.Picomon"

local Feuxdeux  = function()
    ---@class Feuxdeux:Picomon
    local feuxdeux = Picomon()
    feuxdeux.name = "feuxdeux"
    feuxdeux.maxhp = 5
    feuxdeux.hp = feuxdeux.maxhp
    feuxdeux.char = 4
    feuxdeux.color = { 1, 1, 1 }

    return feuxdeux
end
return Feuxdeux
