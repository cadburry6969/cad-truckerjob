CadHelper = {}

CadHelper.ShowAlert = function(message, playNotificationSound)
    SetTextComponentFormat('STRING')
    AddTextComponentString(message)
    DisplayHelpTextFromStringLabel(0, 0, playNotificationSound, -1)
end

CadHelper.SpawnVehicle = function(name, coordinates, heading)
    RequestModel(name)

    while not HasModelLoaded(name) do
        Citizen.Wait(100)
    end

    local vehicle = CreateVehicle(name, coordinates, heading, true, true)

    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleOnGroundProperly(vehicle)
	SetModelAsNoLongerNeeded(name)

	Wait(50)
	
	local plate = GetVehicleNumberPlateText(vehicle)	
	TriggerEvent("vehiclekeys:client:SetOwner", plate) 
	TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)   

    return vehicle
end

CadHelper.CreateBlip = function(coordinates, name, spriteId, colorId, scale)
	local blip = AddBlipForCoord(coordinates)

	SetBlipSprite(blip, spriteId)
	SetBlipColour(blip, colorId)
	SetBlipScale(blip, scale)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(name)
	EndTextCommandSetBlipName(blip)

	return blip
end

CadHelper.CreateRouteBlip = function(coordinates)	
	if DoesBlipExist(routeBlip) then RemoveBlip(routeBlip) end	
	RefreshWaypoint()
	DeleteWaypoint()
	routeBlip = AddBlipForCoord(coordinates.x,coordinates.y,coordinates.z)
	SetBlipSprite(routeBlip, 164)
	SetBlipColour(routeBlip, 53)  	
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Trailer Collect")
	EndTextCommandSetBlipName(routeBlip)
	SetNewWaypoint(coordinates.x, coordinates.y)		

	return routeBlip
end

RegisterNetEvent('cad-truckerjob:helper:showAlert')
AddEventHandler('cad-truckerjob:helper:showAlert', function(message, playNotificationSound)
	CadHelper.ShowAlert(message, playNotificationSound)
end)
