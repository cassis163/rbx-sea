local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TimeSyncService = require(ReplicatedStorage:WaitForChild("SharedPackages").TimeSyncService)

local Common = ReplicatedStorage:WaitForChild("Common")
local Sea = require(Common:WaitForChild("Sea"))
local waveFunction = require(Common:WaitForChild("waveFunction"))
local Camera = workspace.CurrentCamera

TimeSyncService:Init()
TimeSyncService:WaitForSyncedClock()

local SyncedClock = TimeSyncService:GetSyncedClock()
local SeaInstance = Sea.new(19, 50, waveFunction)

local t = tick()
SeaInstance:Update(Camera.CFrame.X, Camera.CFrame.Z, t)
SeaInstance:SetParent(workspace)

-- Update the sea right before rendering a new frame
RunService.RenderStepped:Connect(function(deltaTime)
    -- Ensure that the time is synchronized with the server
    if SyncedClock:IsSynced() then
        t = SyncedClock:GetTime()
    else
        t += deltaTime
    end

	SeaInstance:Update(Camera.CFrame.X, Camera.CFrame.Z, t)
end)
