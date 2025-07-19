local cursor = require("mechanics/cursor_movement")



local ui = {
  resources = {},
  towers = {},
  troops = {},
  gui = {},
}


--function to quickly put filter for pixel art
local function loadImage(path)
  local img = love.graphics.newImage(path)
  img:setFilter("nearest", "nearest")
  return img
end

--Draws the ui in the top right
local gui_top_right_draw = function(self)
  local screenw, screenh = love.graphics.getWidth(), love.graphics.getHeight()
  local scalew, scaleh = screenw/320, screenh/240

    local scale = math.min(scalew, scaleh)
  love.graphics.draw(ui.gui.top_right.underline, screenw - 90 * scale, 50 * scale, nil, scale, scale)
  love.graphics.draw(ui.gui.top_right.underline, screenw - 90 * scale, 20 * scale, nil, scale, scale)
  love.graphics.draw(ui.gui.top_right.money, screenw - 90 * scale, 40 * scale, nil, scale, scale)
  love.graphics.draw(ui.gui.top_right.power, screenw - 90 * scale, 10 * scale, nil, scale, scale)
  love.graphics.print(tostring(ui.resources.money),  screenw - 80 * scale, 37 * scale, nil, scale, scale)

  love.graphics.print(tostring(ui.resources.power),  screenw - 80 * scale, 6 * scale, nil, scale, scale)
end

-- This calls all the draw functions 
function ui.gui.draw()
  ui.gui.top_right:draw()

end

--Loads all variables from ui table 
function ui.load()
    ui.resources.load()
  end

--Loads resources from ui
local resources_load = function()
    ui.resources.font:setFilter("nearest", "nearest")
    love.graphics.setFont(ui.resources.font)
  end
-- Just a table for the top right gui function
ui.gui.top_right = {

  underline = loadImage("assets/ui/underline.png"),
  power = loadImage("assets/ui/Power.png"),
  money = loadImage("assets/ui/Money.png"),
  draw = gui_top_right_draw,
}
--Resource table for ui
ui.resources = {
  money = 500,
  power = 0,
  font = love.graphics.newImageFont("assets/ui/imagefont.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&'*#=[]\""),
  load = resources_load,
}




----
function selected_type(layer, type)
  if love.keyboard.isDown("return") then
    layer = map.layers[layer]
    local tile = layer.data[cursor.tileY + 1][cursor.tileX + 1]
    if tile then
      print(tile.properties.type)
    end
  end
end
return ui 
