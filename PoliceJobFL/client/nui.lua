local inCam = false
local changeCloth = false

RegisterNUICallback('close', function(data, cb)
	closeCloakroomNui()
end)

RegisterNUICallback('choose_civilian', function(data, cb)
	if Config.EnableNonFreemodePeds then
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
			local isMale = skin.sex == 0

			TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
					TriggerEvent('esx:restoreLoadout')
				end)
			end)

		end)
	else
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
			TriggerEvent('skinchanger:loadSkin', skin)
		end)
	end
end)


RegisterNUICallback('choose_custom', function(data, cb)
	closeCloakroomNui()

	openCustomChoose()
end)


RegisterNUICallback('choose_orange_vest', function(data, cb)
	local playerPed = PlayerPedId()

	setUniform('gilet_wear', playerPed)
end)

RegisterNUICallback('choose_bulletproof_vest', function(data, cb)
	local playerPed = PlayerPedId()

	setUniform('bullet_wear', playerPed)
end)

RegisterNUICallback('choose_14', function(data, cb)
	OpenBossManageSalary()
	BossManageSalary('police')
end)

RegisterNUICallback('choose_15', function(data, cb)
	OpenEmployeeList()
	EmployeesList('police')
end)

RegisterNUICallback('choose_16', function(data, cb)
	OpenRecruitEmployee()
	RecruitEmployees('police')
end)

RegisterNUICallback('choose_17', function(data, cb)
	closeCloakroomNui()

	ESX.TriggerServerCallback('flap_police_job:getOutfits', function(dressing)
		local elements = {}

		for i=1, #dressing, 1 do
		  --table.insert(elements, {label = dressing[i], value = i})
		  SendNUIMessage({
			outfitLabel = dressing[i],
			outfitValue = i
		})
		end

	end)

	OpenManageOutfitsNUI()
end)

RegisterNUICallback('choose_20', function(data, cb)
	closeCloakroomNui()

	local parts = Config.CustomClothing.parts

	for i=1, #parts, 1 do
		SendNUIMessage({
			name = parts[i].name,
			label = parts[i].label,
			type = parts[i].type,
			min = parts[i].min,
			max = parts[i].max,
			cam = parts[i].zoomOffset,
			zoom = parts[i].camOffset
		})
	end

	OpenCreateOutfitsNUI()
end)

RegisterNUICallback('deleteOutfit', function(data, cb)
	closeCloakroomNui()

	TriggerServerEvent('flap_police_job:deleteOutfit', data.outfit)
end)

RegisterNUICallback('dressOutfit', function(data, cb)

	TriggerEvent('skinchanger:getSkin', function(skin)

		ESX.TriggerServerCallback('flap_police_job:getPlayerOutfit', function(clothes)

		  TriggerEvent('skinchanger:loadClothes', skin, clothes)
		  TriggerEvent('esx_skin:setLastSkin', skin)

		  TriggerEvent('skinchanger:getSkin', function(skin)
			TriggerServerEvent('esx_skin:save', skin)
		  end)

		  ESX.ShowNotification(_U('outfit_dressed'))
		  HasLoadCloth = true
		end, tonumber(data.outfit))
	end)
end)

RegisterNUICallback('choose_8', function(data, cb)
	RemoveParkedVehicles()
end)

RegisterNUICallback('choose_19', function(data, cb)
	RemoveParkedHelicopters()
end)

RegisterNUICallback('choose_9', function(data, cb)
	closeCloakroomNui()
	if Config.washMoney then
		OpenManageMoneyWithWash()
	else
		OpenManageMoney()
	end
end)

RegisterNUICallback('choose_10', function(data, cb)
	closeCloakroomNui()
	if Config.manageSalary then
		OpenManageEmployeeWithSalary()
	else
		OpenManageEmployee()
	end
end)

RegisterNUICallback('withdrawMoney', function(data, cb)
	TriggerServerEvent('flap_police_job:withdrawMoney', 'society_police', data.money)
end)

RegisterNUICallback('depositMoney', function(data, cb)
	TriggerServerEvent('flap_police_job:depositMoney', 'society_police', data.money)
end)

RegisterNUICallback('washMoney', function(data, cb)
	TriggerServerEvent('flap_police_job:washMoney', 'society_police', data.money)
end)

RegisterNUICallback('openManageGrades', function(data, cb)
	local grade = data.grade
	local salary = data.money

	closeCloakroomNui()

	ESX.TriggerServerCallback('flap_police_job:setJobSalary', function()
	    TriggerEvent("flap_police_job:succesSetSalary", salary)
	end, 'police', grade, salary)

end)

