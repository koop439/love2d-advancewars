local cursor = require("mechanics/cursor_movement")
local troops = require("data/troops")
local ui = require("mechanics/ui")
local tools = {}

local colorOffsets = {
  gray   = 0,
  green  = 18,
  blue   = 18 * 2,
  red    = 18 * 3,
  yellow = 18 * 4,
}

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


tools.spawn = function(valid_tiles, troopKey, gid, color, enough_money)
    print("⮕ tools.spawn called", "gid=", gid, "color=", color, "troopKey=", troopKey)
  if not gid then
    print("ERROR: nil gid in tools.spawn for", troopKey)
    return
  end

  -- pick offset safely
  local offset = colorOffsets[color] or 0
  local spawn_id = gid + offset

print("   spawn_id →", spawn_id, "map.tiles[spawn_id] →", map.tiles[spawn_id])
  if not map.tiles[spawn_id] then
    error("No tile at that GID! spawn_id is out of range or nil.")
  end

  local tiler = map.tiles[spawn_id]
  print("   tiler.tileset →", tiler.tileset,
        "map.tilesets[tiler.tileset] →", map.tilesets[tiler.tileset])



  for _, t in ipairs(valid_tiles) do
    -- align 0-based cursor with 1-based tile coords
    if cursor.tileX == t.x - 1 and cursor.tileY == t.y - 1 then
      -- deduction
      ui.resources.money = ui.resources.money - troops[troopKey].cost

      -- instantiate
      local base      = troops[troopKey]
      local new_unit  = {}
      setmetatable(new_unit, { __index = base })
      tools.troopset(new_unit, map.tiles[spawn_id],
                     map.tilesets[map.tiles[spawn_id].tileset].image,
                     cursor.tileX, cursor.tileY)

      table.insert(active_troops, new_unit)
      print("✅ spawned:", troopKey, "now have", #active_troops, "troops")
      return
    end
  end
end



tools.draw = function()
print("tools.draw → drawing", #active_troops, "troops")
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



