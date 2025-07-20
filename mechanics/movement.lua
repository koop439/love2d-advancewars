local cursor = require("mechanics/cursor_movement")
local M = {}

function M.get_valid_move_tiles(origin_x, origin_y, range, selectable)
  local valid = {}
  for dy = -range, range do
    for dx = -range, range do
      local tx, ty = origin_x + dx, origin_y + dy
      if tx>=1 and tx<=map.width and ty>=1 and ty<=map.height then
        if math.abs(dx) + math.abs(dy) <= range then
          if selectable[ty] and selectable[ty][tx] then
            table.insert(valid, { x = tx, y = ty })
          end
        end
      end
    end
  end
  return valid
end

function M.draw_move_tiles(valid_tiles)
  local gid  = 80
  local t    = map.tiles[gid]
  local img  = map.tilesets[t.tileset].image

  love.graphics.setColor(0, 1, 0, 0.4)
  for _, tile in ipairs(valid_tiles) do
    local px = (tile.x - 1) * map.tilewidth
    local py = (tile.y - 1) * map.tileheight
    love.graphics.draw(img, t.quad, px, py)
  end
  love.graphics.setColor(1, 1, 1, 1)
end

return M
