local function loadImage(path)
  local img = love.graphics.newImage(path)
  img:setFilter("nearest", "nearest")
  return img
end

local cursor = {
  tileX = 20,
  tileY = 21,
  pixelX = 0,
  pixelY = 0,
  cooldown = 0.1,
  timer = 0,
  image = loadImage("assets/cursor.png"),
}

function cursor.update(dt)
  cursor.timer = cursor.timer - dt

  if cursor.timer <= 0 then
    local moved = false

    local tileW = map.tilewidth
    local tileH = map.tileheight

    local maxX = math.max(0, map.width - 1)
    local maxY = math.max(0, map.height - 1)

    if love.keyboard.isDown("a") and cursor.tileX > 0 then
      cursor.tileX = cursor.tileX - 1
      moved = true
    end
    if love.keyboard.isDown("d") and cursor.tileX < maxX then
      cursor.tileX = cursor.tileX + 1
      moved = true
    end
    if love.keyboard.isDown("w") and cursor.tileY > 0 then
      cursor.tileY = cursor.tileY - 1
      moved = true
    end
    if love.keyboard.isDown("s") and cursor.tileY < maxY then
      cursor.tileY = cursor.tileY + 1
      moved = true
    end

    if moved then
      cursor.timer = cursor.cooldown
    end
  end

  cursor.pixelX = cursor.tileX * map.tilewidth
  cursor.pixelY = cursor.tileY * map.tileheight
end

function cursor.draw()
  love.graphics.draw(cursor.image, cursor.pixelX, cursor.pixelY)
end

return cursor
