local ServerScriptService = game:GetService("ServerScriptService")
local TimeSyncService = require(ServerScriptService:WaitForChild("Packages").TimeSyncService)

TimeSyncService:Init()
