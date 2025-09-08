-- This event is triggered by the se-spawn server script after a location has been chosen and saved.
RegisterNetEvent('se-core:client:spawnPlayer', function(pos)
    -- Validate the incoming position data and set a fallback if it's invalid
    if not pos or not pos.x then
        print('[se-core] [ERROR] Received invalid position data for spawning. Using fallback.')
        pos = { x = -269.4, y = -955.3, z = 31.2, heading = 327.0 }
    end

    DoScreenFadeOut(500)
    Wait(500)

    local playerPed = PlayerPedId()

    -- Ensure the player is unfrozen from the character selection screen
    FreezeEntityPosition(playerPed, false)

    -- Teleport the player to the final coordinates
    RequestCollisionAtCoord(pos.x, pos.y, pos.z)
    SetEntityCoords(playerPed, pos.x, pos.y, pos.z, false, false, false, true)
    SetEntityHeading(playerPed, pos.heading or 0.0)
    
    -- Wait a moment for the environment to load in
    Wait(500) 
    
    DoScreenFadeIn(1000)
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()

    print(('[se-core] Player spawned at X:%.1f Y:%.1f Z:%.1f'):format(pos.x, pos.y, pos.z))

    -- Trigger a final event that other resources can listen for to know the player is loaded and in the world
    TriggerEvent('se-core:client:playerSpawned')
end)

