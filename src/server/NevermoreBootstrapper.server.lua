local ServerScriptService = game:GetService("ServerScriptService")

local NevermoreModules = ServerScriptService:WaitForChild("Nevermore")
local Loader = require(NevermoreModules:FindFirstChild("loader"))

Loader.bootstrapGame(NevermoreModules)
NevermoreModules:Destroy()
script:Destroy()
