local cursor = require("mechanics/cursor_movement")

local ui = {
  resources = {},
  towers    = {},
  troops    = {},
  gui       = {},
}

local function loadImage(path)
  local img = love.graphics.newImage(path)
  img:setFilter("nearest", "nearest")
  return img
end

local function gui_top_right_draw(self)
  local sw, sh = love.graphics.getDimensions()
  local scalex = sw/320
  local scaley = sh/240
  local scale  = math.min(scalex, scaley)

  love.graphics.draw(ui.gui.top_right.underline, sw - 90*scale, 50*scale, nil, scale, scale)
  love.graphics.draw(ui.gui.top_right.underline, sw - 90*scale, 20*scale, nil, scale, scale)
  love.graphics.draw(ui.gui.top_right.money,     sw - 90*scale, 40*scale, nil, scale, scale)
  love.graphics.draw(ui.gui.top_right.power,     sw - 90*scale, 10*scale, nil, scale, scale)
  love.graphics.print(tostring(ui.resources.money), sw - 80*scale, 37*scale, nil, scale, scale)
  love.graphics.print(tostring(ui.resources.power), sw - 80*scale, 6*scale, nil, scale, scale)
end

function ui.gui.draw()
  ui.gui.top_right:draw()
end

function ui.load()
  ui.resources.load()
end

local function resources_load()
  ui.resources.font:setFilter("nearest", "nearest")
  love.graphics.setFont(ui.resources.font)
end

ui.gui.top_right = {
  underline = loadImage("assets/ui/underline.png"),
  power     = loadImage("assets/ui/Power.png"),
  money     = loadImage("assets/ui/Money.png"),
  draw      = gui_top_right_draw,
}

ui.resources = {
  money = 500,
  power = 0,
  font  = love.graphics.newImageFont(
    "assets/ui/imagefont.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&'*#=[]\""
  ),
  load = resources_load,
}

return ui
