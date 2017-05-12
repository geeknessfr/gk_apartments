

--- ////// NE RIEN TOUCHER ICI /////// ---


local VMenu = {
	keys = {172, 173, 191, 194},
	top = 0.01,
	left = 0.01,
	width = 0.22,

	apptid = 0,
	LoadFinish = false,
	visible = false,
	curItem = 1,
	scroll = 0,
	offsetY = 0.03,
	HdHeight = 0,
	BgHeight = 0.314,
	HeaderDict = "commonmenu",
	disableKeys = { 19, 20, 37, 38, 43, 44, 48, 55, 68, 69, 73, 74, 76, 89, 90, 102, 117, 118, 133, 134, 152, 153, 183, 185, 205, 206, 211, 213, 226, 227, 300, 187, 233, 299, 309, 311, 85, 21, 121, 45, 80, 140, 170, 177, 194, 202, 225, 263}
}
VMenu.ctop = ((VMenu.width / 2) / 2) + VMenu.top
VMenu.cleft = (VMenu.width / 2) + VMenu.left
VMenu.TextX = VMenu.left + 0.01
VMenu.BgY = VMenu.top + VMenu.HdHeight + (VMenu.BgHeight / 2)
local screenW = 100
local screenH = 100
local Menu = {}
local MenuTitle = "Appartements"

function getX(val)
	local arn = 1920/1080
	local ar = GetAspectRatio()
	local conv = arn / ar
	if ar > arn then
		local offsetpx = (screenW / 2) - ((screenH * arn) / 2)
		local offset = offsetpx * (1 / screenW)
		return (val*conv) + offset
	end
	return (val*conv)
end

function getW(val)
	local ar = GetAspectRatio()
	local arn = 1920/1080
	local conv = arn / ar
	return (val*conv)
end

function VMenu.DrawText(Text, X, Y, ScX, ScY, Font, Outline, Shadow, Center, RightJustify, R, G, B, A)
	SetTextFont(Font)
	SetTextScale(ScY, ScY)
	SetTextColour(R, G, B, A)
	if Outline then
		SetTextOutline()
	end
	if Shadow then
		SetTextDropShadow()
	end
	SetTextProportional(false)
	SetTextCentre(Center)
	if RightJustify then
		SetTextRightJustify(true)
	else
		SetTextRightJustify(false)
	end
	BeginTextCommandWidth("STRING")
	AddTextComponentSubstringPlayerName(Text)
	EndTextCommandDisplayText(X, Y)
	local width = Citizen.InvokeNative(0x85F061DA64ED2F67, false, Citizen.ResultAsFloat())
	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(Text)
	EndTextCommandDisplayText(X, Y)
	return width
end

function VMenu.DrawBg(td)
	local numItems = #Menu
	VMenu.BgHeight = numItems * VMenu.offsetY + 0.05
	VMenu.BgY = VMenu.top + VMenu.HdHeight + (VMenu.BgHeight / 2)
	DrawSprite(td, "gradient_bgd", getX(VMenu.cleft), VMenu.BgY , getW(VMenu.width), VMenu.BgHeight, 0.0, 255, 255, 255, 255)
end
function VMenu.DrawItems(td)
	local curItem = VMenu.curItem
	local numItems = #Menu
	local menuTitle = string.upper(MenuTitle)
	local count = tostring(curItem) .. "/" .. tostring(numItems)
	local footerY = VMenu.BgY + (VMenu.BgHeight / 2)
	local tWidth

	VMenu.DrawText(menuTitle, getX(VMenu.TextX), VMenu.top + VMenu.HdHeight + 0.005, 0.30, 0.33, 8, false, false, false, false, 255, 255, 255, 255)
	VMenu.DrawText(count, getX((VMenu.left + VMenu.width) - 0.03), VMenu.top + VMenu.HdHeight + 0.005, 0.30, 0.33, 8, false, false, false, false, 255, 255, 255, 255)

	for i = 1, numItems do
		local itemTitle = Menu[i]

		if i == curItem then
			DrawSprite(td, "gradient_nav", getX(VMenu.cleft), VMenu.top + VMenu.HdHeight + 0.064 + (VMenu.offsetY * (i-1-VMenu.scroll)), getW(VMenu.width), 0.03, 0.0, 255, 255, 255, 255)
			tWidth = VMenu.DrawText(itemTitle, getX(VMenu.TextX), VMenu.top + VMenu.HdHeight + 0.050 + (VMenu.offsetY * (i-1-VMenu.scroll)), 0.30, 0.33, 8, false, false, false, false, 0, 0, 0, 255)
		else
			tWidth = VMenu.DrawText(itemTitle, getX(VMenu.TextX), VMenu.top + VMenu.HdHeight + 0.050 + (VMenu.offsetY * (i-1-VMenu.scroll)), 0.30, 0.33, 8, false, false, false, false, 255, 255, 255, 255)
		end
	end
	DrawRect(getX(VMenu.cleft), footerY + 0.015, getW(VMenu.width), 0.025, 0, 0, 0, 160);
	DrawSprite(td, "shop_arrows_upanddown", getX(VMenu.cleft), footerY + 0.015, getW(0.02), 0.03, 0.0, 255, 255, 255, 255)
end

function VMenu.k_down()
	VMenu.curItem = VMenu.curItem + 1;
	if VMenu.curItem > #Menu then
		VMenu.curItem = 1
	end
	PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
end

function VMenu.k_up()
	VMenu.curItem = VMenu.curItem - 1;
	if VMenu.curItem < 1 then
		VMenu.curItem = #Menu
	end
	PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
end
function VMenu.valid()
	TriggerEvent("appt:teleport", VMenu.apptid, VMenu.curItem)
	CloseMenu()
	PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
end
function VMenu.back()
	CloseMenu()
	PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
end

function VMenu.test_keys()
	Citizen.CreateThread(function()
		while true do
			Wait(5)
			if VMenu.visible then
				if IsControlJustReleased(0, VMenu.keys[1]) then
					VMenu.k_up() 
				elseif IsControlJustReleased(0, VMenu.keys[2]) then
					VMenu.k_down()
				elseif IsControlJustReleased(0, VMenu.keys[3]) then
					VMenu.valid()
				elseif IsControlJustReleased(0, VMenu.keys[4]) then
					VMenu.back()
				end
			end
		end
	end)
end

function VMenu.Show()
	if VMenu.visible then
		HideHelpTextThisFrame()
		local td = VMenu.HeaderDict
		if not HasStreamedTextureDictLoaded(td) then
			RequestStreamedTextureDict(td, true)
			while not HasStreamedTextureDictLoaded(td) do
				Wait(10)
			end
		end
		VMenu.DrawBg(td)
		VMenu.DrawItems(td)
	end
end

function ShowMenu(id, appts)
	VMenu.apptid = id
	VMenu.curItem = 1
	Menu = {}
	for i=1, #appts do
		Menu[i] = appts[i].name
	end
	screenW, screenH = GetActiveScreenResolution()
	VMenu.visible = true
end

function CloseMenu()
	VMenu.visible = false
end

Citizen.CreateThread(function()
	Citizen.Trace("Manu Started !")
	while true do
		Wait(1)

		VMenu.Show()
	end
end)


VMenu.test_keys()