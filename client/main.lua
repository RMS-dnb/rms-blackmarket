local RSGCore = exports['rsg-core']:GetCoreObject()
local blackmarketPed = nil
local spawnedPeds = {}  -- Track spawned peds for cleanup

Citizen.CreateThread(function()
    local isLoggedIn = false

    while not isLoggedIn do
        Wait(1000)
        if LocalPlayer.state.isLoggedIn then
            isLoggedIn = true
            --print('Player Logged in!')
        end
    end

    if not blackmarketPed then
        RSGCore.Functions.TriggerCallback('getCoords', function(coords)
            if coords then
                local model = 'amsp_robsdgunsmith_males_01'

                while not HasModelLoaded(model) do
                    Wait(1)
                    RequestModel(model)
                end

                blackmarketPed = CreatePed(model, coords.x, coords.y, coords.z - 1.0, coords.w, true, false, 0, 0)
                Citizen.InvokeNative(0x283978A15512B2FE, blackmarketPed, true)
                FreezeEntityPosition(blackmarketPed, true)
                SetEntityInvincible(blackmarketPed, true)
                SetBlockingOfNonTemporaryEvents(blackmarketPed, true)
                Wait(1)

                -- Add the ped to the spawnedPeds table for tracking
                spawnedPeds[#spawnedPeds + 1] = { ped = blackmarketPed }

                local targetOptions = {
                    {
                        label = 'Open Market',
                        icon = 'fas fa-dollars',
                        action = function()
                            TriggerServerEvent('rsg-shops:server:openstore', 'blackmarket', 'blackmarket', 'Black Market')
                        end
                    }
                }

                if Config.BlackmarketCanBuy then
                    table.insert(targetOptions, {
                        label = 'Open Sell Market',
                        icon = 'fas fa-dollars',
                        action = function()
                            local tableData = {}

                            for _, items in pairs(Config.BlackmarketBuy) do
                                tableData[#tableData + 1] = {
                                    title = RSGCore.Shared.Items[items.name].label,
                                    description = 'Sell ' .. RSGCore.Shared.Items[items.name].label .. ' for $' .. items.price,
                                    onSelect = function()
                                        local info = lib.inputDialog('Sell Items', {
                                            {
                                                type = 'number',
                                                label = 'Amount',
                                                description = 'Items to sell',
                                                required = true,
                                                min = 1,
                                                default = 1,
                                            }
                                        })

                                        if RSGCore.Functions.HasItem(items.name, info[1]) then
                                            TriggerServerEvent('rms-blackmarket:server:sellItems', items.name, info[1], items.price)
                                        else
                                            lib.notify({
                                                title = 'Error',
                                                description = 'You don\'t have enough of this item!',
                                                type = 'error',
                                                timeout = 3000
                                            })
                                        end
                                    end
                                }
                            end

                            lib.registerContext({
                                id = 'sell_items',
                                title = 'Sell Items',
                                options = tableData
                            })
                            lib.showContext('sell_items')
                        end
                    })
                end

                exports['rsg-target']:AddTargetEntity(blackmarketPed, { options = targetOptions })
            end
        end)
    end
end)

RegisterNetEvent('rms-blackmarket:client:newPos', function(coords)
    if blackmarketPed then
        DeletePed(blackmarketPed)
        blackmarketPed = nil
    end

    local model = 'amsp_robsdgunsmith_males_01'

    while not HasModelLoaded(model) do
        Wait(1)
        RequestModel(model)
    end

    blackmarketPed = CreatePed(model, coords.x, coords.y, coords.z - 1.0, coords.w, true, false, 0, 0)
    Citizen.InvokeNative(0x283978A15512B2FE, blackmarketPed, true)
    FreezeEntityPosition(blackmarketPed, true)
    SetEntityInvincible(blackmarketPed, true)
    SetBlockingOfNonTemporaryEvents(blackmarketPed, true)
    Wait(1)

    -- Add the ped to the spawnedPeds table for tracking
    spawnedPeds[#spawnedPeds + 1] = { ped = blackmarketPed }

    local targetOptions = {
        {
            label = 'Open Market',
            icon = 'fas fa-dollars',
            action = function()
                TriggerServerEvent('rsg-shops:server:openstore', 'blackmarket', 'blackmarket', 'Black Market')
            end
        }
    }

    if Config.BlackmarketCanBuy then
        table.insert(targetOptions, {
            label = 'Open Sell Market',
            icon = 'fas fa-dollars',
            action = function()
                local tableData = {}

                for _, items in pairs(Config.BlackmarketBuy) do
                    tableData[#tableData + 1] = {
                        title = RSGCore.Shared.Items[items.name].label,
                        description = 'Sell ' .. RSGCore.Shared.Items[items.name].label .. ' for $' .. items.price,
                        onSelect = function()
                            local info = lib.inputDialog('Sell Items', {
                                {
                                    type = 'number',
                                    label = 'Amount',
                                    description = 'Items to sell',
                                    required = true,
                                    min = 1,
                                    default = 1,
                                }
                            })

                            if RSGCore.Functions.HasItem(items.name, info[1]) then
                                TriggerServerEvent('rms-blackmarket:server:sellItems', items.name, info[1], items.price)
                            else
                                lib.notify({
                                    title = 'Error',
                                    description = 'You don\'t have enough of this item!',
                                    type = 'error',
                                    timeout = 3000
                                })
                            end
                        end
                    }
                end

                lib.registerContext({
                    id = 'sell_items',
                    title = 'Sell Items',
                    options = tableData
                })
                lib.showContext('sell_items')
            end
        })
    end

    exports['rsg-target']:AddTargetEntity(blackmarketPed, { options = targetOptions })
end)

RegisterCommand('tpBlackmarket', function(source, rawCommand, args)
    if blackmarketPed then
        local pos = GetEntityCoords(blackmarketPed)
        SetEntityCoords(PlayerPedId(), pos.x, pos.y, pos.z, true, false, false, false)
    else
        lib.notify({
            title = 'Error',
            description = 'There\'s no existing blackmarket peds!',
            type = 'error',
            timeout = 3000
        })
    end
end)

-- Cleanup function
AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    for k, v in pairs(spawnedPeds) do
        if v.ped then
            exports['rsg-target']:RemoveTargetEntity(v.ped, 'Open Market')
            if DoesEntityExist(v.ped) then
                DeleteEntity(v.ped)
            end
        end

        spawnedPeds[k] = nil
    end
end)


-- cleanup
AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    for k, v in pairs(spawnedPeds) do
        exports['rsg-target']:RemoveTargetEntity(v.ped, Lang:t('client.lang_47'))
        if v.ped and DoesEntityExist(v.ped) then
            DeleteEntity(v.ped)
        end

        spawnedPeds[k] = nil
    end
end)