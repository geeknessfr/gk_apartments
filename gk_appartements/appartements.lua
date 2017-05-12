------- Add appartments and their positions here

appartements = {
	{ 
		ext = {name = "Milton Drive", x = -775.17, y = 312.01, z = 84.658, h = 183.14},
		appts = {
			{name = "Floor 1", x = -774.67, y = 331.566, z = 158.981, h = 351.82},  --- ONE appartment by line, position : x, y, z and h for heading direction !
			{name = "Floor 2", x = -774.168, y = 331.165, z = 206.611, h = 351.82},
			{name = "Floor 3", x = -785.304, y = 323.667, z = 210.987, h = 268.62}
		}
	}
}



local nameTimer = 0
local nameOnScreen = false
local nameText = ""

function ShowHelp(text)
	Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayHelp(0, false, 1, 0)
end

function DrawSub(text)
	SetTextFont(1)
	SetTextScale(0.7, 0.7)
	SetTextColour(255, 255, 255, 255)
	SetTextWrap(0.2,  0.8)
	SetTextCentre(1)
	SetTextOutline(true)
	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.8, 0.9)
end

function Teleport(x, y, z, h)
	local e = GetPlayerPed(-1)
	DoScreenFadeOut(800)
	while not IsScreenFadedOut() do
		Wait(10)
	end
	SetEntityCoordsNoOffset(e, x + 0.0, y + 0.0, z + 1.5, 0, 0, 1)
	SetEntityHeading(e, h + 0.0)
	Wait(500)
	DoScreenFadeIn(800)
	while not IsScreenFadedIn() do
		Wait(10)
	end
end

function ShowName(name)
	nameText = name
	nameTimer = GetGameTimer() + 5000
	nameOnScreen = true
end


AddEventHandler("appt:teleport", function(apid, id)
	Teleport(appartements[apid].appts[id].x, appartements[apid].appts[id].y, appartements[apid].appts[id].z, appartements[apid].appts[id].h)
	ShowName(appartements[apid].appts[id].name)
end)

Citizen.CreateThread(function()

	while true do
		Citizen.Wait(1)
		local pedPos = GetEntityCoords(GetPlayerPed(-1), 0)
		for id=1, #appartements do

			-- Immeuble

			local dist_ext = GetDistanceBetweenCoords(appartements[id].ext.x + 0.0, appartements[id].ext.y + 0.0, appartements[id].ext.z + 0.5, pedPos, true)
			if dist_ext < 15 then-- Test de distance pour afficher le marqueur. (Qu'on ne le voit pas de loin)
				if dist_ext <= 0.9 then -- Distance Interne Marqueur pour déclencher la téléportation
					ShowHelp("Appuyez sur ~INPUT_VEH_HORN~ pour entrer.")
					if IsControlJustReleased(0, 86) then
						if #appartements[id].appts == 1 then
							Teleport(appartements[id].appts[1].x, appartements[id].appts[1].y, appartements[id].appts[1].z, appartements[id].appts[1].h)
							ShowName(appartements[id].appts[1].name)
						else
							ShowMenu(id, appartements[id].appts)
						end
					end
				end
				-- Affiche le marqueur. (A commenter si pas besoin du marqueur affiché.)
				DrawMarker(1, appartements[id].ext.x + 0.0, appartements[id].ext.y + 0.0, appartements[id].ext.z + 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 0.5, 0, 160, 255, 60, 0, 0, 2, 0, 0, 0, 0)
			end

			if dist_ext < 1.9 and dist_ext > 1.2 then
				CloseMenu()
			end
			-- Etages d'immeuble

			local appts = appartements[id].appts
			for appt=1, #appts do
				local dist_in = GetDistanceBetweenCoords(appts[appt].x + 0.0, appts[appt].y + 0.0, appts[appt].z + 0.5, pedPos, true)
				if dist_in < 8 then -- Test de distance pour afficher le marqueur. (Qu'on ne le voit pas de loin)
					if dist_in <= 1.3 then -- Distance Interne Marqueur pour déclencher la téléportation
						ShowHelp("Appuyez sur ~INPUT_VEH_HORN~ pour sortir.")
						if IsControlJustReleased(0, 86) then
							Teleport(appartements[id].ext.x, appartements[id].ext.y, appartements[id].ext.z, appartements[id].ext.h)
							ShowName(appartements[id].ext.name)
						end
					end
					-- Affiche le marqueur. (A commenter si pas besoin du marqueur affiché.)
					DrawMarker(1, appts[appt].x + 0.0, appts[appt].y + 0.0, appts[appt].z + 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.4, 2.4, 0.5, 0, 160, 255, 90, 0, 0, 2, 0, 0, 0, 0)
				end
			end
		end

		if nameOnScreen then
			if GetGameTimer() < nameTimer then
				DrawSub(nameText)
			else
				nameOnScreen = false
			end
		end

	end

end)

