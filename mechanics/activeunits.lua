local active_units = {}

local unit_mt = {}
unit_mt.__index = unit_mt

function unit_mt:new(x, y, sprite, draw_fn, update_fn)
  local obj = {
    x = x,
    y = y,
    sprite = sprite,
    draw = draw_fn,
    update = update_fn,
  }
  return setmetatable(obj, unit_mt)
end

function active_units.spawn(unit, x, y)
  unit.x = x
  unit.y = y
  table.insert(active_units, unit)
end

function active_units.draw_all()
  for _, unit in ipairs(active_units) do
    unit:draw()
  end
end

function active_units.update_all(dt)
  for _, unit in ipairs(active_units) do
    unit:update(dt)
  end
end

return active_units
