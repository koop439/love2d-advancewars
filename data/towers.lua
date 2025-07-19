local default_spawn = function(self, x, y, color)
	self.x = x
	self.y = y
	self.color = color
end
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
    pending_spawn = troops.shotgun
  end
			list:AddItem(button)
		end
towers = {}

towers.capital = {
	x = 0,
	y = 0,
	color = nil,
	health = 10,
	range = 100,
	spawn = default_spawn,
  has_ui = false,
	ui = capital_ui,

	selected = false,
}


return towers 
