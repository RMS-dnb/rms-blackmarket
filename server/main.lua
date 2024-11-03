local RSGCore = exports['rsg-core']:GetCoreObject()
local coords = nil

-- Initialize black market position and cycling if enabled
Citizen.CreateThread(function()
    -- Set initial position
    coords = Config.BlackmarketPositions[math.random(1, #Config.BlackmarketPositions)]

    -- If cycling is enabled, periodically change the position
    if not Config.BlackmarketMoveAtStart and Config.BlackmarketCycling then
        while true do
            Wait(Config.CycleInterval * 60000) -- Convert minutes to milliseconds
            coords = Config.BlackmarketPositions[math.random(1, #Config.BlackmarketPositions)]
            TriggerClientEvent('rms-blackmarket:client:newPos', -1, coords)
        end
    end
end)

-- Callback to provide current black market position to clients
RSGCore.Functions.CreateCallback('getCoords', function(source, cb)
    cb(coords)
end)

-- Event to handle selling items at the black market
RegisterNetEvent('rms-blackmarket:server:sellItems', function(item, amount, price)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)

    -- Remove item from player's inventory and add cash
    Player.Functions.RemoveItem(item, amount)
    TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[item], 'remove')
    Player.Functions.AddMoney('cash', price * amount)
end)
