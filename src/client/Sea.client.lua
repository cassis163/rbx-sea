local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TimeSyncService = require(ReplicatedStorage:WaitForChild("SharedPackages").TimeSyncService)

local Common = ReplicatedStorage:WaitForChild("Common")
local SeaRenderer = require(Common:WaitForChild("SeaRenderer"))
local waveFunction = require(Common:WaitForChild("waveFunction"))
-- Clone the skinned mesh that you want to use for the sea
local SeaMesh = ReplicatedStorage:WaitForChild("SeaMesh")
local Camera = workspace.CurrentCamera

local Renderer = SeaRenderer.new(SeaMesh:Clone(), waveFunction, workspace)

TimeSyncService:Init()
TimeSyncService:WaitForSyncedClock()

local SyncedClock = TimeSyncService:GetSyncedClock()
local t = tick()
-- Update the sea right before rendering a new frame
RunService.RenderStepped:Connect(function(deltaTime)
    -- Ensure that the time is synchronized with the server
    if SyncedClock:IsSynced() then
        t = SyncedClock:GetTime()
    else
        t += deltaTime
    end

	Renderer:Update(Camera.CFrame.X, Camera.CFrame.Z, t)
end)
