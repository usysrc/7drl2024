local imgData = love.image.newImageData("img/tiles.png")

local tileWidth, tileHeight = 12, 12
local tilesPerRow = 16
local numberOfTiles = 255
local spriteBatchWidth = 87
local spriteBatchHeight = 25

-- make background transparent
imgData:mapPixel(function(x, y, r, g, b, a)
    if r == 1 and g == 0 and b == 1 then
        return 1, 1, 1, 0
    end
    return r, g, b, a
end)
local img = love.graphics.newImage(imgData)
local spritebatch = love.graphics.newSpriteBatch(img, spriteBatchWidth * spriteBatchHeight, "stream")

local quads = {}
for x = 0, numberOfTiles do
    local i, j = (x % tilesPerRow), math.floor(x / tilesPerRow)
    quads[x] = love.graphics.newQuad(i * tileWidth, j * tileHeight, tileWidth, tileHeight, img:getWidth(),
        img:getHeight())
end

local w, h = 86, 49
local map = {}
local idmap = {}
for i = 0, w do
    map[i] = {}
    idmap[i] = {}
    for j = 0, h do
        map[i][j] = 68
        spritebatch:setColor(255, 255, 255)
        idmap[i][j] = spritebatch:add(quads[map[i][j]], i * tileWidth, j * tileHeight)
    end
end

local updateSpriteMap = function()
    for i = 0, w do
        for j = 0, h do
            spritebatch:setColor(255, 255, 255)
            spritebatch:set(idmap[i][j], quads[map[i][j]], i * tileWidth, j * tileHeight)
        end
    end
end

updateSpriteMap()
local draw = function()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(spritebatch)
end

local clear = function()
    for i = 0, w do
        for j = 0, h do
            map[i][j] = 0
            spritebatch:setColor(255, 255, 255)
            spritebatch:set(idmap[i][j], quads[map[i][j]], i * 12, j * 12)
        end
    end
end

local function string_to_int_char(string)
    -- Check for valid input
    if not string or string:len() > 1 then
        return nil
    end

    -- Extract the character
    local char = string:sub(1, 1)

    -- Convert to integer
    return string.byte(char)
end

local setChar = function(char, x, y, color)
    map[x][y] = char
    spritebatch:setColor(color or { 0, 0, 0 })
    spritebatch:set(idmap[x][y], quads[map[x][y]], x * 12, y * 12)
end

local set = function(str, x, y, color)
    local char = string_to_int_char(str)
    if char == nil then
        return "Invalid character: " .. str
    end
    setChar(char, x, y, color)
end

local write = function(what, x, y, color)
    for i = 1, #what do
        local err = set(what:sub(i, i), x + i - 1, y, color)
        if err then
            return err
        end
    end
end


return {
    clear = clear,
    set = set,
    write = write,
    draw = draw,
}
