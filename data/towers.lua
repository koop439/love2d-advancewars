local troops = require("data/troops")
local ui = require("mechanics/ui")
local tools = require("mechanics/tools")
local default_spawn = function(self, x, y, color)
	self.x = x
	self.y = y
	self.color = color
end

 show_preview = false
local id = nil
local capital_color = nil
local troop = nil
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
      button.OnClick = function(color)
    	print("Preparing to spawn shotgun")
    if ui.resources.money - troops.shotgun.cost >= 0 then
      enough_money = true
    end
    show_preview = true
    id = troops.shotgun.gid
    capital_color = towers.capital.color
    troop = "shotgun"
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
end


function towers.update()
if can_spawn then 
    tools.spawn(get_valid_spawn_tiles(towers.capital.x, towers.capital.y, towers.capital.range,selectable_lookup ), troop, id, capital_color)
    end
end

return towers 


