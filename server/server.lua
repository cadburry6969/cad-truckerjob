QBCore = exports['qb-core']:GetCoreObject()
function getMoney(playerId)
	local player = QBCore.Functions.GetPlayer(playerId)

	if player ~= nil then
		local money = player.PlayerData.money.cash
		return money
	end
end

function addMoney(playerId, amount)
	local player = QBCore.Functions.GetPlayer(playerId)

	if player ~= nil then
		player.Functions.AddMoney("cash", amount)
		return true
	end
end

function removeMoney(playerId, amount)
	local player = QBCore.Functions.GetPlayer(playerId)

	if player ~= nil then
		player.Functions.RemoveMoney("cash", amount)
		return true
	end
end


RegisterNetEvent('cad-truckerjob:loadDelivered')
AddEventHandler('cad-truckerjob:loadDelivered', function(totalRouteDistance)
	local playerId = source
	local payout   = math.floor(totalRouteDistance * Config.PayPerMeter) / 2

	addMoney(playerId, payout)
	TriggerClientEvent('QBCore:Notify', playerId, 'Received $'..payout..' paycheck from trucking.')
end)

RegisterNetEvent('cad-truckerjob:rentTruck')
AddEventHandler('cad-truckerjob:rentTruck', function()
	local playerId = source

	if getMoney(playerId) < Config.TruckRentalPrice then
		TriggerClientEvent('QBCore:Notify', playerId, 'You do not have enough money to rent a truck.')
		return
	end

	removeMoney(playerId, Config.TruckRentalPrice)

	TriggerClientEvent('cad-truckerjob:startJob', playerId)
end)

RegisterNetEvent('cad-truckerjob:returnTruck')
AddEventHandler('cad-truckerjob:returnTruck', function()
	local playerId = source

	addMoney(playerId, Config.TruckRentalPrice)

	TriggerClientEvent('QBCore:Notify', playerId, 'Your $' .. Config.TruckRentalPrice .. ' deposit was returned to you.')
end)
