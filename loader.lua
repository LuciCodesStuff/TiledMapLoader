-- Luci's Tiled Map Loader - 2023 - MIT - Be nice!
--[[
    Tiled map loader for Love2D that stays out of your way! No frills!
    Read the code for documentation.
    Visit the GitHub for examples.
    Features added as I needed them, sorry, no requestions.
    There are many much better projects you could use!!

    MIT License:
    
    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]--

local Object = require "classic" -- Todo-Remove this requirement
local Tilemap = Object:extend()

-- Tilemap:new(map, options) Contructs a new Tilemap object
-- map = Tilemap(require "mapfile")
--@param map A Tiled map file exported in lua format with embeded tilesets
--@param options.scale X and Y scale, {x, y}
--@return nothing
function Tilemap:new(map, options)
    if options == nil then options = {} end
    local scale = options.scale or {1,1} -- If you need to scale the canvases
    self.map = map -- Seems like the best place for this to live
    self.canvases = {} -- Home for canvases, lines up with layers
    self.quads = {} -- Home for quads, lines up with tilemaps
    self.imageMaps = {} -- home for tilemap imagemaps, lines up with tilemaps

    -- Init tilesets and quads
    for i = 1, #self.map.tilesets do
        local tileset = self.map.tilesets[i]
        self.imageMaps[i] = love.graphics.newImage(tileset.image)
        local imageMap = self.imageMaps[i] -- [i] can't be nil, so the image was set first
        
        for y = 0, tileset.imageheight - tileset.tileheight, tileset.tileheight do
            for x = 0, tileset.imagewidth - tileset.tilewidth, tileset.tilewidth do
                table.insert(self.quads, love.graphics.newQuad(x, y, tileset.tilewidth, tileset.tileheight, imageMap))
            end
        end
    end

    --Init canvases, scale if required
    for i = 1, #self.map.layers do
        self.canvases[i] = love.graphics.newCanvas(self.map.width * self.map.tilewidth * scale[1], self.map.height * self.map.tileheight * scale[2])
    end
end

-- Tilemap:render() Renders layers to canvases for drawing
--@return nothing
function Tilemap:render()
    for i in pairs(self.map.layers) do
        local canvas = self.canvases[i]
        local layer = self.map.layers[i]
        love.graphics.setCanvas(canvas)
        love.graphics.setBlendMode("alpha")
        love.graphics.setColor(1,1,1,1)
        love.graphics.clear()
        if layer.visible then
            for j in pairs(layer.data) do
                local data = layer.data[j]
                if data ~= 0 then
                    local tileset, imageMap = self:gidmap(data)
                    local quadIndex = data - tileset.firstgid + 1
                    local x = ((j - 1) % layer.width) * tileset.tilewidth
                    local y = math.floor((j - 1) / layer.width) * tileset.tileheight
                    love.graphics.draw(imageMap, self.quads[quadIndex], x, y)
                end
            end
        end
        love.graphics.setCanvas()
    end
end

-- Tilemap:gidmap(gid) Maps a GID to a Tilemap
--@param gid A GID from layer data
--@return Tilemap pointer, imageMap pointer
function Tilemap:gidmap(gid)
    for i in pairs(self.map.tilesets) do
        local tileset = self.map.tilesets[i]
        local imageMap = self.imageMaps[i]
        if gid >= tileset.firstgid and gid < tileset.firstgid + tileset.tilecount then
            return tileset, imageMap
        end
    end
    error("No tileset found for GID: " .. gid)
end

-- Tilemap:drawLayers(n,...) Draws specified layers in the order listed
--@param n One or more layers
--@return nothing
function Tilemap:drawLayers(...)
    local arg = {...}
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.setColor(1,1,1,1)
    for i in pairs(arg) do
        local canvases = self.canvases[i]
        local layer = self.map.layers[i]
        love.graphics.draw(canvas, layer.x, layer.y)
    end
    love.graphics.setBlendMode("alpha")
end

-- Tilemap:draw() Draws all layers
--@return nothing
function Tilemap:draw()
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.setColor(1,1,1,1)
    for i in pairs(self.map.layers) do
        local canvas = self.canvases[i]
        local layer = self.map.layers[i]
        love.graphics.draw(canvas, layer.x, layer.y)
    end
    love.graphics.setBlendMode("alpha")
end

return Tilemap