RegisterNUICallback('Notification', function(data, cb)
	closeCloakroomNui()
    ESX.ShowNotification(data.text)
end)

RegisterNUICallback('recruitPlayer', function(data, cb)
	ESX.TriggerServerCallback('flap_police_job:setJob', function()
		closeCloakroomNui()
		TriggerEvent("flap_police_job:succesRecruit")
	end, data.identifier, 'police', 0, 'hire')
end)

RegisterNUICallback('firePlayer', function(data, cb)
	ESX.TriggerServerCallback('flap_police_job:setJob', function()
		closeCloakroomNui()
		TriggerEvent("flap_police_job:succesFire")
	end, data.identifier, 'police', 0, 'fire')
end)

RegisterNUICallback('promotePlayer', function(data, cb)

	closeCloakroomNui()
	PromoteGradeList('police', data.identifier)
	OpenManageEmployeesGradeList()

end)

RegisterNUICallback('selectPromote', function(data, cb)
	
	ESX.TriggerServerCallback('flap_police_job:setJob', function()
		closeCloakroomNui()
		TriggerEvent("flap_police_job:succesPromote")
	end, data.identifier, 'police', data.grade, 'promote')

end)

RegisterNUICallback('setCloth', function(data, cb)
	TriggerEvent("skinchanger:getSkin", function(skin)
		skin[data.name] = data.result
		TriggerEvent("skinchanger:loadSkin", skin)
		changeCloth = true
	end)

end)

RegisterNUICallback('setCam', function(data, cb)
	CreateSkinCam(data.cam, data.zoom)
end)

RegisterNUICallback('saveOutfit', function(data, cb)
	print(data.name)
	TriggerEvent('skinchanger:getSkin', function(skin)
		TriggerServerEvent('flap_police_job:saveOutfit', data.name, skin)
	end)
end)

RegisterNUICallback('choose_21', function(data, cb)
	ESX.TriggerServerCallback('flap_police_job:getPlayerInventory', function(inventory)
		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				SendNUIMessage({
					name = item.name,
					label = item.label,
					count = item.count,
					type = 'item_standard'
				})
			end
		end
		for i=1, #inventory.weapons, 1 do
			local weapon = inventory.weapons[i]

			SendNUIMessage({
				name = weapon.name,
				label = weapon.label,
				type = 'item_weapon'
			})
		end
	end)

	OpenPutArmory()
end)

RegisterNUICallback('choose_22', function(data, cb)

	ESX.TriggerServerCallback('flap_police_job:getStockItems', function(items)
		for i=1, #items, 1 do
			SendNUIMessage({
				name = items[i].name,
				label = items[i].label,
				count = items[i].count,
				type = "item_standard"
			})
		end
	end)

	ESX.TriggerServerCallback('flap_police_job:getArmoryWeapons', function(weapons)

		for i=1, #weapons, 1 do
			if weapons[i].count > 0 then
				SendNUIMessage({
					name = weapons[i].name,
					label = ESX.GetWeaponLabel(weapons[i].name),
					count = weapons[i].count,
					type = "item_weapon"
				})
			end
		end

	end)

	OpenTakeArmory()
end)

RegisterNUICallback('choose_23', function(data, cb)

	for i = 1, #Config.PoliceShop.items, 1 do
		local item = Config.PoliceShop.items[i]

		SendNUIMessage({
			name = item.name,
			label = item.label,
			price = item.price,
			type = 'item_standard'
		})
	end

	for i = 1, #Config.PoliceShop.weapons, 1 do
		local weapons = Config.PoliceShop.weapons[i]

		SendNUIMessage({
			name = weapons.name,
			label = weapons.label,
			price = weapons.price,
			type = 'item_weapon'
		})
	end

	OpenShopArmory()
end)

RegisterNUICallback('buyItems', function(data, cb)
	TriggerServerEvent("flap_police_job:buyItems", data.item, data.price, data.count, data.type)
end)

RegisterNUICallback('putItems', function(data, cb)
	TriggerServerEvent('flap_police_job:putStockItems', data.item, tonumber(data.count), data.type)
end)

RegisterNUICallback('getItems', function(data, cb)
	TriggerServerEvent('flap_police_job:getStockItem', data.item, tonumber(data.count), data.type)
end)

