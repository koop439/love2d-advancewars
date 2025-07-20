local active_units = {}
active_units.list = {}

function active_units.spawn(u)
  table.insert(active_units.list, u)
end

function active_units.draw_all()
  for _, u in ipairs(active_units.list) do
    love.graphics.draw(u.img, u.tile.quad, u.x, u.y)
  end
end

function active_units.update_all(dt)
  for _, u in ipairs(active_units.list) do
    if u.update then u:update(dt) end
  end
end

return active_units
