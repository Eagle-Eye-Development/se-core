-- This event is triggered from the client after a spawn location has been selected from the UI
RegisterNetEvent('se-spawn:server:spawnPlayer', function(coords)
    local src = source

    -- Validate the coordinates before spawning
    if not coords or not coords.x or not coords.y or not coords.z then
        print(('[se-spawn] [ERROR] Player %s attempted to spawn with invalid coordinates. Dropping player for security.'):format(src))
        DropPlayer(src, "Invalid spawn coordinates detected.")
        return
    end

    print(('[se-spawn] Spawning player %s at location: X:%.1f Y:%.1f Z:%.1f'):format(src, coords.x, coords.y, coords.z))

    -- Trigger the final spawn event in se-core, which handles the teleportation and screen fades.
    -- This keeps the responsibilities of each resource separate and clean.
    TriggerClientEvent('se-core:client:spawnPlayer', src, coords)
end)
