local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SeaFloorRenderer = {}
SeaFloorRenderer.__index = SeaFloorRenderer

local function createPart()
    return ReplicatedStorage:WaitForChild("SeaFloor"):Clone()
end

function SeaFloorRenderer.new(height)
    local obj = setmetatable({}, SeaFloorRenderer)
    obj._height = height
    obj._part = createPart()

    return obj
end

function SeaFloorRenderer:Destroy()
    self._part:Destroy()
end

function SeaFloorRenderer:Update(x, y)
    self._part.CFrame = CFrame.new(x, self._height, y)
end

function SeaFloorRenderer:SetParent(parent)
    self._part.Parent = parent
end

return SeaFloorRenderer
