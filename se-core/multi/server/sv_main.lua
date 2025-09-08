-- The SECore object is globally available since we are part of the resource

-- Get characters for a player
RegisterNetEvent('se-multicharacter:server:getCharacters', function()
    local src = source
    local license = GetPlayerIdentifierByType(src, 'license')
    if not license or not MySQL then return end

    print("[SE-MULTI] getCharacters called by " .. src .. " with license " .. license)

    local result = MySQL.query.await('SELECT * FROM players WHERE license = ?', { license })

    print("[SE-MULTI] Sending NUI message to show characters...")
    TriggerClientEvent('se-multicharacter:client:receiveCharacters', src, result or {})
end)

-- Create a new character
RegisterNetEvent('se-multicharacter:server:createCharacter', function(charInfo)
    local src = source
    local license = GetPlayerIdentifierByType(src, 'license')
    if not license or not MySQL then return end

    -- Check if player has reached the character limit
    local characters = MySQL.query.await('SELECT COUNT(id) as charcount FROM players WHERE license = ?', { license })
    if characters[1].charcount >= Config.MaxCharacters then
        exports['se-lib']:notify(src, {
            title = 'Error',
            description = 'You have reached the maximum number of characters allowed.',
            type = 'error'
        })
        TriggerClientEvent('se-multicharacter:client:receiveCharacters', src, {}) -- Reshow UI
        return
    end

    local firstname = tostring(charInfo.firstname)
    local lastname = tostring(charInfo.lastname)

    local citizenid = GenerateCitizenId()
    -- charinfo is now part of metadata in the original se-core, but we will add it for multi-character
    local newCharInfo = {
        firstname = firstname,
        lastname = lastname,
        dob = tostring(charInfo.dob),
        gender = tostring(charInfo.gender),
        backstory = "No story yet."
    }

    local money = { cash = 500, bank = 1000 }
    local job = { name = 'unemployed', label = 'Unemployed', payment = 10 }
    local position = Config.DefaultSpawn
    local metadata = { thirst = 100, hunger = 100, charinfo = newCharInfo }

    MySQL.insert.await(
        'INSERT INTO players (license, citizenid, name, money, job, position, metadata) VALUES (?, ?, ?, ?, ?, ?, ?)',
        {
            license,
            citizenid,
            firstname .. ' ' .. lastname,
            json.encode(money),
            json.encode(job),
            json.encode(position),
            json.encode(metadata)
        }
    )

    print("[SE-MULTI] Character created: " .. citizenid)

    -- Now call the unified LoadCharacter function
    SECore.LoadCharacter(src, citizenid)
end)

-- Delete a character
RegisterNetEvent('se-multicharacter:server:deleteCharacter', function(citizenid)
    if not Config.AllowDelete then return end
    local src = source
    local license = GetPlayerIdentifierByType(src, 'license')
    if not license or not MySQL then return end

    MySQL.update.await('DELETE FROM players WHERE citizenid = ? AND license = ?', { citizenid, license })

    print("[SE-MULTI] Character deleted: " .. citizenid)

    -- Send updated list back to client
    local updatedResult = MySQL.query.await('SELECT * FROM players WHERE license = ?', { license })
    TriggerClientEvent('se-multicharacter:client:receiveCharacters', src, updatedResult or {})
end)

-- Generate a random Citizen ID
function GenerateCitizenId()
    local str = "SE" -- Prefix
    for i = 1, 6 do
        str = str .. string.char(math.random(48, 57)) -- Numbers
    end
    return str
end