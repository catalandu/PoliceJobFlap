local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PlayerData              = {}
local HasAlreadyEnteredMarker = false
local LastStation             = nil
local LastPart                = nil
local LastPartNum             = nil
local LastEntity              = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local IsHandcuffed            = false
local HandcuffTimer           = {}
local DragStatus              = {}
DragStatus.IsDragged          = false
local hasAlreadyJoined        = false
local isDead                  = false
local CurrentTask             = {}
local playerInService         = false
local haveKey                 = false
local blipsCops               = {}
local near                    = false
local waitTime                = 500

ESX                           = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent(Config.ESXtrigger, function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	
	Citizen.Wait(5000)
	TriggerServerEvent('flap_police_job:forceBlip')
end)

-- don't show dispatches if the player isn't in service
AddEventHandler('esx_phone:cancelMessage', function(dispatchNumber)
	if type(PlayerData.job.name) == 'string' and PlayerData.job.name == 'police' and PlayerData.job.name == dispatchNumber then
		-- if esx_service is enabled
		if Config.MaxInService ~= -1 and not playerInService then
			CancelEvent()
		end
	end
end)

AddEventHandler('flap_police_job:hasEnteredMarker', function(station, part, partNum)

	if part == 'Cloakroom' then
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = ""
		CurrentActionData = {}

	elseif part == 'Keys' then

		CurrentAction     = 'menu_keys'
		CurrentActionMsg  = ''
		CurrentActionData = {station = station}

	elseif part == 'Armory' then

		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}

	elseif part == 'VehicleSpawner' then

		CurrentAction     = 'menu_vehicle_spawner'
		CurrentActionMsg  = _U('vehicle_spawner')
		CurrentActionData = {station = station, partNum = partNum}

	elseif part == 'HelicopterSpawner' then

		CurrentAction     = 'helicopter_spawner'
		CurrentActionMsg  = ""
		CurrentActionData = {station = station, partNum = partNum}

	elseif part == 'HelicopterDespawn' then

		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(playerPed,  false) then

			local vehicle = GetVehiclePedIsIn(playerPed, false)

			if DoesEntityExist(vehicle) then
				CurrentAction     = 'delete_hel'
				CurrentActionMsg  = ''
				CurrentActionData = {vehicle = vehicle}
			end
		end

	elseif part == 'VehicleDeleter' then

		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(playerPed,  false) then

			local vehicle = GetVehiclePedIsIn(playerPed, false)

			if DoesEntityExist(vehicle) then
				CurrentAction     = 'delete_vehicle'
				CurrentActionMsg  = ''
				CurrentActionData = {vehicle = vehicle}
			end

		end

	elseif part == 'BossActions' then

		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = _U('open_bossmenu')
		CurrentActionData = {}

	end

end)

AddEventHandler('flap_police_job:hasExitedMarker', function(station, part, partNum)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

AddEventHandler('flap_police_job:hasEnteredEntityZone', function(entity)
	local playerPed = PlayerPedId()

	if PlayerData.job ~= nil and PlayerData.job.name == 'police' and IsPedOnFoot(playerPed) then
		CurrentAction     = 'remove_entity'
		CurrentActionMsg  = _U('remove_prop')
		CurrentActionData = {entity = entity}
	end

	if GetEntityModel(entity) == GetHashKey('p_ld_stinger_s') then
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed)

			for i=0, 7, 1 do
				SetVehicleTyreBurst(vehicle, i, true, 1000)
			end
		end
	end
end)

AddEventHandler('flap_police_job:hasExitedEntityZone', function(entity)
	if CurrentAction == 'remove_entity' then
		CurrentAction = nil
	end
end)

Citizen.CreateThread(function()
	local playerPed
	local targetPed

	while true do
		Citizen.Wait(1)

		if IsHandcuffed then
			playerPed = PlayerPedId()

			if DragStatus.IsDragged then
				targetPed = GetPlayerPed(GetPlayerFromServerId(DragStatus.CopId))

				-- undrag if target is in an vehicle
				if not IsPedSittingInAnyVehicle(targetPed) then
					AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				else
					DragStatus.IsDragged = false
					DetachEntity(playerPed, true, false)
				end

			else
				DetachEntity(playerPed, true, false)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- Handcuff
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local playerPed = PlayerPedId()

		if IsHandcuffed then
			DisableControlAction(0, 1, true) -- Disable pan
			DisableControlAction(0, 2, true) -- Disable tilt
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			DisableControlAction(0, Keys['W'], true) -- W
			DisableControlAction(0, Keys['A'], true) -- A
			DisableControlAction(0, 31, true) -- S (fault in Keys table!)
			DisableControlAction(0, 30, true) -- D (fault in Keys table!)

			DisableControlAction(0, Keys['R'], true) -- Reload
			DisableControlAction(0, Keys['SPACE'], true) -- Jump
			DisableControlAction(0, Keys['Q'], true) -- Cover
			DisableControlAction(0, Keys['TAB'], true) -- Select Weapon
			DisableControlAction(0, Keys['F'], true) -- Also 'enter'?

			DisableControlAction(0, Keys['F1'], true) -- Disable phone
			DisableControlAction(0, Keys['F2'], true) -- Inventory
			DisableControlAction(0, Keys['F3'], true) -- Animations
			DisableControlAction(0, Keys['F6'], true) -- Job

			DisableControlAction(0, Keys['V'], true) -- Disable changing view
			DisableControlAction(0, Keys['C'], true) -- Disable looking behind
			DisableControlAction(0, Keys['X'], true) -- Disable clearing animation
			DisableControlAction(2, Keys['P'], true) -- Disable pause screen

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, Keys['LEFTCTRL'], true) -- Disable going stealth

			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
			if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
				end)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- Enter / Exit marker events

