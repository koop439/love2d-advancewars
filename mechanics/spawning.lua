local cursor = require("mechanics/cursor_movement")
local troops = require("data/troops")

function draw_preview(troopgid)
  if pending_spawn then
		local tileX, tileY = cursor.tileX + 1, cursor.tileY + 1
		local px = (tileX - 1) * map.tilewidth
		local py = (tileY - 1) * map.tileheight

		local tile = map.tiles[troopgid]
		local img = map.tilesets[tile.tileset].image
		local preview_img, quad = img, tile.quad
		if preview_img then
			love.graphics.setColor(1, 1, 1, 1) -- half-transparent preview
			love.graphics.draw(preview_img, quad, px, py)
		end
	end

	love.graphics.setColor(1, 1, 1, 1)
end
