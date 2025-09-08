RegisterNetEvent('SECore:Client:SetPlayerData', function(data)
    SECore.PlayerData = data
    SECore.IsLoggedIn = true
    SECore.DebugPrint("Received player data from server.")
end)

function SECore.GetPlayerData()
    return SECore.PlayerData
end

exports('GetCoreObject', function()
    return SECore
end)

