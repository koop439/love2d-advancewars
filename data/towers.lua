local troops       = require("data/troops")
local ui           = require("mechanics/ui")
local tools        = require("mechanics/tools")
local buildingMgr  = require("mechanics/activeUnits")

local show_preview, can_spawn = false, false
local spawn_gid, spawn_key, spawn_color

local function default_spawn(self, x, y, color)
  self.x, self.y, self.color = x, y, color
end

local function capital_ui(self, loveframes)
  local frame = loveframes.Create("frame")
  frame:SetName("Buildings")
  frame:SetSize(200, 300)

  local sw, sh = love.graphics.getDimensions()
  frame:SetPos(sw - frame:GetWidth() - 10, sh - frame:GetHeight() - 10)

  local list = loveframes.Create("list", frame)
  list:SetPos(5, 30)
  list:SetSize(190, 265)
  list:SetPadding(5)
  list:SetSpacing(5)

  local button = loveframes.Create("button")
  button:SetText("Spawn Shotgun")
  button:SetHeight(30)
  button.OnClick = function()
    if ui.resources.money >= troops.shotgun.cost then
      can_spawn    = true
      show_preview = true
      spawn_gid    = troops.shotgun.gid
      spawn_key    = "shotgun"
      spawn_color  = self.color
    else
      -- flash “Not enough money”
    end
  end
  list:AddItem(button)
end

local towers = {}

towers.capital = {
  x        = 0,
  y        = 0,
  color    = "gray",
  range    = 3,
  has_ui   = false,
  ui       = capital_ui,
  selected = false,
  spawn    = default_spawn,
}

function towers.drawpreview()
  if show_preview then
    tools.preview(spawn_gid, spawn_color)
  end
end

function towers.update()
  if can_spawn then
    local valid = buildingMgr.get_valid_spawn_tiles(
      towers.capital.x, towers.capital.y, towers.capital.range, selectable_lookup
    )
    tools.spawn(valid, spawn_key, spawn_gid, spawn_color, true)
    can_spawn    = false
    show_preview = false
  end
end

return towers
