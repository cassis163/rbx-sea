local SeaRenderer = require(script.Parent:WaitForChild("SeaRenderer"))
local SeaFloorRenderer = require(script.Parent:WaitForChild("SeaFloorRenderer"))

local Sea = {}
Sea.__index = Sea

function Sea.new(floorHeight, waterHeight, waveFunction)
    local obj = setmetatable({}, Sea)
    obj._seaRenderer = SeaRenderer.new(waveFunction, waterHeight)
    obj._seaFloorRenderer = SeaFloorRenderer.new(floorHeight)

    return obj
end

function Sea:Destroy()
    self._seaRenderer:Destroy()
    self._seaFloorRenderer:Destroy()
end

function Sea:SetParent(parent)
    self._seaRenderer:SetParent(parent)
    self._seaFloorRenderer:SetParent(parent)
end

function Sea:Update(x, y, t)
    self._seaFloorRenderer:Update(x, y)
    self._seaRenderer:Update(x, y, t)
end

return Sea