Citizen.CreateThread(function()
	while true do
		Wait(700)

		if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
			if nearMarker() then
				near = true
			else
				near = false
		    end
		else
			Wait(1000)
		end
	end
end)

Citizen.CreateThread(function()

	while true do

		Wait(10)

		if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
			if near then
				local playerPed      = PlayerPedId()
				local coords         = GetEntityCoords(playerPed)
				local isInMarker     = false
				local currentStation = nil
				local currentPart    = nil
				local currentPartNum = nil
	
				for k,v in pairs(Config.PoliceStations) do
	
					for i=1, #v.Cloakrooms, 1 do
						if v.Cloakrooms.access[PlayerData.job.grade_name] then
							if #(coords - vector3(v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z)) < Config.showFloatingHelpTextCloakRoom then
								if haveKey then
									isInMarker     = true
									currentStation = k
									currentPart    = 'Cloakroom'
									currentPartNum = i

									ShowFloatingHelpNotification(_U("open_cloackroom", v.Cloakrooms[i].cloakroom), v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z + 1)
								else
									ShowFloatingHelpNotification(_U("dont_have_keys", v.Cloakrooms[i].cloakroom), v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z + 1)
								end
							end

							if #(coords - vector3(v.Cloakrooms.key.location.x, v.Cloakrooms.key.location.y, v.Cloakrooms.key.location.z)) < Config.showFloatingHelpText then
								isInMarker     = true
								currentStation = k
								currentPart    = 'Keys'
								currentPartNum = i

								ShowFloatingHelpNotification(_U("open_cloackroom_keys"), v.Cloakrooms.key.location.x, v.Cloakrooms.key.location.y, v.Cloakrooms.key.location.z + 2)
							end
						end
					end

					for i=1, #v.Armories, 1 do
						if v.Armories[i].access[PlayerData.job.grade_name] then
							if #(coords - vector3(v.Armories[i].ped.location.x, v.Armories[i].ped.location.y, v.Armories[i].ped.location.z)) < Config.showFloatingHelpText + 1 then
								isInMarker     = true
								currentStation = k
								currentPart    = 'Armory'
								currentPartNum = i

								ShowFloatingHelpNotification(v.Armories[i].ped.text, v.Armories[i].ped.location.x, v.Armories[i].ped.location.y, v.Armories[i].ped.location.z + 1.9)
							end
						end
					end
	
					for i=1, #v.Vehicles, 1 do
						if v.Vehicles[i].access[PlayerData.job.grade_name] then
							if #(coords - vector3(v.Vehicles[i].ped.location.x, v.Vehicles[i].ped.location.y, v.Vehicles[i].ped.location.z)) < Config.showFloatingHelpText then
								isInMarker     = true
								currentStation = k
								currentPart    = 'VehicleSpawner'
								currentPartNum = i

								ShowFloatingHelpNotification(v.Vehicles[i].ped.text, v.Vehicles[i].ped.location.x, v.Vehicles[i].ped.location.y, v.Vehicles[i].ped.location.z + 1.9)
							end
						end
					end
	
					for i=1, #v.Helicopters, 1 do
						if v.Helicopters[i].access[PlayerData.job.grade_name] then
							if #(coords - vector3(v.Helicopters[i].ped.location.x, v.Helicopters[i].ped.location.y, v.Helicopters[i].ped.location.z)) < Config.showFloatingHelpText then
								isInMarker     = true
								currentStation = k
								currentPart    = 'HelicopterSpawner'
								currentPartNum = i
								ShowFloatingHelpNotification(v.Helicopters[i].ped.text, v.Helicopters[i].ped.location.x, v.Helicopters[i].ped.location.y, v.Helicopters[i].ped.location.z + 1.9)
							end

							if #(coords - vector3(v.Helicopters[i].DeletePoints[i].x, v.Helicopters[i].DeletePoints[i].y, v.Helicopters[i].DeletePoints[i].z)) < Config.showFloatingHelpText then
								isInMarker     = true
								currentStation = k
								currentPart    = 'HelicopterDespawn'
								currentPartNum = i
								if IsPedInAnyVehicle(PlayerPedId(),  false) then
									ShowFloatingHelpNotification(_U("helicopter_despawn"), v.Helicopters[i].DeletePoints[i].x, v.Helicopters[i].DeletePoints[i].y, v.Helicopters[i].DeletePoints[i].z + 1.9)
								else
									ShowFloatingHelpNotification(_U("must_be_in_hel"), v.Helicopters[i].DeletePoints[i].x, v.Helicopters[i].DeletePoints[i].y, v.Helicopters[i].DeletePoints[i].z + 1.9)
								end
							end
						end
					end
	
					for i=1, #v.VehicleDeleters, 1 do
						if v.VehicleDeleters.access[PlayerData.job.grade_name] then
							if #(coords - vector3(v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z)) < Config.showFloatingHelpText + 1 then
								isInMarker     = true
								currentStation = k
								currentPart    = 'VehicleDeleter'
								currentPartNum = i

								if IsPedInAnyVehicle(PlayerPedId(),  false) then
									ShowFloatingHelpNotification(_U("store_veh", v.VehicleDeleters[i].place), v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z + 1)
								else
									ShowFloatingHelpNotification(_U("must_be_in_veh", v.VehicleDeleters[i].place), v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z + 1)
								end
							end
						end
					end

					for i=1, #v.BossActions, 1 do
						if v.BossActions.access[PlayerData.job.grade_name] then
							if #(coords - vector3(v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z)) < Config.showFloatingHelpText + 1 then
								isInMarker     = true
								currentStation = k
								currentPart    = 'BossActions'
								currentPartNum = i

								ShowFloatingHelpNotification(v.BossActions[i].text, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z + 1)
							end
						end
					end
	
				end
	
				local hasExited = false
	
				if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
	
					if
						(LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
						(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
					then
						TriggerEvent('flap_police_job:hasExitedMarker', LastStation, LastPart, LastPartNum)
						hasExited = true
					end
	
					HasAlreadyEnteredMarker = true
					LastStation             = currentStation
					LastPart                = currentPart
					LastPartNum             = currentPartNum
	
					TriggerEvent('flap_police_job:hasEnteredMarker', currentStation, currentPart, currentPartNum)
				end
	
				if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
					HasAlreadyEnteredMarker = false
					TriggerEvent('flap_police_job:hasExitedMarker', LastStation, LastPart, LastPartNum)
				end
			else
				Wait(1000)
		    end
		else
			Wait(1000)
		end

	end
end)

-- Enter / Exit entity zone events
Citizen.CreateThread(function()
	local trackedEntities = {
		'prop_roadcone02a',
		'prop_barrier_work05',
		'p_ld_stinger_s',
		'prop_boxpile_07d',
		'hei_prop_cash_crate_half_full'
	}

	while true do
		Citizen.Wait(500)

		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		local closestDistance = -1
		local closestEntity   = nil

		for i=1, #trackedEntities, 1 do
			local object = GetClosestObjectOfType(coords.x, coords.y, coords.z, 3.0, GetHashKey(trackedEntities[i]), false, false, false)

			if DoesEntityExist(object) then
				local objCoords = GetEntityCoords(object)
				local distance  = #(coords - vector3(objCoords.x, objCoords.y, objCoords.z))

				if closestDistance == -1 or closestDistance > distance then
					closestDistance = distance
					closestEntity   = object
				end
			end
		end

		if closestDistance ~= -1 and closestDistance <= 3.0 then
			if LastEntity ~= closestEntity then
				TriggerEvent('flap_police_job:hasEnteredEntityZone', closestEntity)
				LastEntity = closestEntity
			end
		else
			if LastEntity ~= nil then
				TriggerEvent('flap_police_job:hasExitedEntityZone', LastEntity)
				LastEntity = nil
			end
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(10)

		if PlayerData.job ~= nil and PlayerData.job.name == 'police' then

		    if CurrentAction ~= nil then
				if IsControlJustReleased(0, Keys['E']) then

					if CurrentAction == 'menu_cloakroom' then
						--OpenCloakroomMenu()
						OpenCloakroomNUI()
					elseif CurrentAction == 'menu_keys' then
						OpenCloakroomKeysNUI()
					elseif CurrentAction == 'menu_armory' then
						if Config.MaxInService == -1 then
							--OpenArmoryMenu(CurrentActionData.station)
							OpenArmoryNUI()
						elseif playerInService then
							--OpenArmoryMenu(CurrentActionData.station)
							OpenArmoryNUI()
						else
							ESX.ShowNotification(_U('service_not'))
						end
					elseif CurrentAction == 'menu_vehicle_spawner' then
						OpenGarageNUI()
					elseif CurrentAction == 'helicopter_spawner' then
						OpenHelicoptersNUI()
					elseif CurrentAction == 'delete_hel' then
						parkingHel(CurrentActionData.vehicle)
					elseif CurrentAction == 'delete_vehicle' then
						parkingCar(CurrentActionData.vehicle)
					elseif CurrentAction == 'menu_boss_actions' then
						OpenBossMenuNUI()
					elseif CurrentAction == 'remove_entity' then
						DeleteEntity(CurrentActionData.entity)
					end
					CurrentAction = nil
				end
			end

			if IsControlJustReleased(0, Keys['F6']) and not isDead and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'police_actions') then
				if Config.MaxInService == -1 then
					OpenPoliceActionsMenu()
				elseif playerInService then
					OpenPoliceActionsMenu()
				else
					ESX.ShowNotification(_U('service_not'))
				end
			end

			if IsControlJustReleased(0, Keys['E']) and CurrentTask.Busy then
				ESX.ShowNotification(_U('impound_canceled'))
				ESX.ClearTimeout(CurrentTask.Task)
				ClearPedTasks(PlayerPedId())
				
				CurrentTask.Busy = false
			end
		else
			Citizen.Wait(500)
		end
	end
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
	TriggerEvent('flap_police_job:unrestrain')
	
	if not hasAlreadyJoined then
		TriggerServerEvent('flap_police_job:spawned')
	end
	hasAlreadyJoined = true
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('flap_police_job:unrestrain')
		TriggerEvent('esx_phone:removeSpecialContact', 'police')

		if Config.MaxInService ~= -1 then
			TriggerServerEvent('esx_service:disableService', 'police')
		end

		if Config.EnableHandcuffTimer and HandcuffTimer.Active then
			ESX.ClearTimeout(HandcuffTimer.Task)
		end
	end
end)

RegisterNetEvent('flap_police_job:updateBlip')
AddEventHandler('flap_police_job:updateBlip', function()
	
	-- Refresh all blips
	for k, existingBlip in pairs(blipsCops) do
		RemoveBlip(existingBlip)
	end
	
	-- Clean the blip table
	blipsCops = {}

	-- Enable blip?
	if Config.MaxInService ~= -1 and not playerInService then
		return
	end

	if not Config.EnableJobBlip then
		return
	end
	
	-- Is the player a cop? In that case show all the blips for other cops
	if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
		ESX.TriggerServerCallback('esx_society:getOnlinePlayers', function(players)
			for i=1, #players, 1 do
				if players[i].job.name == 'police' then
					local id = GetPlayerFromServerId(players[i].source)
					if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= PlayerPedId() then
						createBlip(id)
					end
				end
			end
		end)
	end

end)

RegisterNetEvent('flap_police_job:putInVehicle')
AddEventHandler('flap_police_job:putInVehicle', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if not IsHandcuffed then
		return
	end

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)

		if DoesEntityExist(vehicle) then
			local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
			local freeSeat = nil

			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat ~= nil then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
				DragStatus.IsDragged = false
			end
		end
	end
end)

