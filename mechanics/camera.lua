local cursor = require("mechanics/cursor_movement")

function updateCamera(map, cam, screenWidth, screenHeight)
  local mapPixelWidth = map.width * map.tilewidth
  local mapPixelHeight = map.height * map.tileheight

  local halfW = screenWidth / 2 / cam.scale
  local halfH = screenHeight / 2 / cam.scale

  local camX, camY

  if mapPixelWidth <= screenWidth then
    camX = mapPixelWidth / 2
  else
    camX = math.max(halfW, math.min(cursor.pixelX, mapPixelWidth - halfW))
  end

  if mapPixelHeight <= screenHeight then
    camY = mapPixelHeight / 2
  else
    camY = math.max(halfH, math.min(cursor.pixelY, mapPixelHeight - halfH))
  end

  cam:lookAt(math.floor(camX), math.floor(camY))
end
