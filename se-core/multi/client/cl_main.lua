local characters = {}
local isCharacterScreenActive = false

-- This event is now triggered by the transition script after the loading screen is gone
AddEventHandler('se-core:client:openCharacterSelector', function()
    if not SECore.IsLoggedIn then
        TriggerServerEvent('se-multicharacter:server:getCharacters')
    end
end)

-- Receive characters and open/update UI
RegisterNetEvent('se-multicharacter:client:receiveCharacters', function(charData)
    characters = charData or {}
    print("[SE-MULTI] Received characters from server:", #characters)

    if not isCharacterScreenActive then
        ShowCharacterSelection()
    else
        -- If UI is already open, just refresh the character list
        SendNUIMessage({
            action = 'show',
            characters = characters,
            screen = 'character'
        })
    end
end)

function ShowCharacterSelection()
    isCharacterScreenActive = true
    -- We NO LONGER set focus here. The transition script handles it.
    SendNUIMessage({
        action = 'show',
        characters = characters,
        screen = 'character'
    })
end

function HideCharacterSelection()
    isCharacterScreenActive = false
    -- We NO LONGER set focus here.
    SendNUIMessage({ action = 'hide' })
end

-- NUI Callbacks
RegisterNUICallback('selectCharacter', function(data, cb)
    if data and data.citizenid then
        HideCharacterSelection()
        TriggerEvent('se-core:client:characterSelected') -- Tell the transition script we are done
        TriggerServerEvent('SECore:Server:LoadCharacter', data.citizenid)
        cb('ok')
    else
        cb('error')
    end
end)

RegisterNUICallback('createCharacter', function(data, cb)
    if data and data.firstname and data.lastname and data.dob and data.gender then
        HideCharacterSelection()
        TriggerEvent('se-core:client:characterSelected') -- Also unfocus on create
        TriggerServerEvent('se-multicharacter:server:createCharacter', data)
        cb('ok')
    else
        cb('error')
    end
end)

RegisterNUICallback('deleteCharacter', function(data, cb)
    if data and data.citizenid then
        TriggerServerEvent('se-multicharacter:server:deleteCharacter', data.citizenid)
        cb('ok')
    else
        cb('error')
    end
end)

-- This callback is no longer needed to trigger the UI,
-- but we can keep it for potential future use (e.g., hot-reloading the UI).
RegisterNUICallback('nuiReady', function(data, cb)
    cb('ok')
end)

