local towers     = require("data/towers")
local cursor     = require("mechanics/cursor_movement")
local loveframes = require("lib/LoveFrames-master/loveframes")

local M = {}
local active_buildings = {}

function M.build_selectable_lookup()
  local lookup = {}
  local layers_to_check = { "Buildings", "Troops", "Ground", "Trees" }
  for _, name in ipairs(layers_to_check) do
    local layer = map.layers[name]
    if layer and layer.type == "tilelayer" then
      for y = 1, map.height do
        for x = 1, map.width do
          local tile = layer.data[y][x]
          if tile and tile.properties and tile.properties.Selectable then
            lookup[y] = lookup[y] or {}
            lookup[y][x] = true
          end
        end
      end
    end
  end
  return lookup
end

function M.active_search()
  for y = 1, map.height do
    for x = 1, map.width do
      local tile = map.layers["Buildings"].data[y][x]
      if tile and tile.properties and tile.properties.type == "capital" then
        local base = towers.capital
        local bld  = setmetatable({}, { __index = base })
        bld:spawn(x, y, tile.properties.color)
        table.insert(active_buildings, bld)
      end
    end
  end
end

function M.to_select()
  for _, b in ipairs(active_buildings) do
    b.selected = (cursor.tileX + 1 == b.x and cursor.tileY + 1 == b.y)
  end
end

local function get_valid_spawn_tiles(origin_x, origin_y, range, selectable)
  local valid = {}
  for dy = -range, range do
    for dx = -range, range do
      local tx, ty = origin_x + dx, origin_y + dy
      if (dx~=0 or dy~=0)
         and tx>=1 and tx<=map.width
         and ty>=1 and ty<=map.height
         and selectable[ty] and selectable[ty][tx]
      then
        table.insert(valid, { x = tx, y = ty })
      end
    end
  end
  return valid
end

local function draw_spawnable_tiles(valid_tiles)
  local gid  = 80
  local t    = map.tiles[gid]
  local img  = map.tilesets[t.tileset].image
  for _, tile in ipairs(valid_tiles) do
    local px = (tile.x - 1) * map.tilewidth
    local py = (tile.y - 1) * map.tileheight
    love.graphics.draw(img, t.quad, px, py)
  end
end

function M.if_selected(selectable)
  for _, b in ipairs(active_buildings) do
    if b.selected then
      local tiles = get_valid_spawn_tiles(b.x, b.y, b.range, selectable)
      draw_spawnable_tiles(tiles)
      if not b.has_ui then
        b:ui(loveframes)
        b.has_ui = true
      end
    end
  end
end

-- expose both the list and helper
M.list                    = active_buildings
M.get_valid_spawn_tiles   = get_valid_spawn_tiles

return M
