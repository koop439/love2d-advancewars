local troops        = require("data/troops")
local ui            = require("mechanics/ui")
local tools         = require("mechanics/tools")

local default_spawn = function(self, x, y, color)
  self.x, self.y, self.color = x, y, color
end

local show_preview, enough_money, can_spawn = false, false, false
local id, troop_key, capital_color

local capital_ui =  function(self, loveframes)
		local frame = loveframes.Create("frame")
		frame:SetName("Buildings")
		frame:SetSize(200, 300)

		-- anchor to bottom-right
		local screenWidth, screenHeight = love.graphics.getDimensions()
		local frameX = screenWidth - frame:GetWidth() - 10
		local frameY = screenHeight - frame:GetHeight() - 10
		frame:SetPos(frameX, frameY)

		local list = loveframes.Create("list", frame)
		list:SetPos(5, 30)
		list:SetSize(190, 265) -- 5px padding all around
		list:SetPadding(5)
		list:SetSpacing(5)

		-- Add 20 buttons to the list
			local button = loveframes.Create("button")
			button:SetText("Spawn Shotgun")
			button:SetHeight(30) 
      button.OnClick = function()
  enough_money = (ui.resources.money >= troops.shotgun.cost)
  if not enough_money then return end

  show_preview    = true
  can_spawn       = true
  id              = troops.shotgun.gid
  troop_key       = "shotgun"
  capital_color   = towers.capital.color
end

			list:AddItem(button)
		end
towers = {}

towers.capital = {
	x = 0,
	y = 0,
	color = "grey",
	health = 10,
	range = 100,
	spawn = default_spawn,
  has_ui = false,
	ui = capital_ui,

	selected = false,
}


function towers.drawpreview()
  if show_preview then
    tools.preview(id, capital_color)
  end
  if can_spawn then
    tools.draw()
  end
end

local function get_valid_spawn_tiles(origin_x, origin_y, range, selectable)
  local valid = {}
  for dy = -range, range do
    for dx = -range, range do
      local tx, ty = origin_x + dx, origin_y + dy
      if (dx~=0 or dy~=0)
        and selectable[ty] and selectable[ty][tx]
      then
        table.insert(valid, { x=tx, y=ty })
      end
    end
  end
  return valid
end

function towers.update()
  if not can_spawn then return end

  local tiles = get_valid_spawn_tiles(
    towers.capital.x,
    towers.capital.y,
    towers.capital.range,
    selectable_lookup
  )

  -- Attempt spawn; this will deduct money & add to active_troops
  tools.spawn(tiles, troop_key, id, capital_color, enough_money)

  -- Reset flags
  can_spawn    = false
  show_preview = false
end
return towers 


