function InitializeCommandsModule(SECore)
    print('[se-core] Server commands are now registered.')

    RegisterCommand('playerinfo', function(source, args, rawCommand)
        local src = source
        local playerData = SECore.GetPlayer(src)
        if playerData then

            exports['se-lib']:notify(src, {
                title = 'Player Info',
                description = string.format("Name: %s | CitizenID: %s | Job: %s", playerData.name, playerData.citizenid, playerData.job.label),
                type = 'info'
            })
            print(json.encode(playerData, { indent = true }))
        else
            exports['se-lib']:notify(src, {
                title = 'Error',
                description = 'Could not retrieve your player data.',
                type = 'error'
            })
        end
    end, false) 

    RegisterNetEvent('SECore:Server:ShareMe', function(message)
        local src = source

        TriggerClientEvent('SECore:Client:DisplayMe', -1, src, message)
    end)
end

