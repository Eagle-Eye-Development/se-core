--================================================================
-- V A R I A B L E S
--================================================================

local isSpawnSelectorActive = false
local lastPosition = nil

--================================================================
-- E V E N T S
--================================================================

-- This event is triggered by se-core/sv_player.lua after a character is loaded
RegisterNetEvent('se-spawn:client:openSelector', function(lastPos)
    if isSpawnSelectorActive then return end

    isSpawnSelectorActive = true
    lastPosition = lastPos or Config.DefaultSpawn

    FreezeEntityPosition(PlayerPedId(), true)

    -- THIS IS THE CHANGE: The action is now 'showSpawn' to tell the unified UI
    -- which container to display.
    SendNUIMessage({
        action = 'showSpawn',
        locations = Config.SpawnLocations,
        lastloc = {
            label = 'Last Location',
            description = 'Spawn where you last logged out.',
            coords = lastPosition
        }
    })

    SetNuiFocus(true, true)
end)

--================================================================
-- N U I   C A L L B A C K S
--================================================================

RegisterNUICallback('selectSpawn', function(data, cb)
    if not data or not data.id then
        cb({ status = 'error', message = 'Invalid data received.' })
        return
    end

    local coords
    if data.id == 'last' then
        coords = lastPosition
    else
        coords = Config.SpawnLocations[data.id].coords
    end

    TriggerServerEvent('se-spawn:server:spawnPlayer', coords)

    isSpawnSelectorActive = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'hideSpawn' }) -- Also changed to hide the correct container
    FreezeEntityPosition(PlayerPedId(), false)

    cb({ status = 'ok' })
end)
