local cursor = require("mechanics/cursor_movement")

troops = {}

troops.shotgun = {

    health = 3,
    damage = 2,
    range = 1,
    movement = 2,
    selected = false,
    color = nil,
    gid = 107,
    cost = 100,
    spawn = function(self, color)
    if color == "gray" then
      self.gid = 106
    elseif color == "green" then
      self.gid = 124
    elseif color == "blue" then
      self.gid = 142
    elseif color == "red" then
      self.gid = 160
    elseif color == "yellow" then
      self.gid = 178
    end
    
  local tile = map.tiles[self.gid]
	local img = map.tilesets[tile.tileset].image
  love.graphics.draw(img, tile.quad, cursor.tileX,cursor.tileY) 
  end,  
  draw_temp = function(self, color)
 if color == "gray" then
      self.gid = 106
    elseif color == "green" then
      self.gid = 124
    elseif color == "blue" then
      self.gid = 142
    elseif color == "red" then
      self.gid = 160
    elseif color == "yellow" then
      self.gid = 178
    end
    
  local tile = map.tiles[self.gid]
	local img = map.tilesets[tile.tileset].image
  love.graphics.draw(img, tile.quad, cursor.tileX,cursor.tileY) 
  end


  }
troops.bazooka = {
    health = 1,
    damage = 3,
    range = 2,
    movement = 1,
    selected = false,
    color = nil,



   
  }


troops.truck = {
    health = 5,
    damage = 0,
    range = 1,
    movement = 3,
    power = 1,
    selected = false,
    color = nil,
  }
  troops.supply_truck = {
    health = 5,
    damage = 0,
    range = 1,
    movement = 3,
    power = 1,
    selected = false,
    color = nil,

  }
  troops.carrier = {
    health = 8,
    damage = 0, 
    range = 1,
    movement = 2,
    power = 1,
    selected = false,
    color = nil,
  }
  troops.tank = {
    health = 8,
    damage = 5,
    range = 2,
    movement = 2,
    power = 1,
    selected = false,
    color = nil,

  }
  troops.artillery = {
    health = 5,
    damage = 3,
    range  = 5,
    movement = 1,
    power = 1,
    selected = false,
    color = nil,



  }

return troops
