# TiledMapLoader
Luci's Tiled Map Loader

Tiled map loader for Love2D that stays out of your way! No frills!

## Usage
Create a map object:
```lua
    tilemap = Tilemap(require "mapfile")
```
Create a map object, apply scaling multiplier: (This will fix incorrectly sized canvases when scaling)
```lua
    tilemap = Tilemap(require "mapfile", {scale = {2, 2}})
```

Create a map object that lives in a subdirectory: (This will correct issues where the map file lives in another directory but the tileset data is unaware)
```lua
    tilemap = Tilemap(require "directory.mapfile", {directory = "directory" })
```

Render the layers:
```lua
    tilemap:render()
```

Draw the layers:
```lua
    tilemap:draw()
```

Draw specific layers, or change order:
```lua
    tilemap:drawLayers(1,4,3)
```

Modify layer properties:
```lua
    local layer = tilemap.map.layers[2]
    layer.visible = true
    layer.x = layer.x + layer.parallaxx * dt
```

## Example
```lua
function love.load()
    local Tilemap = require "loader.lua"
    tilemap = Tilemap(require "tiledfile")
    tilemap:render()
end

function love.update(dt)
    ...
    local layer = tilemap.map.layers[2]
    layer.visible = true
    layer.x = layer.x + layer.parallaxx * dt
    ...
end

function love.draw()
    ...
    world:draw()
    ...
end
```