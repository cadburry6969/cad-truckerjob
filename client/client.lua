QBCore = exports['qb-core']:GetCoreObject()
local truckId, jobStatus, currentRoute, currentDestination = nil, CONST_NOTWORKING, nil, nil
local currentDestination, routeBlip, trailerId, lastDropCoordinates, totalRouteDistance = nil, nil, nil, nil, nil, nil

local PickupCoordinates = nil

Citizen.CreateThread(function()
	CadHelper.CreateBlip(Config.JobStart.Coordinates, 'Trucking', Config.Blip.SpriteID, Config.Blip.ColorID, Config.Blip.Scale)

	while true do
		Citizen.Wait(0)

		local playerId             = PlayerPedId()
		local playerCoordinates    = GetEntityCoords(playerId)
		local distanceFromJobStart = GetDistanceBetweenCoords(playerCoordinates, Config.JobStart.Coordinates, false)
		local sleep                = 1000

		if distanceFromJobStart < Config.Marker.DrawDistance then
			sleep = 0
		
			DrawMarker(2, Config.JobStart.Coordinates, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0,  Config.Marker.Color.r, Config.Marker.Color.g, Config.Marker.Color.b, 100, false, true, 2, false, nil, nil, false)

			if distanceFromJobStart < Config.Marker.Size.x then

				if truckId and GetVehiclePedIsIn(playerId, false) == truckId and GetPedInVehicleSeat(truckId, -1) == playerId then
					CadHelper.ShowAlert('Press ~INPUT_PICKUP~ to return your truck to get your deposit of ~g~$' .. Config.TruckRentalPrice .. '.', true)
					if IsControlJustReleased(0, 38) then										
						abortJob()
					end
				elseif not IsPedInAnyVehicle(playerId, false) and truckId == nil then
					CadHelper.ShowAlert('Press ~INPUT_PICKUP~ to rent a truck. Deposit of ~g~$' .. Config.TruckRentalPrice .. '~w~ is required.', true)

					if IsControlJustReleased(0, 38) then
						TriggerServerEvent('cad-truckerjob:rentTruck')
					end
				elseif not IsPedInAnyVehicle(playerId, false) and truckId ~= nil then
					CadHelper.ShowAlert('Press ~INPUT_PICKUP~ to Abort Job. Deposit of ~r~$' .. Config.TruckRentalPrice .. '~w~ wont be returned.', true)
					if IsControlJustReleased(0, 38) then										
						abortJob()
					end
				end
			end
		end

		if jobStatus ~= CONST_NOTWORKING then
			sleep = 0

			if jobStatus == CONST_WAITINGFORTASK then
				assignTask()
			elseif jobStatus == CONST_PICKINGUP then
				pickingUpThread(playerId, playerCoordinates)
			elseif jobStatus == CONST_DELIVERING then
				deliveringThread(playerId, playerCoordinates)
			end
		end

		if sleep > 0 then
			Citizen.Wait(sleep)
		end
	end
end)

function pickingUpThread(playerId, playerCoordinates)
	if currentRoute ~= nil then
		if not trailerId and GetDistanceBetweenCoords(playerCoordinates, currentRoute.PickupCoordinates, true) < 100.0 then
			while true do
				Wait(0)		
				if currentRoute ~= nil and not trailerId and GetDistanceBetweenCoords(playerCoordinates, currentRoute.PickupCoordinates, true) < 100.0 then	
					if not IsAnyVehicleNearPoint(currentRoute.PickupCoordinates.x, currentRoute.PickupCoordinates.y, currentRoute.PickupCoordinates.z, 10.0) then		
						trailerId = CadHelper.SpawnVehicle(currentRoute.TrailerModel, currentRoute.PickupCoordinates, currentRoute.PickupHeading)		
						break					
					end								
				else					
					break
				end
			end				
		end
		if trailerId and not IsEntityAttachedToEntity(trailerId, truckId) then
			DrawMarker(20, currentRoute.PickupCoordinates.x, currentRoute.PickupCoordinates.y, currentRoute.PickupCoordinates.z + 5.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 255, 110, 100, 255, false, true, 2, false, false, false, false)
		end

		if trailerId and IsEntityAttachedToEntity(trailerId, truckId) then					
			CadHelper.CreateRouteBlip(currentDestination)						
			TriggerEvent("QBCore:Notify", "Take the delivery to the drop off point.")
			jobStatus = CONST_DELIVERING
		end
	end
