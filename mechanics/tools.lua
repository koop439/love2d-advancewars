local cursor     = require("mechanics/cursor_movement")
local troops     = require("data/troops")
local ui         = require("mechanics/ui")
local active_mgr = require("mechanics/activeunits")

local tools = {}

local TILES_PER_ROW = 18
local colorOffsets = {
  gray   =   0,
  green  =   TILES_PER_ROW,
  blue   = 2*TILES_PER_ROW,
  red    = 3*TILES_PER_ROW,
  yellow = 4*TILES_PER_ROW,
}

function tools.preview(base_gid, color)
  if not base_gid or not color then return end
  local gid = base_gid + (colorOffsets[color] or 0)

  local tx, ty = cursor.tileX + 1, cursor.tileY + 1
  local px = (tx - 1) * map.tilewidth
  local py = (ty - 1) * map.tileheight

  local tile = map.tiles[gid]
  if not tile then return end
  local img  = map.tilesets[tile.tileset].image

  love.graphics.setColor(1,1,1,0.5)
  love.graphics.draw(img, tile.quad, px, py)
  love.graphics.setColor(1,1,1,1)
end

function tools.spawn(valid_tiles, key, base_gid, color, has_money)
  if not has_money then return end

  local gid = base_gid + (colorOffsets[color] or 0)
  local cx, cy = cursor.tileX + 1, cursor.tileY + 1

  for _, t in ipairs(valid_tiles) do
    if t.x == cx and t.y == cy then
      ui.resources.money = ui.resources.money - troops[key].cost

      local base  = troops[key]
      local new_u = setmetatable({}, { __index = base })

      local tile = map.tiles[gid]
      new_u.tile    = tile
      new_u.img     = map.tilesets[tile.tileset].image
      new_u.x       = (cx - 1) * map.tilewidth
      new_u.y       = (cy - 1) * map.tileheight
      new_u.hasMoved= false
      new_u.range   = base.range

      active_mgr.spawn(new_u)
      return
    end
  end
end

function tools.draw()
  active_mgr.draw_all()
end

return tools
