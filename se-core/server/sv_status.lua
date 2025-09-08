-- se-core/server/sv_status.lua

function SECore.StartStatusLoop()
    CreateThread(function()
        while true do
            Wait(Config.Status.Interval)

            for src, playerData in pairs(SECore.Players) do
                if playerData and playerData.metadata and GetPlayerPed(src) > 0 then
                    local changed = false
                    
                    if playerData.metadata.hunger > 0 then
                        playerData.metadata.hunger = math.max(0, playerData.metadata.hunger - Config.Status.HungerDecay)
                        changed = true
                    end

                    if playerData.metadata.thirst > 0 then
                        playerData.metadata.thirst = math.max(0, playerData.metadata.thirst - Config.Status.ThirstDecay)
                        changed = true
                    end

                    if changed then
                        TriggerClientEvent('se-core:syncStatus', src, { -- Changed Line
                            hunger = playerData.metadata.hunger,
                            thirst = playerData.metadata.thirst
                        })
                    end
                end
            end
        end
    end)
    print('[se-core] Status (Hunger/Thirst) decay loop has started.')
end

RegisterNetEvent('SECore:Server:RequestStatusUpdate', function()
    local src = source
    local playerData = SECore.Players[src]
    
    if playerData and playerData.metadata then
        TriggerClientEvent('se-core:syncStatus', src, { -- Changed Line
            hunger = playerData.metadata.hunger,
            thirst = playerData.metadata.thirst
        })
    end
end)