# TiledMapLoader
Luci's Tiled Map Loader

Tiled map loader for Love2D that stays out of your way! No frills!

## Usage
Create a map object:
```lua
    tilemap = Tilemap(require "mapfile")
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

Modify a layer property:
```lua
    tilemap.map.layers[1].visible = false
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
end

function love.draw()
    ...
    world:draw()
    ...
end
```
