local spawned                 = false
local garspawned              = false
local CachedVehicles          = {}
local CachedHelicopters       = {}
local playerInService         = false

function SetVehicleMaxMods(vehicle)
	local props = {
		modEngine       = 2,
		modBrakes       = 2,
		modTransmission = 2,
		modSuspension   = 3,
		modTurbo        = true
	}

	ESX.Game.SetVehicleProperties(vehicle, props)
end

function cleanPlayer(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

function setUniform(job, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if Config.Uniforms[job].male ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end

			if job == 'bullet_wear' then
				SetPedArmour(playerPed, 100)
			end
		else
			if Config.Uniforms[job].female ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end

			if job == 'bullet_wear' then
				SetPedArmour(playerPed, 100)
			end
		end
	end)
end

function GetAvailableVehicleSpawnPoint(station, partNum)
	local spawnPoints = Config.PoliceStations[station].Vehicles[partNum].SpawnPoints
	local found, foundSpawnPoint = false, nil

	for i=1, #spawnPoints, 1 do
		if ESX.Game.IsSpawnPointClear(spawnPoints[i], spawnPoints[i].radius) then
			found, foundSpawnPoint = true, spawnPoints[i]
			break
		end
	end

	if found then
		return true, foundSpawnPoint
	else
		return false
	end
end

function LookupVehicle()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'lookup_vehicle',
	{
		title = _U('search_database_title'),
	}, function(data, menu)
		local length = string.len(data.value)
		if data.value == nil or length < 2 or length > 13 then
			ESX.ShowNotification(_U('search_database_error_invalid'))
		else
			ESX.TriggerServerCallback('flap_police_job:getVehicleFromPlate', function(owner, found)
				if found then
					ESX.ShowNotification(_U('search_database_found', owner))
				else
					ESX.ShowNotification(_U('search_database_error_not_found'))
				end
			end, data.value)
			menu.close()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenGetWeaponMenu()

	ESX.TriggerServerCallback('flap_police_job:getArmoryWeapons', function(weapons)
		local elements = {}

		for i=1, #weapons, 1 do
			if weapons[i].count > 0 then
				table.insert(elements, {label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name), value = weapons[i].name})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon',
		{
			title    = _U('get_weapon_menu'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			menu.close()

			ESX.TriggerServerCallback('flap_police_job:removeArmoryWeapon', function()
				OpenGetWeaponMenu()
			end, data.current.value)

		end, function(data, menu)
			menu.close()
		end)
	end)

end

function OpenPutWeaponMenu()
	local elements   = {}
	local playerPed  = PlayerPedId()
	local weaponList = ESX.GetWeaponList()

	for i=1, #weaponList, 1 do
		local weaponHash = GetHashKey(weaponList[i].name)

		if HasPedGotWeapon(playerPed, weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
			table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_put_weapon',
	{
		title    = _U('put_weapon_menu'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		menu.close()

		ESX.TriggerServerCallback('flap_police_job:addArmoryWeapon', function()
			OpenPutWeaponMenu()
		end, data.current.value, true)

	end, function(data, menu)
		menu.close()
	end)
end

function OpenBuyWeaponsMenu(station)

	ESX.TriggerServerCallback('flap_police_job:getArmoryWeapons', function(weapons)

		local elements = {}

		for i=1, #Config.PoliceStations[station].AuthorizedWeapons, 1 do
			local weapon = Config.PoliceStations[station].AuthorizedWeapons[i]
			local count  = 0

			for i=1, #weapons, 1 do
				if weapons[i].name == weapon.name then
					count = weapons[i].count
					break
				end
			end

			table.insert(elements, {
				label = 'x' .. count .. ' ' .. ESX.GetWeaponLabel(weapon.name) .. ' $' .. weapon.price,
				value = weapon.name,
				price = weapon.price
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons',
		{
			title    = _U('buy_weapon_menu'),
			align    = 'top-left',
			elements = elements,
		}, function(data, menu)

			ESX.TriggerServerCallback('flap_police_job:buy', function(hasEnoughMoney)
				if hasEnoughMoney then
					ESX.TriggerServerCallback('flap_police_job:addArmoryWeapon', function()
						OpenBuyWeaponsMenu(station)
					end, data.current.value, false)
				else
					ESX.ShowNotification(_U('not_enough_money'))
				end
			end, data.current.price)

		end, function(data, menu)
			menu.close()
		end)

	end)

end

function OpenGetStocksMenu()

	ESX.TriggerServerCallback('flap_police_job:getStockItems', function(items)


		local elements = {}

		for i=1, #items, 1 do
			table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu',
		{
			title    = _U('police_stock'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)

				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('flap_police_job:getStockItem', itemName, count)

					Citizen.Wait(300)
					OpenGetStocksMenu()
				end

			end, function(data2, menu2)
				menu2.close()
			end)

		end, function(data, menu)
			menu.close()
		end)

	end)

end

function OpenPutStocksMenu()

	ESX.TriggerServerCallback('flap_police_job:getPlayerInventory', function(inventory)

		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu',
		{
			title    = _U('inventory'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)

				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('flap_police_job:putStockItems', itemName, count)

					Citizen.Wait(300)
					OpenPutStocksMenu()
				end

			end, function(data2, menu2)
				menu2.close()
			end)

		end, function(data, menu)
			menu.close()
		end)
	end)

end

function ShowFloatingHelpNotification(msg, x, y, z)
    AddTextEntry('flap_police_job', msg)
    SetFloatingHelpTextWorldPosition(1, x, y, z)
    SetFloatingHelpTextStyle(1, 1, 25, -1, 3, 0)
    BeginTextCommandDisplayHelp('flap_police_job')
    EndTextCommandDisplayHelp(2, false, false, -1)
end

function StartHandcuffTimer()
	if Config.EnableHandcuffTimer and HandcuffTimer.Active then
		ESX.ClearTimeout(HandcuffTimer.Task)
	end

	HandcuffTimer.Active = true

	HandcuffTimer.Task = ESX.SetTimeout(Config.HandcuffTimer, function()
		ESX.ShowNotification(_U('unrestrained_timer'))
		TriggerEvent('flap_police_job:unrestrain')
		HandcuffTimer.Active = false
	end)
end

function ImpoundVehicle(vehicle)
	--local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
	ESX.Game.DeleteVehicle(vehicle) 
	ESX.ShowNotification(_U('impound_successful'))
	CurrentTask.Busy = false
end

function CreateNpc(list)  -- Basic function to spawn a safe ped (unkillable). 
	RequestModel(list.model)
	while not HasModelLoaded(GetHashKey(list.model)) do
		Wait(1)
	end
	local npc = CreatePed(4, list.model, list.x, list.y, list.z, list.h,  false, true)
	SetModelAsNoLongerNeeded(GetHashKey(list.model))
	SetPedFleeAttributes(npc, 0, 0)
	SetPedDropsWeaponsWhenDead(npc, false)
	SetPedDiesWhenInjured(npc, false)
	SetEntityInvincible(npc , true)
	FreezeEntityPosition(npc, true)
	SetBlockingOfNonTemporaryEvents(npc, true)
	DecorSetBool(npc,"noDrugs",true)
	if list.scenario == 0 then 
    	if not HasAnimDictLoaded(list.animDict) then
            RequestAnimDict(list.animDict)
            while not HasAnimDictLoaded(list.animDict) do
                Citizen.Wait(0)
            end
        end
		TaskPlayAnim(npc, list.animDict, list.animName, 2.0, 2.0, -1, list.flag, 0.0, false, false, false)
		RemoveAnimDict(list.animDict)
    end
	if list.scenario == 2 then --assis
		ClearPedTasksImmediately(npc)
		TaskStartScenarioAtPosition(npc, list.anim, list.x, list.y, list.z, list.h , 0, true, true)
	end

	if list.scenario == 3 then --clavier
		ClearPedTasksImmediately(npc)
		TaskStartScenarioAtPosition(npc, list.anim, list.x, list.y, list.z, list.h , 0, true, true)
		FreezeEntityPosition(npc, true)
		Wait(0)
        if not HasAnimDictLoaded('anim@amb@clubhouse@boss@male@') then
            RequestAnimDict('anim@amb@clubhouse@boss@male@')
            while not HasAnimDictLoaded('anim@amb@clubhouse@boss@male@') do
                Citizen.Wait(0)
            end
        end
		TaskPlayAnim(npc, 'anim@amb@clubhouse@boss@male@', 'computer_idle', 2.0, 2.0, -1, 51, 0.0, false, false, false)
		RemoveAnimDict('anim@amb@clubhouse@boss@male@')
	end

	if list.scenario == 4 then --clavier
		ClearPedTasksImmediately(npc)
		TaskStartScenarioAtPosition(npc, list.anim, list.x, list.y, list.z, list.h , 0, true, true)
		FreezeEntityPosition(npc, true)

	end
	
	if list.scenario == 1 then
		--TaskStartScenarioAtPosition(npc, list.anim, list.x, list.y, list.z, list.h, -1, false, true)
        TaskStartScenarioInPlace(npc, list.anim)
    end
	return npc
	
end

-------NUI

-- functions

function OpenCloakroomNUI()
	SendNUIMessage({
		yrp_cloakroom = true
	})
    SetNuiFocus(true, true)
end

function OpenGarageNUI()
	SendNUIMessage({
		yrp_garage_menu = true
	})
    SetNuiFocus(true, true)
end

function OpenArmoryNUI()
	SendNUIMessage({
		yrp_armory = true
	})
    SetNuiFocus(true, true)
end

function OpenHelicoptersNUI()
	SendNUIMessage({
		yrp_helicopters_menu = true
	})
    SetNuiFocus(true, true)
end

function HelipadFull()
	SendNUIMessage({
		yrp_helipad_full = true
	})
	SetNuiFocus(true, true)
end

function HelicopterSpawned()
	SendNUIMessage({
		yrp_hel_spawned = true
	})
	SetNuiFocus(true, true)
end

function HelicopterParked()
	SendNUIMessage({
		yrp_hel_parked = true
	})
	SetNuiFocus(true, true)
end

function OpenGarageCarsNUI()
	SendNUIMessage({
		yrp_garage_cars = true
	})
    SetNuiFocus(true, true)
end

function OpenHelicoptersListNUI()
	SendNUIMessage({
		yrp_helicopters_list = true
	})
    SetNuiFocus(true, true)
end

function OpenManageOutfitsNUI()
	SendNUIMessage({
		yrp_manage_outfits = true
	})
    SetNuiFocus(true, true)
end

function OpenCreateOutfitsNUI()
	SendNUIMessage({
		yrp_create_outfits = true
	})
    SetNuiFocus(true, true)
end

function OpenPutArmory()
	SendNUIMessage({
		yrp_put_armory = true
	})
	SetNuiFocus(true, true)
end

function OpenTakeArmory()
	SendNUIMessage({
		yrp_take_armory = true
	})
	SetNuiFocus(true, true)
end

function OpenShopArmory()
	SendNUIMessage({
		yrp_shop_armory = true
	})
	SetNuiFocus(true, true)
end

function OpenBossManageSalary()
	SendNUIMessage({
		yrp_manage_salary = true
	})
    SetNuiFocus(true, true)
end

function OpenEmployeeList()
	SendNUIMessage({
		employees_list = true
	})
    SetNuiFocus(true, true)
end

function OpenManageSalary(grade, gradeName)
	SendNUIMessage({
		yrp_manage_salary_open = true,
		grade = grade,
		gradeName = gradeName
	})
    SetNuiFocus(true, true)
end

function OpenRecruitEmployee()
	SendNUIMessage({
		recruit_employee = true
	})
    SetNuiFocus(true, true)
end

function OpenCloakroomKeysNUI()
	SendNUIMessage({
		yrp_cloakroom_keys = true
	})
    SetNuiFocus(true, true)
end

function OpenBossMenuNUI()
	SendNUIMessage({
		yrp_bossmenu = true
	})
    SetNuiFocus(true, true)
end

function OpenManageMoneyWithWash()
	SendNUIMessage({
		yrp_manage_money_wash = true
	})
    SetNuiFocus(true, true)
end

function OpenManageMoney()
	SendNUIMessage({
		yrp_manage_money = true
	})
    SetNuiFocus(true, true)
end

function OpenManageEmployeeWithSalary()
	SendNUIMessage({
		yrp_manage_employees_with_salary = true
	})
    SetNuiFocus(true, true)
end

function OpenManageEmployee()
	SendNUIMessage({
		yrp_manage_employees = true
	})
    SetNuiFocus(true, true)
end

function OpenManageEmployeesGradeList()
	SendNUIMessage({
		grade_list_promote = true
	})
    SetNuiFocus(true, true)
end

function openCustomChoose()
	SendNUIMessage({
		yrp_custom_c_menu = true
	})
    SetNuiFocus(true, true)
end

function parkingCar(vehicle)
	local getvehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)

	ESX.ShowNotification(_U('engine_off'))
	TaskLeaveVehicle(GetPlayerPed(-1), getvehicle, 0)
	SetVehicleDoorsLockedForAllPlayers(getvehicle, true)
	AddVehicleToParkingSlot(getvehicle)
	
end

function AddVehicleToParkingSlot(vehicle)
    local netID = VehToNet(vehicle)
    CachedVehicles[netID] = true
end

function RemoveParkedVehicles()
    for k, v in pairs(CachedVehicles) do
        DeleteEntity(NetToVeh(k))
    end
    CachedVehicles = {}
end

function parkingHel(vehicle)
	local gethel = GetVehiclePedIsIn(GetPlayerPed(-1), false)

	ESX.ShowNotification(_U('engine_off'))
	TaskLeaveVehicle(GetPlayerPed(-1), gethel, 0)
	SetVehicleDoorsLockedForAllPlayers(gethel, true)
	AddHelToParkingSlot(gethel)
	
end

function AddHelToParkingSlot(vehicle)
    local netID = VehToNet(vehicle)
    CachedHelicopters[netID] = true
end

function RemoveParkedHelicopters()
    for k, v in pairs(CachedHelicopters) do
        DeleteEntity(NetToVeh(k))
    end
    CachedHelicopters = {}
	HelicopterParked()
end

function BossManageSalary(society)

	ESX.TriggerServerCallback('flap_police_job:getJob', function(job)

		for i=1, #job.grades, 1 do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)

			SendNUIMessage({
				grade = gradeLabel,
				gradeName =  job.grades[i].grade,
				salary = ESX.Math.GroupDigits(job.grades[i].salary),
				maxSalary = Config.MaxSalary
			})
		end

	end, society)
end

function RecruitEmployees(society)
	ESX.TriggerServerCallback('esx_society:getOnlinePlayers', function(players)
		local elements = {}

		for i=1, #players, 1 do
			if players[i].job.name ~= society then

				SendNUIMessage({
					name = players[i].name,
					job = players[i].job.label,
					identifier = players[i].identifier
				})

			end
		end
	end)
end

function EmployeesList(society)

	ESX.TriggerServerCallback('esx_society:getEmployees', function(employees)

		for i=1, #employees, 1 do
			local gradeLabel = (employees[i].job.grade_label == '' and employees[i].job.label or employees[i].job.grade_label)

			SendNUIMessage({
				name = employees[i].name,
				job = employees[i].job.label,
				grade = employees[i].job.grade_label,
				identifier = employees[i].identifier
			})
		end

	end, society)
end

function PromoteGradeList(society, identifier)

	print(identifier)



	ESX.TriggerServerCallback('esx_society:getJob', function(job)

		for i=1, #job.grades, 1 do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)

			SendNUIMessage({
				label = gradeLabel,
				value = job.grades[i].grade,
				identifier = identifier
			})
		end

	end, society)
	
end

function LoadLaskSkin()
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:loadSkin', skin)
	end)
end