RegisterNetEvent('flap_police_job:drag')
AddEventHandler('flap_police_job:drag', function(copID)
	if not IsHandcuffed then
		return
	end

	DragStatus.IsDragged = not DragStatus.IsDragged
	DragStatus.CopId     = tonumber(copID)
end)

Citizen.CreateThread(function()	
	for k,v in pairs(Config.PoliceStations) do

		for i=1, #v.Cloakrooms, 1 do
			if not spawned then
                local basePed = {model = v.Cloakrooms.key.model, scenario = v.Cloakrooms.key.scenario, animDict = v.Cloakrooms.key.animDict, animName = v.Cloakrooms.key.animName, flag = 1, x = v.Cloakrooms.key.location.x, y = v.Cloakrooms.key.location.y, z = v.Cloakrooms.key.location.z, h = v.Cloakrooms.key.heading}
                Ped = CreateNpc(basePed)
				spawned = true
			end
		end

		for i=1, #v.Helicopters, 1 do
			if not helspawned then
                local basePed = {model = v.Helicopters[i].ped.model, scenario = v.Helicopters[i].ped.scenario, animDict = v.Helicopters[i].ped.animDict, animName = v.Helicopters[i].ped.animName, flag = 1, x = v.Helicopters[i].ped.location.x, y = v.Helicopters[i].ped.location.y, z = v.Helicopters[i].ped.location.z, h = v.Helicopters[i].ped.heading}
                Ped = CreateNpc(basePed)
				helspawned = true
			end
		end

		for i=1, #v.Vehicles, 1 do
			if not carspawned then
                local basePed = {model = v.Vehicles[i].ped.model, scenario = v.Vehicles[i].ped.scenario, animDict = v.Vehicles[i].ped.animDict, animName = v.Vehicles[i].ped.animName, flag = 1, x = v.Vehicles[i].ped.location.x, y = v.Vehicles[i].ped.location.y, z = v.Vehicles[i].ped.location.z, h = v.Vehicles[i].ped.heading}
                Ped = CreateNpc(basePed)
				carspawned = true
			end
		end

		for i=1, #v.Armories, 1 do
			if not armorspawned then
                local basePed = {model = v.Armories[i].ped.model, scenario = v.Armories[i].ped.scenario, animDict = v.Armories[i].ped.animDict, animName = v.Armories[i].ped.animName, flag = 1, x = v.Armories[i].ped.location.x, y = v.Armories[i].ped.location.y, z = v.Armories[i].ped.location.z, h = v.Armories[i].ped.heading}
                Ped = CreateNpc(basePed)
				armorspawned = true
			end
		end

		--blip
		local blip = AddBlipForCoord(v.Blip.Pos.x, v.Blip.Pos.y, v.Blip.Pos.z)
	
		SetBlipSprite (blip, v.Blip.Sprite)
		SetBlipDisplay(blip, v.Blip.Display)
		SetBlipScale  (blip, v.Blip.Scale)
		SetBlipColour (blip, v.Blip.Colour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('<FONT FACE="Fire Sans">' ..v.Blip.Name)
		EndTextCommandSetBlipName(blip)
	end
end)

RegisterNUICallback('spawnVeh', function(data, cb)
	local foundSpawnPoint, spawnPoint = GetAvailableVehicleSpawnPoint(CurrentActionData.station, CurrentActionData.partNum)
	
	if foundSpawnPoint then
	    ESX.Game.SpawnVehicle(data.model, spawnPoint, spawnPoint.heading, function(vehicle)
		    --TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
		    --TaskEnterVehicle(GetPlayerPed(-1), vehicle, 20000,-1, 1.5, 1, 0)
		    SetVehicleMaxMods(vehicle)
			SetVehicleLivery(vehicle, data.livery)
	    end)
	else
		ESX.ShowNotification(_U('vehicle_blocked'))
	end
end)

RegisterNUICallback('spawnHel', function(data, cb)

	local helicopters = Config.PoliceStations[CurrentActionData.station].Helicopters
	local partNum = CurrentActionData.partNum

	if not IsAnyVehicleNearPoint(helicopters[partNum].SpawnPoint.x, helicopters[partNum].SpawnPoint.y, helicopters[partNum].SpawnPoint.z,  3.0) then
		ESX.Game.SpawnVehicle(data.model, helicopters[partNum].SpawnPoint, helicopters[partNum].SpawnPoint.h, function(vehicle)
			SetVehicleMaxMods(vehicle)
		end)
		HelicopterSpawned()
	else
		HelipadFull()
	end
end)

RegisterNUICallback('choose_7', function(data, cb)

	OpenGarageCarsNUI()

	local sharedVehicles = Config.AuthorizedVehicles.Shared
	for i=1, #sharedVehicles, 1 do
		SendNUIMessage({
			modelLabel = sharedVehicles[i].label,
			model = sharedVehicles[i].model,
			livery = sharedVehicles[i].livery
		})
	end

	local authorizedVehicles = Config.AuthorizedVehicles[PlayerData.job.grade_name]
	for i=1, #authorizedVehicles, 1 do
		SendNUIMessage({
			modelLabel = authorizedVehicles[i].label,
			model = authorizedVehicles[i].model,
			livery = sharedVehicles[i].livery
		})
	end
	
end)

RegisterNUICallback('choose_18', function(data, cb)
	local playerPed = PlayerPedId()

	OpenHelicoptersListNUI()

	local sharedHelicopters = Config.AuthorizedHelicopters.Shared
	for i=1, #sharedHelicopters, 1 do
		SendNUIMessage({
			modelLabel = sharedHelicopters[i].label,
			model = sharedHelicopters[i].model
		})
	end

	local AuthorizedHelicopters = Config.AuthorizedHelicopters[PlayerData.job.grade_name]
	for i=1, #AuthorizedHelicopters, 1 do
		SendNUIMessage({
			modelLabel = AuthorizedHelicopters[i].label,
			model = AuthorizedHelicopters[i].model
		})
	end
	
end)

RegisterNUICallback('choose_5', function(data, cb)
	haveKey = true
end)

RegisterNUICallback('choose_6', function(data, cb)
	haveKey = false
end)

function createBlip(id)
	local ped = GetPlayerPed(id)
	local blip = GetBlipFromEntity(ped)

	if not DoesBlipExist(blip) then -- Add blip and create head display on player
		blip = AddBlipForEntity(ped)
		SetBlipSprite(blip, 1)
		SetBlipColour(blip, 3)
		SetBlipDisplay(blip, 4)
		SetBlipShowCone(blip, true)
		SetBlipAsShortRange(blip, true)
		ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
		SetBlipRotation(blip, math.ceil(GetEntityHeading(ped))) -- update rotation
		SetBlipNameToPlayerName(blip, id) -- update blip name
		SetBlipScale(blip, 0.85) -- set scale
		
		table.insert(blipsCops, blip) -- add blip to array so we can remove it later
	end
end

function nearMarker()
	local playerPed      = PlayerPedId()
	local coords         = GetEntityCoords(playerPed)

	for k,v in pairs(Config.PoliceStations) do

		for i=1, #v.Cloakrooms, 1 do
			local distanceCloakroom = #(coords - vector3(v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z))
			local distancePed = #(coords - vector3(v.Cloakrooms.key.location.x, v.Cloakrooms.key.location.y, v.Cloakrooms.key.location.z))

			if distanceCloakroom <= 3 then
				return true
			end

			if distancePed <= 3 then
				return true
			end

		end

		for i=1, #v.Armories, 1 do
			local distanceArm = #(coords - vector3(v.Armories[i].ped.location.x, v.Armories[i].ped.location.y, v.Armories[i].ped.location.z))

			if distanceArm <= 3 then
				return true
			end
		end

		for i=1, #v.Vehicles, 1 do
			local distanceVeh = #(coords - vector3(v.Vehicles[i].ped.location.x, v.Vehicles[i].ped.location.y, v.Vehicles[i].ped.location.z))

			if distanceVeh <= 3 then
				return true
			end
		end

		for i=1, #v.Helicopters, 1 do
			local distanceHelPed = #(coords - vector3(v.Helicopters[i].ped.location.x, v.Helicopters[i].ped.location.y, v.Helicopters[i].ped.location.z))
			local distanceHelDel = #(coords - vector3(v.Helicopters[i].DeletePoints[i].x, v.Helicopters[i].DeletePoints[i].y, v.Helicopters[i].DeletePoints[i].z))

			if distanceHelPed <= 3 then
				return true
			end

			if distanceHelDel <= 3 then
				return true
			end
		end

		for i=1, #v.VehicleDeleters, 1 do
			local distanceVehDel = #(coords - vector3(v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z))

			if distanceVehDel <= 3 then
				return true
			end
		end

		if v.BossActions.access[PlayerData.job.grade_name] then
			for i=1, #v.BossActions, 1 do
				local distanceBoss = #(coords - vector3(v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z))

				if distanceBoss <= 3 then
					return true
				end
			end
		end


	end
end

RegisterNetEvent('flap_police_job:handcuff')
AddEventHandler('flap_police_job:handcuff', function()
	IsHandcuffed    = not IsHandcuffed
	local playerPed = PlayerPedId()

	Citizen.CreateThread(function()
		if IsHandcuffed then

			RequestAnimDict('mp_arresting')
			while not HasAnimDictLoaded('mp_arresting') do
				Citizen.Wait(100)
			end

			TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)

			SetEnableHandcuffs(playerPed, true)
			DisablePlayerFiring(playerPed, true)
			SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
			SetPedCanPlayGestureAnims(playerPed, false)
			FreezeEntityPosition(playerPed, true)
			DisplayRadar(false)

			if Config.EnableHandcuffTimer then

				if HandcuffTimer.Active then
					ESX.ClearTimeout(HandcuffTimer.Task)
				end

				StartHandcuffTimer()
			end

		else

			if Config.EnableHandcuffTimer and HandcuffTimer.Active then
				ESX.ClearTimeout(HandcuffTimer.Task)
			end

			ClearPedSecondaryTask(playerPed)
			SetEnableHandcuffs(playerPed, false)
			DisablePlayerFiring(playerPed, false)
			SetPedCanPlayGestureAnims(playerPed, true)
			FreezeEntityPosition(playerPed, false)
			DisplayRadar(true)
		end
	end)

end)

