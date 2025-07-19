local sti = require "lib.sti"
local Camera = require "lib.hump-master.camera"
local suit = require "lib.suit-master"
local cursor = require "mechanics/cursor_movement"
local loveframes = require("lib/LoveFrames-master/loveframes")
require("mechanics.camera")
local ui = require("mechanics/ui")
require("mechanics/spawning")
require("mechanics.activeUnits")
local active_units = require("mechanics/activeunits")
local troops = require("data.troops")
local towers = require("data.towers")

map = sti("maps/Tutorial.lua") 

function love.load()
  selectable_lookup = build_selectable_lookup()
  active_search()
  cam = Camera(cursor.pixelX, cursor.pixelY, 2)
  ui.load()
end

function love.update(dt) 
  local screenWidth, screenHeight = love.graphics.getDimensions()
  cursor.update(dt)
  updateCamera(map, cam, screenWidth, screenHeight)
  loveframes.update(dt)
  active_units.update_all(dt)
end

function love.draw()
  cam:attach()
  map:drawLayer(map.layers["Ground"])
  map:drawLayer(map.layers["not selectable Ground"])
  map:drawLayer(map.layers["Buildings"])
  map:drawLayer(map.layers["Trees"])

  if_selected(selectable_lookup)
  active_units.draw_all()
  cursor.draw()

  draw_preview(107)

  cam:detach()

  ui.gui.draw()
  loveframes.draw()

  love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 10, 10)
  love.graphics.print("TileX: "..cursor.tileX, 100, 100)
  love.graphics.print("TileY: "..cursor.tileY, 150, 100)
end

function love.keypressed(k)
  if k == "return" then
    to_select()
  end

  if k == "space" and pending_spawn then
    local tx, ty = cursor.tileX + 1, cursor.tileY + 1
    local selected_building = nil

    for _, building in ipairs(active_buildings) do
      if building.selected then
        selected_building = building
        break
      end
    end

    if selected_building then
      local valid_tiles = get_valid_spawn_tiles(selected_building.x, selected_building.y, selected_building.range, selectable_lookup)
      local can_spawn = false

      for _, tile in ipairs(valid_tiles) do
        if tile.x == tx and tile.y == ty then
          can_spawn = true
          break
        end
      end

      if can_spawn then
        local unit = troops.clone(pending_spawn)
        -- Don't call unit:spawn here if it draws directly, handle drawing in draw
        if ui.resources.money >= unit.cost then
          ui.resources.money = ui.resources.money - unit.cost
          active_units.spawn(unit, tx, ty)
        else
          print("Not enough money!")
        end

        pending_spawn = nil
      else
        print("Cannot spawn there! Tile not valid.")
        pending_spawn = nil
      end
    end
  end
end

-- LoveFrames mouse input
function love.mousepressed(x, y, b) loveframes.mousepressed(x, y, b) end
function love.mousereleased(x, y, b) loveframes.mousereleased(x, y, b) end
function love.keyreleased(k) loveframes.keyreleased(k) end
function love.textinput(t) loveframes.textinput(t) end
