local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TimeSyncService = require(ReplicatedStorage:WaitForChild("SharedPackages").TimeSyncService)
local Player = Players.LocalPlayer

local Common = ReplicatedStorage:WaitForChild("Common")
local Sea = require(Common:WaitForChild("Sea"))
local waveFunction = require(Common:WaitForChild("waveFunction"))

TimeSyncService:Init()
TimeSyncService:WaitForSyncedClock()

local SyncedClock = TimeSyncService:GetSyncedClock()
local SeaInstance = Sea.new(19, 50, waveFunction)

local function update(t)
    local function getPosition()
        local function getTargetInstance()
            local character = Player.Character
            if character then
                local head = character:FindFirstChild("Head")

                return head and head or workspace.CurrentCamera
            end
        end

        local targetInstance = getTargetInstance()

        return targetInstance and targetInstance.CFrame or Vector3.new()
    end

    local position = getPosition()
    SeaInstance:Update(position.X, position.Z, t)
end

local t = tick()

update(t)
SeaInstance:SetParent(workspace)

-- Update the sea right before rendering a new frame
RunService.RenderStepped:Connect(function(deltaTime)
    -- Ensure that the time is synchronized with the server
    if SyncedClock:IsSynced() then
        t = SyncedClock:GetTime()
    else
        t += deltaTime
    end

	update(t)
end)