RegisterNetEvent('flap_police_job:unrestrain')
AddEventHandler('flap_police_job:unrestrain', function()
	if IsHandcuffed then
		local playerPed = PlayerPedId()
		IsHandcuffed = false

		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		FreezeEntityPosition(playerPed, false)
		DisplayRadar(true)

		-- end timer
		if Config.EnableHandcuffTimer and HandcuffTimer.Active then
			ESX.ClearTimeout(HandcuffTimer.Task)
		end
	end
end)

function OpenPoliceActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'police_actions',
			{
				title    = 'Police',
				align    = 'top-left',
				elements = {
					{label = _U('citizen_interaction'),	value = 'citizen_interaction'},
					{label = _U('vehicle_interaction'),	value = 'vehicle_interaction'},
					{label = _U('object_spawner'),		value = 'object_spawner'}
				}
			}, function(data, menu)

				if data.current.value == 'citizen_interaction' then
					local elements = {
						{label = _U('id_card'),			value = 'identity_card'},
						{label = _U('search'),			value = 'body_search'},
						{label = _U('handcuff'),		value = 'handcuff'},
						{label = _U('drag'),			value = 'drag'},
						{label = _U('put_in_vehicle'),	value = 'put_in_vehicle'},
						{label = _U('out_the_vehicle'),	value = 'out_the_vehicle'},
						{label = _U('fine'),			value = 'fine'},
						{label = _U('unpaid_bills'),	value = 'unpaid_bills'}
					}

					if Config.EnableLicenses then
						table.insert(elements, { label = _U('license_check'), value = 'license' })
					end

					ESX.UI.Menu.Open(
							'default', GetCurrentResourceName(), 'citizen_interaction',
							{
								title    = _U('citizen_interaction'),
								align    = 'top-left',
								elements = elements
							}, function(data2, menu2)
								local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
								if closestPlayer ~= -1 and closestDistance <= 3.0 then
									local action = data2.current.value

									if action == 'identity_card' then
										OpenIdentityCardMenu(closestPlayer)
									elseif action == 'body_search' then
										TriggerServerEvent('flap_police_job:message', GetPlayerServerId(closestPlayer), _U('being_searched'))
										OpenBodySearchMenu(closestPlayer)
									elseif action == 'handcuff' then
										TriggerServerEvent('flap_police_job:handcuff', GetPlayerServerId(closestPlayer))
									elseif action == 'drag' then
										TriggerServerEvent('flap_police_job:drag', GetPlayerServerId(closestPlayer))
									elseif action == 'put_in_vehicle' then
										TriggerServerEvent('flap_police_job:putInVehicle', GetPlayerServerId(closestPlayer))
									elseif action == 'out_the_vehicle' then
										TriggerServerEvent('flap_police_job:OutVehicle', GetPlayerServerId(closestPlayer))
									elseif action == 'fine' then
										OpenFineMenu(closestPlayer)
									elseif action == 'license' then
										ShowPlayerLicense(closestPlayer)
									elseif action == 'unpaid_bills' then
										OpenUnpaidBillsMenu(closestPlayer)
									end

								else
									ESX.ShowNotification(_U('no_players_nearby'))
								end
							end, function(data2, menu2)
								menu2.close()
							end)
				elseif data.current.value == 'vehicle_interaction' then
					local elements  = {}
					local playerPed = PlayerPedId()
					local coords    = GetEntityCoords(playerPed)
					local vehicle   = ESX.Game.GetVehicleInDirection()

					if DoesEntityExist(vehicle) then
						table.insert(elements, {label = _U('vehicle_info'),	value = 'vehicle_infos'})
						table.insert(elements, {label = _U('pick_lock'),	value = 'hijack_vehicle'})
						table.insert(elements, {label = _U('impound'),		value = 'impound'})
					end

					table.insert(elements, {label = _U('search_database'), value = 'search_database'})

					ESX.UI.Menu.Open(
							'default', GetCurrentResourceName(), 'vehicle_interaction',
							{
								title    = _U('vehicle_interaction'),
								align    = 'top-left',
								elements = elements
							}, function(data2, menu2)
								coords  = GetEntityCoords(playerPed)
								vehicle = ESX.Game.GetVehicleInDirection()
								action  = data2.current.value

								if action == 'search_database' then
									LookupVehicle()
								elseif DoesEntityExist(vehicle) then
									local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
									if action == 'vehicle_infos' then
										OpenVehicleInfosMenu(vehicleData)

									elseif action == 'hijack_vehicle' then
										if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
											TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
											Citizen.Wait(20000)
											ClearPedTasksImmediately(playerPed)

											SetVehicleDoorsLocked(vehicle, 1)
											SetVehicleDoorsLockedForAllPlayers(vehicle, false)
											ESX.ShowNotification(_U('vehicle_unlocked'))
										end
									elseif action == 'impound' then

										-- is the script busy?
										if CurrentTask.Busy then
											return
										end

										ESX.ShowHelpNotification(_U('impound_prompt'))

										TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)

										CurrentTask.Busy = true
										CurrentTask.Task = ESX.SetTimeout(10000, function()
											ClearPedTasks(playerPed)
											ImpoundVehicle(vehicle)
											Citizen.Wait(100) -- sleep the entire script to let stuff sink back to reality
										end)

										-- keep track of that vehicle!
										Citizen.CreateThread(function()
											while CurrentTask.Busy do
												Citizen.Wait(1000)

												vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
												if not DoesEntityExist(vehicle) and CurrentTask.Busy then
													ESX.ShowNotification(_U('impound_canceled_moved'))
													ESX.ClearTimeout(CurrentTask.Task)
													ClearPedTasks(playerPed)
													CurrentTask.Busy = false
													break
												end
											end
										end)
									end
								else
									ESX.ShowNotification(_U('no_vehicles_nearby'))
								end

							end, function(data2, menu2)
								menu2.close()
							end)

				elseif data.current.value == 'object_spawner' then
					ESX.UI.Menu.Open(
							'default', GetCurrentResourceName(), 'citizen_interaction',
							{
								title    = _U('traffic_interaction'),
								align    = 'top-left',
								elements = {
									{label = _U('cone'),		value = 'prop_roadcone02a'},
									{label = _U('barrier'),		value = 'prop_barrier_work05'},
									{label = _U('spikestrips'),	value = 'p_ld_stinger_s'},
									{label = _U('box'),			value = 'prop_boxpile_07d'},
									{label = _U('cash'),		value = 'hei_prop_cash_crate_half_full'}
								}
							}, function(data2, menu2)
								local model     = data2.current.value
								local playerPed = PlayerPedId()
								local coords    = GetEntityCoords(playerPed)
								local forward   = GetEntityForwardVector(playerPed)
								local x, y, z   = table.unpack(coords + forward * 1.0)

								if model == 'prop_roadcone02a' then
									z = z - 2.0
								end

								ESX.Game.SpawnObject(model, {
									x = x,
									y = y,
									z = z
								}, function(obj)
									SetEntityHeading(obj, GetEntityHeading(playerPed))
									PlaceObjectOnGroundProperly(obj)
								end)

							end, function(data2, menu2)
								menu2.close()
							end)
				end

			end, function(data, menu)
				menu.close()
			end)
