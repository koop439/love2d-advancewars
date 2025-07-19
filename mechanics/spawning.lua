local cursor = require("mechanics/cursor_movement")

function draw_preview(troopgid)
  if pending_spawn then
    local tileX, tileY = cursor.tileX + 1, cursor.tileY + 1
    local px = (tileX - 1) * map.tilewidth
    local py = (tileY - 1) * map.tileheight

    local tile = map.tiles[troopgid]
    local img = map.tilesets[tile.tileset].image
    if img then
      love.graphics.setColor(1, 1, 1, 0.5) -- semi-transparent preview
      love.graphics.draw(img, tile.quad, px, py)
      love.graphics.setColor(1, 1, 1, 1)
    end
  end
end
