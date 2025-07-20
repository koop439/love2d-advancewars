-- mechanics/tools.lua

local cursor = require("mechanics/cursor_movement")
local troops = require("data/troops")
local ui     = require("mechanics/ui")

local tools = {}

-- how many tiles per row in your troops tileset
local TILES_PER_ROW = 18

local colorOffsets = {
  gray   = 0,
  green  = 1 * TILES_PER_ROW,
  blue   = 2 * TILES_PER_ROW,
  red    = 3 * TILES_PER_ROW,
  yellow = 4 * TILES_PER_ROW,
}

-- Draws a transparent preview of the unit under the cursor
function tools.preview(base_gid, color)
  if not base_gid or not color then return end

  -- apply color offset
  local offset = colorOffsets[color] or 0
  local gid    = base_gid + offset

  -- cursor.tileX/Y are 0-based, map.tiles is 1-based
  local tilex, tiley = cursor.tileX + 1, cursor.tileY + 1
  local px = (tilex - 1) * map.tilewidth
  local py = (tiley - 1) * map.tileheight

  local tile = map.tiles[gid]
  if not tile then return end
  local img  = map.tilesets[tile.tileset].image

  love.graphics.setColor(1, 1, 1, 0.5)
  love.graphics.draw(img, tile.quad, px, py)
  love.graphics.setColor(1, 1, 1, 1)
end

-- Attempts to spawn a unit on the tile under the cursor
-- valid_tiles: array of { x=1-based, y=1-based } tile coords
-- key:          string key into troops (e.g. "shotgun")
-- base_gid:     integer GID for gray version
-- color:        string color name
-- has_money:    boolean: ui.resources.money >= cost
function tools.spawn(valid_tiles, key, base_gid, color, has_money)
  if not has_money or not key or not base_gid or not color then
    return
  end

  -- compute actual GID based on color
  local offset = colorOffsets[color] or 0
  local gid    = base_gid + offset

  -- convert cursor to 1-based for comparison
  local cx, cy = cursor.tileX + 1, cursor.tileY + 1

  for _, t in ipairs(valid_tiles) do
    if t.x == cx and t.y == cy then
      -- deduct cost
      ui.resources.money = ui.resources.money - troops[key].cost

      -- instantiate new unit
      local base     = troops[key]
      local new_unit = setmetatable({}, { __index = base })

      -- record tile data and image
      local tile = map.tiles[gid]
      new_unit.tile = tile
      new_unit.img  = map.tilesets[tile.tileset].image

      -- convert tile coords to pixel coords
      new_unit.x = (cx - 1) * map.tilewidth
      new_unit.y = (cy - 1) * map.tileheight

      -- insert into your global active_troops
      active_troops = active_troops or {}
      table.insert(active_troops, new_unit)
      return
    end
  end
end

-- Draws all troops that have been spawned
function tools.draw()
  if not active_troops then return end

  for _, u in ipairs(active_troops) do
    love.graphics.draw(u.img, u.tile.quad, u.x, u.y)
  end
end

return tools