end

function OpenIdentityCardMenu(player)

	ESX.TriggerServerCallback('flap_police_job:getOtherPlayerData', function(data)

		local elements    = {}
		local nameLabel   = _U('name', data.name)
		local jobLabel    = nil
		local sexLabel    = nil
		local dobLabel    = nil
		local heightLabel = nil
		local idLabel     = nil

		if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
			jobLabel = _U('job', data.job.label .. ' - ' .. data.job.grade_label)
		else
			jobLabel = _U('job', data.job.label)
		end

		if Config.EnableESXIdentity then

			nameLabel = _U('name', data.firstname .. ' ' .. data.lastname)

			if data.sex ~= nil then
				if string.lower(data.sex) == 'm' then
					sexLabel = _U('sex', _U('male'))
				else
					sexLabel = _U('sex', _U('female'))
				end
			else
				sexLabel = _U('sex', _U('unknown'))
			end

			if data.dob ~= nil then
				dobLabel = _U('dob', data.dob)
			else
				dobLabel = _U('dob', _U('unknown'))
			end

			if data.height ~= nil then
				heightLabel = _U('height', data.height)
			else
				heightLabel = _U('height', _U('unknown'))
			end

			if data.name ~= nil then
				idLabel = _U('id', data.name)
			else
				idLabel = _U('id', _U('unknown'))
			end

		end

		local elements = {
			{label = nameLabel, value = nil},
			{label = jobLabel,  value = nil},
		}

		if Config.EnableESXIdentity then
			table.insert(elements, {label = sexLabel, value = nil})
			table.insert(elements, {label = dobLabel, value = nil})
			table.insert(elements, {label = heightLabel, value = nil})
			table.insert(elements, {label = idLabel, value = nil})
		end

		if data.drunk ~= nil then
			table.insert(elements, {label = _U('bac', data.drunk), value = nil})
		end

		if data.licenses ~= nil then

			table.insert(elements, {label = _U('license_label'), value = nil})

			for i=1, #data.licenses, 1 do
				table.insert(elements, {label = data.licenses[i].label, value = nil})
			end

		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction',
				{
					title    = _U('citizen_interaction'),
					align    = 'top-left',
					elements = elements,
				}, function(data, menu)

				end, function(data, menu)
					menu.close()
				end)

	end, GetPlayerServerId(player))