RegisterNUICallback('choose_24', function(data, cb)
	if Config.ArmorySystem.esx_inventoryhud then
		if not Config.ArmorySystem.yrpNUI then
			if not Config.ArmorySystem.customInventory then
				closeCloakroomNui()
				InventoryhudByTrsak()
			end
		end
	elseif Config.ArmorySystem.customInventory then
		if not Config.ArmorySystem.yrpNUI then
			if not Config.ArmorySystem.esx_inventoryhud then
				closeCloakroomNui()
				CustomInventory()
			end
		end
	end
end)

RegisterNUICallback('choose_25', function(data, cb)
	if Config.ArmorySystem.esx_inventoryhud then
		if not Config.ArmorySystem.yrpNUI then
			if not Config.ArmorySystem.customInventory then
				closeCloakroomNui()
				InventoryhudByTrsakShop()
			end
		end
	elseif Config.ArmorySystem.customInventory then
		if not Config.ArmorySystem.yrpNUI then
			if not Config.ArmorySystem.esx_inventoryhud then
				closeCloakroomNui()
				CustomInventoryShop()
			end
		end
	end
end)

RegisterNUICallback('saveNo', function(data, cb)
	changeCloth = false
end)

function CreateSkinCam(camOffset, zoomOffset)

	inCam = true

	local camOffset = camOffset
	local zoomOffset = zoomOffset
	local heading = Config.CustomClothing.pedHeading

    local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	local angle = heading * math.pi / 180.0
	local theta = {
		x = math.cos(angle),
		y = math.sin(angle)
	}

	local pos = {
		x = coords.x + (zoomOffset * theta.x),
		y = coords.y + (zoomOffset * theta.y)
	}

	if not DoesCamExist(cam) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    end

    local playerPed = PlayerPedId()

    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)

    isCameraActive = true
    SetCamRot(cam, 0.0, 0.0, 270.0, true)
	SetEntityHeading(playerPed, heading)

	local angleToLook = heading - 140.0
	if angleToLook > 360 then
		angleToLook = angleToLook - 360
	elseif angleToLook < 0 then
		angleToLook = angleToLook + 360
	end

	angleToLook = angleToLook * math.pi / 180.0
	local thetaToLook = {
		x = math.cos(angleToLook),
		y = math.sin(angleToLook)
	}

	local posToLook = {
		x = coords.x + (zoomOffset * thetaToLook.x),
		y = coords.y + (zoomOffset * thetaToLook.y)
	}

	SetCamCoord(cam, pos.x, pos.y + 1, coords.z + camOffset)
	PointCamAtCoord(cam, posToLook.x, posToLook.y, coords.z + camOffset)
end

function DeleteSkinCam()
    isCameraActive = false
    SetCamActive(cam, false)
    RenderScriptCams(false, true, 500, true, true)
    cam = nil
	inCam = false
end

function OpenArmoryNUI()
	if Config.ArmorySystem.yrpNUI then
		if not Config.ArmorySystem.customInventory then
			if not Config.ArmorySystem.esx_inventoryhud then
				SendNUIMessage({
					yrp_open_armory_flp = true
				})
				SetNuiFocus(true, true)
			end
		end
	elseif Config.ArmorySystem.esx_inventoryhud then
		if not Config.ArmorySystem.customInventory then
			if not Config.ArmorySystem.yrpNUI then
				SendNUIMessage({
					yrp_open_armory_other = true
				})
				SetNuiFocus(true, true)
			end
		end
	elseif Config.ArmorySystem.customInventory then
		if not Config.ArmorySystem.esx_inventoryhud then
			if not Config.ArmorySystem.yrpNUI then
				SendNUIMessage({
					yrp_open_armory_other = true
				})
				SetNuiFocus(true, true)
			end
		end
	end
end

function closeCloakroomNui()
	if not inCam then
		if not changeCloth then
	        SendNUIMessage({
		        yrp_cloakroom = false
	        })
            SetNuiFocus(false, false)
		else
			SendNUIMessage({
		        yrp_cloakroom = false
	        })
            SetNuiFocus(false, false)
			LoadLaskSkin()
			changeCloth = false
		end
	else
		if not changeCloth then
		    SendNUIMessage({
		        yrp_cloakroom = false
	        })
            SetNuiFocus(false, false)
		    DeleteSkinCam()
		else
			SendNUIMessage({
		        yrp_cloakroom = false
	        })
            SetNuiFocus(false, false)
		    DeleteSkinCam()
			LoadLaskSkin()
			changeCloth = false
		end
	end
end