end

function deliveringThread(playerId, playerCoordinates)
	local distanceFromDelivery = GetDistanceBetweenCoords(playerCoordinates, currentDestination, true)

	if distanceFromDelivery < Config.Marker.DrawDistance then
		DrawMarker(Config.Marker.Type, currentDestination, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.Size,  Config.Marker.Color.r, Config.Marker.Color.g, Config.Marker.Color.b, 100, false, true, 2, false, nil, nil, false)					
		if distanceFromDelivery > 4.0 then
			QBCore.Functions.DrawText3D(currentDestination.x, currentDestination.y, currentDestination.z, "Come Closer to unload Trailer")
		end
		if distanceFromDelivery < 4.0 then
			CadHelper.ShowAlert('Press ~INPUT_PICKUP~ to deliver the load.', true)
			if IsControlJustReleased(0, 38) then
				TriggerServerEvent('cad-truckerjob:loadDelivered', totalRouteDistance)
				cleanupTask()
			end		
		end
	end

	if trailerId and (not DoesEntityExist(trailerId) or not IsEntityAttachedToEntity(trailerId, truckId)) then
		if DoesEntityExist(trailerId) then
			DeleteVehicle(trailerId)
		end
		
		currentRoute        = nil
		currentDestination  = nil
		lastDropCoordinates = playerCoordinates

		TriggerEvent("QBCore:Notify", "You lost your load. A new route will be assigned.")

		jobStatus = CONST_WAITINGFORTASK
	end
end

function cleanupTask()
	if DoesEntityExist(trailerId) then
		DeleteVehicle(trailerId)
	end

	trailerId          = nil
	routeBlip          = nil
	currentDestination = nil
	currentRoute       = nil

	jobStatus = CONST_WAITINGFORTASK
end

function abortJob()
	DoScreenFadeOut(500)
	Citizen.Wait(500)

	if truckId and DoesEntityExist(truckId) then
		DeleteVehicle(truckId)
	end

	if trailerId and DoesEntityExist(trailerId) then
		DeleteVehicle(trailerId)
	end	

	if DoesBlipExist(routeBlip) then 	
		RefreshWaypoint()
		DeleteWaypoint()	
		RemoveBlip(routeBlip) 				
	end	
	RefreshWaypoint()
	DeleteWaypoint()
	RemoveBlip(routeBlip) 		

	truckId  		    = nil
	trailerId		    = nil
	routeBlip			= nil
	currentDestination  = nil
	currentRoute        = nil
	lastDropCoordinates = nil
	totalRouteDistance  = nil

	Citizen.Wait(500)
	DoScreenFadeIn(500)
	TriggerServerEvent('cad-truckerjob:returnTruck')
end

function assignTask()
	currentRoute       = Config.Routes[math.random(1, #Config.Routes)]
	currentDestination = currentRoute.Destinations[math.random(1, #currentRoute.Destinations)]	
	CadHelper.CreateRouteBlip(currentRoute.PickupCoordinates)

	local distanceToPickup   = GetDistanceBetweenCoords(lastDropCoordinates, currentRoute.PickupCoordinates)
	local distanceToDelivery = GetDistanceBetweenCoords(currentRoute.PickupCoordinates, currentDestination)

	totalRouteDistance  = distanceToPickup + distanceToDelivery
	lastDropCoordinates = currentDestination

	TriggerEvent("QBCore:Notify", "Head to the pickup on your GPS.")
	jobStatus = CONST_PICKINGUP
end


RegisterNetEvent('cad-truckerjob:startJob')
AddEventHandler('cad-truckerjob:startJob', function()
	local playerId = PlayerPedId()

	truckId = CadHelper.SpawnVehicle(Config.TruckModel, Config.JobStart.Coordinates, Config.JobStart.Heading)
	SetPedIntoVehicle(playerId, truckId, -1)
	

	lastDropCoordinates = Config.JobStart.Coordinates

	jobStatus = CONST_WAITINGFORTASK
end)