end

function OpenBodySearchMenu(player)

	ESX.TriggerServerCallback('flap_police_job:getOtherPlayerData', function(data)

		local elements = {}

		for i=1, #data.accounts, 1 do

			if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then

				table.insert(elements, {
					label    = _U('confiscate_dirty', ESX.Round(data.accounts[i].money)),
					value    = 'black_money',
					itemType = 'item_account',
					amount   = data.accounts[i].money
				})

				break
			end

		end

		table.insert(elements, {label = _U('guns_label'), value = nil})

		for i=1, #data.weapons, 1 do
			table.insert(elements, {
				label    = _U('confiscate_weapon', ESX.GetWeaponLabel(data.weapons[i].name), data.weapons[i].ammo),
				value    = data.weapons[i].name,
				itemType = 'item_weapon',
				amount   = data.weapons[i].ammo
			})
		end

		table.insert(elements, {label = _U('inventory_label'), value = nil})

		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(elements, {
					label    = _U('confiscate_inv', data.inventory[i].count, data.inventory[i].label),
					value    = data.inventory[i].name,
					itemType = 'item_standard',
					amount   = data.inventory[i].count
				})
			end
		end


		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search',
				{
					title    = _U('search'),
					align    = 'top-left',
					elements = elements,
				},
				function(data, menu)

					local itemType = data.current.itemType
					local itemName = data.current.value
					local amount   = data.current.amount

					if data.current.value ~= nil then
						TriggerServerEvent('flap_police_job:confiscatePlayerItem', GetPlayerServerId(player), itemType, itemName, amount)
						OpenBodySearchMenu(player)
					end

				end, function(data, menu)
					menu.close()
				end)

	end, GetPlayerServerId(player))

