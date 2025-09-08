RegisterCommand('me', function(source, args, rawCommand)
    local message = table.concat(args, " ")
    if not message or message == "" then

        exports['se-lib']:notify({
            title = 'Error',
            description = 'You must provide a message for the /me command.',
            type = 'error'
        })
        return
    end

    TriggerServerEvent('SECore:Server:ShareMe', message)

end, false)

RegisterNetEvent('SECore:Client:DisplayMe', function(senderId, message)
    local player = GetPlayerFromServerId(senderId)
    if player == -1 then return end

    local ped = GetPlayerPed(player)
    local coords = GetEntityCoords(ped)
    local myCoords = GetEntityCoords(PlayerPedId())
    
    if #(myCoords - coords) < 20.0 then
        TriggerEvent('chat:addMessage', {
            color = { 173, 216, 230 },
            multiline = true,
            args = { string.format("* %s %s", GetPlayerName(player), message) }
        })
    end
end)

