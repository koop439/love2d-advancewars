local ui = require("mechanics/ui")  -- <<<<<< Added this to fix ui nil

local pending_spawn = nil

local default_spawn = function(self, x, y, color)
  self.x = x
  self.y = y
  self.color = color
end

local capital_ui = function(self, loveframes)
  local frame = loveframes.Create("frame")
  frame:SetName("Buildings")
  frame:SetSize(200, 300)
  local screenWidth, screenHeight = love.graphics.getDimensions()
  frame:SetPos(screenWidth - frame:GetWidth() - 10, screenHeight - frame:GetHeight() - 10)

  local list = loveframes.Create("list", frame)
  list:SetPos(5, 30)
  list:SetSize(190, 265)
  list:SetPadding(5)
  list:SetSpacing(5)

  -- Example: Add Shotgun Button with cost display
  local button = loveframes.Create("button")
  local troop = require("data.troops").shotgun -- Require troops here to avoid globals
  button:SetText("Spawn Shotgun ($" .. tostring(troop.cost) .. ")")
  button:SetHeight(30)

  -- Create panel and add a text object inside it
  local stats_panel = loveframes.Create("panel")
  stats_panel:SetSize(180, 100)
  stats_panel:SetPos(10, 10)
  stats_panel:SetVisible(false)

  local stats_text = loveframes.Create("text", stats_panel)
  stats_text:SetPos(5, 5)

  -- Function to update the text with troop stats
  local function updateStats()
    stats_text:SetText(
      "Damage: " .. troop.damage .. "\n" ..
      "Health: " .. troop.health .. "\n" ..
      "Range: " .. troop.range .. "\n" ..
      "Movement: " .. troop.movement
    )
  end
  updateStats()

  -- Show/hide panel on hover
  button.OnHover = function()
    stats_panel:SetVisible(true)
  end
  button.OnLeave = function()
    stats_panel:SetVisible(false)
  end

  -- Spawn action, check for money before spawning
  button.OnClick = function()
    if ui.resources.money >= troop.cost then
      print("Preparing to spawn shotgun")
      pending_spawn = troop
    else
      print("Not enough money!")
      pending_spawn = nil
    end
  end

  list:AddItem(button)
end

local towers = {}

towers.capital = {
  x = 0,
  y = 0,
  color = nil,
  health = 10,
  range = 3,
  spawn = default_spawn,
  has_ui = false,
  ui = capital_ui,
  selected = false,
}

return towers
