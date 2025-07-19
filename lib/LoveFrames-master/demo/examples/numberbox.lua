local example = {}
example.title = "Numberbox"
example.category = "Object Demonstrations"

function example.func(loveframes, centerarea)
	
	local frame = loveframes.Create("frame")
	frame:SetName("Numberbox")
	frame:SetSize(210, 90)
	frame:CenterWithinArea(unpack(centerarea))
		
	local numberbox = loveframes.Create("numberbox", frame)
	numberbox:SetPos(5, 30)
	numberbox:SetSize(200, 25)
	
	local togglebutton = loveframes.Create("button", frame)
	togglebutton:SetPos(5, 60)
	togglebutton:SetWidth(200)
	togglebutton:SetText("Toggle Padding")
	togglebutton.OnClick = function(object)
		numberbox:SetPad(not numberbox:GetPad())
	end
end

return example