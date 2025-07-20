local cursor = require("mechanics/cursor_movement")

local M = {}

function M.update(map, cam, screenWidth, screenHeight)
  local mapPixelW = map.width  * map.tilewidth
  local mapPixelH = map.height * map.tileheight

  local halfW = screenWidth  / 2 / cam.scale
  local halfH = screenHeight / 2 / cam.scale

  local camX, camY

  if mapPixelW <= screenWidth then
    camX = mapPixelW / 2
  else
    camX = math.max(halfW, math.min(cursor.pixelX, mapPixelW - halfW))
  end

  if mapPixelH <= screenHeight then
    camY = mapPixelH / 2
  else
    camY = math.max(halfH, math.min(cursor.pixelY, mapPixelH - halfH))
  end

  cam:lookAt(math.floor(camX), math.floor(camY))
end

return M

