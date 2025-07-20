 
local sti         = require "lib.sti"
local Camera      = require "lib.hump-master.camera"
local loveframes  = require "lib/LoveFrames-master/loveframes"

local cursor      = require("mechanics/cursor_movement")
local ui          = require("mechanics/ui")
local tools       = require("mechanics/tools")
local movement    = require("mechanics/movement")
local buildingMgr = require("mechanics/activeUnits")
local activeUnits = require("mechanics/activeunits")
local towers      = require("data/towers")

-- Global map + camera
map = sti("maps/tutorial.lua")
local cam

-- State for unit movement
local selected_unit    = nil
local valid_move_tiles = {}

function love.load()
  -- Build selectable-tile lookup & spawn capitals
  selectable_lookup = buildingMgr.build_selectable_lookup()
  buildingMgr.active_search()

  -- Camera starts at cursor
  cam = Camera(cursor.pixelX, cursor.pixelY, 2)

  -- Load UI resources (money, fonts, etc.)
  ui.load()
end

function love.update(dt)
  cursor.update(dt)

  -- Clamp camera to map bounds
  local sw, sh = love.graphics.getDimensions()
  require("mechanics/camera").update(map, cam, sw, sh)

  loveframes.update(dt)
  activeUnits.update_all(dt)
end

function love.draw()
  cam:attach()
    -- Draw map layers
    map:drawLayer(map.layers["Ground"])
    map:drawLayer(map.layers["not selectable Ground"])
    map:drawLayer(map.layers["Buildings"])
    map:drawLayer(map.layers["Trees"])

    -- Building-side UI (spawn buttons & highlights)
    buildingMgr.if_selected(selectable_lookup)

    -- Draw spawned troops
    activeUnits.draw_all()

    -- If a troop is selected, draw its movement range
    if selected_unit then
      movement.draw_move_tiles(valid_move_tiles)
    end

    -- Cursor, previews, and tools
    cursor.draw()
    towers.drawpreview()
    tools.draw()
  cam:detach()

  -- UI overlays
  ui.gui.draw()
  loveframes.draw()

  -- Debug info
  love.graphics.print("FPS: "..tostring(love.timer.getFPS()), 10, 10)
  love.graphics.print(("Cursor tile: %d, %d"):format(cursor.tileX, cursor.tileY), 10, 25)
end

function love.keypressed(key)
  if key == "return" then
    -- 1) Try selecting a troop under cursor
    local cx, cy = cursor.tileX + 1, cursor.tileY + 1
    selected_unit = nil
    for _, u in ipairs(activeUnits.list) do
      local ux = (u.x / map.tilewidth) + 1
      local uy = (u.y / map.tileheight) + 1
      if ux == cx and uy == cy and not u.hasMoved then
        selected_unit    = u
        valid_move_tiles = movement.get_valid_move_tiles(ux, uy, u.range, selectable_lookup)
        break
      end
    end

    -- 2) If no troop selected, delegate to building UI
    if not selected_unit then
      buildingMgr.to_select()
    end

  elseif key == "space" then
    -- First, always attempt building spawn
    towers.update()

    -- Then, if a troop is selected, attempt to move it
    if selected_unit then
      local cx, cy = cursor.tileX + 1, cursor.tileY + 1
      for _, t in ipairs(valid_move_tiles) do
        if t.x == cx and t.y == cy then
          selected_unit.x        = (cx - 1) * map.tilewidth
          selected_unit.y        = (cy - 1) * map.tileheight
          selected_unit.hasMoved = true
          break
        end
      end

      -- Clear selection & highlights
      selected_unit    = nil
      valid_move_tiles = {}
    end
  end
end

-- LoveFrames event passthrough
function love.mousepressed(x,y,b) loveframes.mousepressed(x,y,b) end
function love.mousereleased(x,y,b) loveframes.mousereleased(x,y,b) end
function love.keyreleased(k)   loveframes.keyreleased(k) end