end

function OpenFineMenu(player)

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine',
			{
				title    = _U('fine'),
				align    = 'top-left',
				elements = {
					{label = _U('traffic_offense'), value = 0},
					{label = _U('minor_offense'),   value = 1},
					{label = _U('average_offense'), value = 2},
					{label = _U('major_offense'),   value = 3}
				}
			}, function(data, menu)
				OpenFineCategoryMenu(player, data.current.value)
			end, function(data, menu)
				menu.close()
			end)

end

function OpenFineCategoryMenu(player, category)

	ESX.TriggerServerCallback('flap_police_job:getFineList', function(fines)

		local elements = {}

		for i=1, #fines, 1 do
			table.insert(elements, {
				label     = fines[i].label .. ' <span style="color: green;">$' .. fines[i].amount .. '</span>',
				value     = fines[i].id,
				amount    = fines[i].amount,
				fineLabel = fines[i].label
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine_category',
				{
					title    = _U('fine'),
					align    = 'top-left',
					elements = elements,
				}, function(data, menu)

					local label  = data.current.fineLabel
					local amount = data.current.amount

					menu.close()

					if Config.EnablePlayerManagement then
						TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_police', _U('fine_total', label), amount)
					else
						TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), '', _U('fine_total', label), amount)
					end

					ESX.SetTimeout(300, function()
						OpenFineCategoryMenu(player, category)
					end)

				end, function(data, menu)
					menu.close()
				end)

	end, category)

