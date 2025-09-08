se-core - The Foundation of Your Server
Welcome to se-core, the central framework resource for your FiveM server. This resource is designed to manage player data, handle core server functions, and provide a stable base for all other resources to build upon. It is built to work seamlessly with se-lib.

Features
Player Data Management: A robust system for loading, managing, and saving player data. (Currently simulated, ready for your database integration).

Core Object (SECore): A shared global object available on both client and server for easy access to core functions and player information.

Command System: Examples of both client-side and server-side commands that utilize se-lib for feedback.

Event-Driven: Built around FiveM's event system for reliable and efficient communication.

Configuration File: Easily change core settings in config.lua.

Installation
Ensure you have se-lib installed and started on your server.

Download the se-core folder.

Place it inside your server's resources directory.

Add ensure se-core to your server.cfg after ensure se-lib.

Developer Info
Accessing the Core Object
The SECore object is available globally in any resource that has se-core as a dependency.

Client-Side Example:

To get the current player's data in another resource's client script:

-- First, make sure you add '@se-core/shared/main.lua' to your client_scripts in the fxmanifest.lua

local playerData = SECore.GetPlayerData()
if playerData then
    print("Player's cash: " .. playerData.money.cash)
end

Server-Side Example:

To get a player's data by their source ID in another resource's server script:

-- First, make sure you add '@se-core/shared/main.lua' to your server_scripts in the fxmanifest.lua

-- Example in a server-side command or event
local src = source
local player = SECore.GetPlayer(src)
if player then
    print(player.name .. "'s job is " .. player.job.label)
end

Adding New Player Data
To add new data for players, you would:

Server: Add the new field to the playerData table in se-core/server/player.lua. This is where you would load it from your database.

Server: Make sure you save this new data in the playerDropped event in se-core/server/main.lua.

Client/Shared: The data will automatically be available on the client in the SECore.PlayerData table after the server sends it.