AddEventHandler('playerConnecting', function(_, _, deferrals)
    local source = source

    -- This sends the player's name to the loading screen UI
    deferrals.handover({
        name = GetPlayerName(source)
    })
end)
