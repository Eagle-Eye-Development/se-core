-- This script is now the sole manager of focus during the transition.
local hasTransitioned = false

-- We listen for the native FiveM event that fires when the player first spawns.
AddEventHandler('playerSpawned', function()
    if hasTransitioned then return end
    hasTransitioned = true

    print('[SE-Core] Player has spawned, commencing transition.')

    -- Step 1: Shut down the loading screen UI completely.
    ShutdownLoadingScreenNui()

    -- Step 2: Give the game a few frames to process the shutdown. This is crucial.
    Wait(250)

    -- Step 3: Tell the multicharacter UI to appear.
    TriggerEvent('se-core:client:openCharacterSelector')

    -- Step 4: Forcefully set NUI focus. This is now the ONLY place this happens during the transition.
    SetNuiFocus(true, true)
end)

-- This event is called by the multicharacter script when a character is chosen.
-- We are now responsible for removing focus.
RegisterNetEvent('se-core:client:characterSelected', function()
    print('[SE-Core] Character selected, removing NUI focus.')
    SetNuiFocus(false, false)
end)