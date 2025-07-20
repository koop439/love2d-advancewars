local cursor = require("mechanics/cursor_movement")
local troops = require("data/troops")
local ui = require("mechanics/ui")
local tools = {}


tools.preview = function(id, color)
  if id and color then
    local tilex, tiley = cursor.tileX + 1, cursor.tileY + 1
    local px = (tilex - 1) * map.tilewidth
    local py= (tiley - 1) * map.tileheight
    
     if color == "gray" then
      id = id
    elseif color == "green" then
      id  = id + 18
    elseif color == "blue" then
      id  = id + 18*2
    elseif color == "red" then
      id = id + 18*3
    elseif color == "yellow" then
      id  = id + 18*4
    end
    
    local tile = map.tiles[id]
    local img = map.tilesets[tile.tileset].image
    local preview_img, quad = img, tile.quad
    if preview_img then
      love.graphics.setColor(1, 1, 1, 1) -- half-transparent preview
			love.graphics.draw(preview_img, quad, px, py)

    end
  end 
end


tools.spawn = function(valid_tiles, troop, id, color, enough_money)
  
  can_spawn = false
     if color == "gray" then
      id = id
    elseif color == "green" then
      id  = id + 18
    elseif color == "blue" then
      id  = id + 18*2
    elseif color == "red" then
      id = id + 18*3
    elseif color == "yellow" then
      id  = id + 18*4
    end
    
	local tiler = map.tiles[id]
	local img = map.tilesets[tiler.tileset].image

	for _, tile in ipairs(valid_tiles) do
    if cursor.tileX == tile.x and cursor.tileY == tile.y and enough_money then
      can_spawn = true
      ui.resources.money = ui.resources.money - troops[troop].cost
      break
    end
	end
  if can_spawn then
      local base = troops[troop]

	local new_troop = {}
	setmetatable(new_troop, { __index = base })

 tools.troopset(new_troop,tiler,img,cursor.tileX,cursor.tileY) 
	table.insert(active_troops, new_troop)
end

   end


tools.draw = function()
  for _, troop in ipairs(active_troops) do 
    love.graphics.draw(troop.img, troop.tile.quad, troop.x, troop.y)
end
end

tools.troopset = function(self, tile, img, x, y)
    self.tile = tile
    self.img = img 
    self.x = x
    self.y = y
    

  end
return tools



