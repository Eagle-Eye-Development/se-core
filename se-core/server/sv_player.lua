function SECore.CreatePlayer(source)
    local src = source
    local license = GetPlayerIdentifierByType(src, 'license')

    local newPlayerData = {
        source = src,
        license = license,
        name = GetPlayerName(src),
        citizenid = "DUMMY" .. math.random(1000, 9999),
        money = { cash = 500, bank = 10000 },
        job = { name = 'unemployed', label = 'Unemployed', grade = 0 },
        position = { x = -269.4, y = -955.3, z = 31.2, heading = 205.8 },
        metadata = { hunger = 100, thirst = 100 },
        inventory = {}
    }

    SECore.Players[src] = newPlayerData
    TriggerClientEvent('SECore:Client:SetPlayerData', src, newPlayerData)
    print(string.format("New character created for player %s.", license))
end

function SECore.LoadCharacter(source, citizenid)
    local src = source
    local license = GetPlayerIdentifierByType(src, 'license')
    local result = MySQL.query.await('SELECT * FROM players WHERE citizenid = ? AND license = ?', { citizenid, license })

    if result and result[1] then
        local playerData = result[1]
        playerData.money = json.decode(playerData.money)
        playerData.job = json.decode(playerData.job)
        playerData.position = json.decode(playerData.position)
        playerData.metadata = json.decode(playerData.metadata)
        playerData.inventory = json.decode(playerData.inventory) or {}
        playerData.source = src
        playerData.name = GetPlayerName(src)
        SECore.Players[src] = playerData
        
        TriggerClientEvent('SECore:Client:SetPlayerData', src, playerData)
        TriggerClientEvent('se-spawn:client:openSelector', src, playerData.position)
        TriggerEvent('se-core:characterLoaded', src, playerData)
        TriggerClientEvent('se-lib:client:notify', src, { title = 'Character Loaded', description = 'Welcome back, ' .. playerData.name, type = 'success'})
        print(string.format("Character %s (%s) for player %s has been loaded.", playerData.name, citizenid, license))
    else
        DropPlayer(src, "Could not load the selected character data.")
    end
end

RegisterNetEvent('SECore:Server:LoadCharacter', function(citizenid)
    SECore.LoadCharacter(source, citizenid)
end)

exports('LoadCharacter', function(source, citizenid)
    SECore.LoadCharacter(source, citizenid)
end)

-- THIS IS THE NEW, UNIFIED AND SAFE SAVE FUNCTION
function SECore.UpdateAndSavePlayer(source, updatedPlayerData)
    if not SECore.Players[source] then 
        print('^1[SE-Core Error] UpdateAndSavePlayer failed: Player does not exist in the core table.^7')
        return 
    end

    -- Replace the old player data with the new, correct data
    SECore.Players[source] = updatedPlayerData
    local playerData = SECore.Players[source]

    -- Now, proceed with the save logic using the guaranteed-correct data
    local playerPed = GetPlayerPed(source)
    if playerPed and playerPed > 0 then
        local finalCoords = GetEntityCoords(playerPed)
        local finalHeading = GetEntityHeading(playerPed)
        playerData.position = {x = finalCoords.x, y = finalCoords.y, z = finalCoords.z, heading = finalHeading}
    end

    MySQL.update.await(
        'UPDATE players SET money = ?, job = ?, position = ?, metadata = ?, inventory = ? WHERE citizenid = ?',
        {
            json.encode(playerData.money),
            json.encode(playerData.job),
            json.encode(playerData.position),
            json.encode(playerData.metadata),
            json.encode(playerData.inventory or {}),
            playerData.citizenid
        }
    )
end
exports('UpdateAndSavePlayer', SECore.UpdateAndSavePlayer)


function SECore.AddItem(source, itemData)
    local player = SECore.Players[source]
    if not player or not player.citizenid then return false end

    if type(player.inventory) == 'string' then
        player.inventory = json.decode(player.inventory)
    end
    player.inventory = player.inventory or {}

    local itemName = itemData.name
    local amount = itemData.amount
    local itemInfo = itemData.itemInfo

    if itemInfo.stack then
        local found = false
        for i=1, #player.inventory do
            if player.inventory[i] and player.inventory[i].name == itemName then
                player.inventory[i].count = player.inventory[i].count + amount
                found = true
                break
            end
        end
        if not found then
            table.insert(player.inventory, { name = itemName, count = amount, slot = #player.inventory + 1 })
        end
    else
        for i=1, amount do
            table.insert(player.inventory, { name = itemName, count = 1, slot = #player.inventory + 1 })
        end
    end

    -- After adding an item, we now call the new unified save function
    SECore.UpdateAndSavePlayer(source, player)
    TriggerClientEvent('se-inventory:client:refresh', source, player.inventory)
    return true
end
exports('AddItem', SECore.AddItem)