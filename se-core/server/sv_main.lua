SECore.Players = {}

-- This event is triggered when a player first starts connecting to the server
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local src = source
    local license = GetPlayerIdentifierByType(src, 'license')

    deferrals.defer()
    
    -- THIS IS THE MERGED PART: Hand over the player name to the NUI loading screen
    deferrals.handover({
        type = 'nuiHandover', -- Added a type for better JS handling
        name = name
    })
    
    Wait(0)
    
    local characters = MySQL.query.await('SELECT * FROM players WHERE license = ?', { license })
    
    SECore.Players[src] = {
        license = license,
        char = nil, -- No character is loaded yet
        characters = characters or {}
    }

    deferrals.done()
end)

-- This function is called by other resources (like se-multi) to load a specific character
function SECore.LoadCharacterByCitizenId(src, citizenid)
    local license = SECore.Players[src].license
    if not license then 
        print(('[se-core] [ERROR] Could not find license for source %s'):format(src))
        return 
    end

    local result = MySQL.query.await('SELECT * FROM players WHERE citizenid = ? AND license = ?', { citizenid, license })

    if result and result[1] then
        print(('[se-core] Loaded character %s for source %s.'):format(citizenid, src))
        SECore.Players[src].char = result[1]

        -- This event tells the new se-spawn script that a character is ready.
        TriggerClientEvent('se-core:client:characterLoaded', src, result[1])
    else
        print(('[se-core] [ERROR] Failed to load character %s for source %s.'):format(citizenid, src))
    end
end

-- Event for when a player drops from the server
AddEventHandler('playerDropped', function(reason)
    local src = source
    if SECore.Players[src] and SECore.Players[src].citizenid then
        -- Save the player data on drop
        SECore.SavePlayer(src)
        print(('[se-core] Player %s (%s) dropped. Data saved.'):format(GetPlayerName(src), src))
    end
    SECore.Players[src] = nil
end)

-- Export to allow other resources to access the core object on the server
exports('GetCoreObject', function()
    return SECore
end)

SECore.StartStatusLoop()