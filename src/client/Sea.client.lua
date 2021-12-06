local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Common = ReplicatedStorage:WaitForChild("Common")
local SeaRenderer = require(Common:WaitForChild("SeaRenderer"))
local waveFunction = require(Common:WaitForChild("waveFunction"))
-- Clone the skinned mesh that you want to use for the sea
local SeaMesh = ReplicatedStorage:WaitForChild("SeaMesh")

local renderer = SeaRenderer.new(SeaMesh:Clone(), waveFunction, workspace)

-- Update the sea right before rendering a new frame
RunService.RenderStepped:Connect(function()
	renderer:Update()
end)