end

function ShowPlayerLicense(player)
	local elements = {}
	local targetName
	ESX.TriggerServerCallback('flap_police_job:getOtherPlayerData', function(data)
		if data.licenses ~= nil then
			for i=1, #data.licenses, 1 do
				if data.licenses[i].label ~= nil and data.licenses[i].type ~= nil then
					table.insert(elements, {label = data.licenses[i].label, value = data.licenses[i].type})
				end
			end
		end

		if Config.EnableESXIdentity then
			targetName = data.firstname .. ' ' .. data.lastname
		else
			targetName = data.name
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_license',
				{
					title    = _U('license_revoke'),
					align    = 'top-left',
					elements = elements,
				}, function(data, menu)
					ESX.ShowNotification(_U('licence_you_revoked', data.current.label, targetName))
					TriggerServerEvent('flap_police_job:message', GetPlayerServerId(player), _U('license_revoked', data.current.label))

					TriggerServerEvent('esx_license:removeLicense', GetPlayerServerId(player), data.current.value)

					ESX.SetTimeout(300, function()
						ShowPlayerLicense(player)
					end)
				end, function(data, menu)
					menu.close()
				end)

	end, GetPlayerServerId(player))
end

function OpenUnpaidBillsMenu(player)
	local elements = {}

	ESX.TriggerServerCallback('esx_billing:getTargetBills', function(bills)
		for i=1, #bills, 1 do
			table.insert(elements, {label = bills[i].label .. ' - <span style="color: red;">$' .. bills[i].amount .. '</span>', value = bills[i].id})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'billing',
				{
					title    = _U('unpaid_bills'),
					align    = 'top-left',
					elements = elements
				}, function(data, menu)

				end, function(data, menu)
					menu.close()
				end)
	end, GetPlayerServerId(player))
end

function OpenVehicleInfosMenu(vehicleData)

	ESX.TriggerServerCallback('flap_police_job:getVehicleInfos', function(retrivedInfo)

		local elements = {}

		table.insert(elements, {label = _U('plate', retrivedInfo.plate), value = nil})

		if retrivedInfo.owner == nil then
			table.insert(elements, {label = _U('owner_unknown'), value = nil})
		else
			table.insert(elements, {label = _U('owner', retrivedInfo.owner), value = nil})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos',
				{
					title    = _U('vehicle_info'),
					align    = 'top-left',
					elements = elements
				}, nil, function(data, menu)
					menu.close()
				end)

	end, vehicleData.plate)

end