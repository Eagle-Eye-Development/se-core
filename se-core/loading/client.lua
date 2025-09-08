local isSpawned = false

AddEventHandler("playerSpawned", function()
	if not isSpawned then
        -- This command closes the loading screen once the player is in the world
		ShutdownLoadingScreenNui()
		isSpawned = true
	end
end)
