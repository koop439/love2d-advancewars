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
map = sti("maps/Tutorial.lua") 
local tools = require("mechanics/tools")

function love.keypressed(k)

  if k == "return" then
    to_select()
  end
  if k == "space" then
    print("shot")
    towers.update()
   
  end

  end







function love.load()


-- Goes through that whole table and finds every table that you can and can't select
  selectable_lookup = build_selectable_lookup()
-- This just looks for the starting capitals and grabs their positions
  active_search()
--Sets camera at the cursor position and scales it by 2
  cam = Camera(cursor.pixelX, cursor.pixelY, 2)
-- Loads in resources money and power
  ui.load()
end

function love.update(dt) 
  local screenWidth, screenHeight = love.graphics.getDimensions()
-- Sets a timer for the cursor and moves it stops it at borders
cursor.update(dt)
--moves the camera with the cursor stops it from hitting black 
updateCamera(map, cam, screenWidth, screenHeight)
-- updates UI if their is any 
    loveframes.update(dt)
  active_units.update_all(dt)
    end


function love.draw()
-- Everything in this block 
  cam:attach()
    map:drawLayer(map.layers["Ground"])
    map:drawLayer(map.layers["not selectable Ground"])
    map:drawLayer(map.layers["Buildings"])
    map:drawLayer(map.layers["Trees"])
  
  if_selected(selectable_lookup)
active_units.draw_all()
  cursor.draw()
  towers.drawpreview()
  tools.draw()
 cam:detach()
--Ui draws the top right 
  ui.gui.draw()
--Draws loveframe ui
      loveframes.draw()
--Debug tools
  --
     love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
love.graphics.print(tostring(cursor.tileX), 100, 100)
love.graphics.print(tostring(cursor.tileY), 150, 100)

    end

-- Used to catch inputs 
function love.mousepressed(x,y,b) loveframes.mousepressed(x,y,b) end
function love.mousereleased(x,y,b) loveframes.mousereleased(x,y,b) end
function love.keyreleased(k) loveframes.keyreleased(k) end
