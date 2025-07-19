local cursor = require("mechanics/cursor_movement")
local map = require("maps.Tutorial") -- Adjust this if needed

local troops = {}

troops.clone = function(troop)
  local new = {}
  for k, v in pairs(troop) do
    new[k] = v
  end
  return new
end

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
      self.gid = 107
    elseif color == "green" then
      self.gid = 124
    elseif color == "blue" then
      self.gid = 142
    elseif color == "red" then
      self.gid = 160
    elseif color == "yellow" then
      self.gid = 178
    end

    -- Drawing is done elsewhere, so this can stay empty or setup something else
  end,
  draw_temp = function(self, color)
    if color == "gray" then
      self.gid = 107
    elseif color == "green" then
      self.gid = 124
    elseif color == "blue" then
      self.gid = 142
    elseif color == "red" then
      self.gid = 160
    elseif color == "yellow" then
      self.gid = 178
    end
    -- drawing handled elsewhere
  end,
  draw = function(self)
    local tile = map.tiles[self.gid]
    if tile then
      local img = map.tilesets[tile.tileset].image
      local px = (self.x - 1) * map.tilewidth
      local py = (self.y - 1) * map.tileheight
      love.graphics.draw(img, tile.quad, px, py)
    end
  end,
  update = function(self, dt)
    -- expand as needed
  end,
}

-- Define other troops similarly here...

return troops
