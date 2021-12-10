local scaleMesh = require(script.Parent:WaitForChild("scaleMesh"))

local SeaRenderer = {}
SeaRenderer.__index = SeaRenderer

function SeaRenderer:Update(x, y, t)
    self:_Reposition(x, y)

	for _, bone in pairs(self._bones) do
		bone.WorldPosition = self._waveFunction(bone.WorldPosition, t)
	end
end

function SeaRenderer:_Init()
    self:_Normalize()
    self:_Resize(10)
    self:_TransformToCircle()
	self._mesh.Parent = self._parent
end

function SeaRenderer.new(mesh, waveFunction, parent, distanceFactor)
	local obj = setmetatable({}, SeaRenderer)
	obj._mesh = mesh
	obj._meshPlane = mesh:WaitForChild("Plane")
	obj._waveFunction = waveFunction
	obj._parent = parent
	obj._distanceFactor = distanceFactor or 3
    obj._bones = obj:_GetBones()
	obj:_Init()

	return obj
end

function SeaRenderer:_Reposition(x, y)
    self._meshPlane.CFrame = CFrame.new(x, 0, y)
end

function SeaRenderer:_GetBones()
	local bones = {}
	for _, child in pairs(self._meshPlane:GetChildren()) do
		if child:IsA("Bone") then
			table.insert(bones, child)
		end
	end

	return bones
end

function SeaRenderer:_Resize(radius)
	scaleMesh(self._meshPlane, Vector3.new(radius, 1, radius))
end

function SeaRenderer:_Normalize()
    -- Normalize the mesh to 1x1
	scaleMesh(self._meshPlane, Vector3.new(1, 1, 1) / self._meshPlane.Size)
end

function SeaRenderer:_TransformToCircle()
    -- This is essentially a triangle wave with a reach of [1, sqrt(2)] with a period of pi
    local function getDistanceRatio(theta)
        local t = theta
        local p = math.pi
        local a = math.sqrt(2) - 1

        -- Inspired by https://www.calculushowto.com/triangle-wave-function/https://www.calculushowto.com/triangle-wave-function/
        return a * math.abs(4 / p * (t - p / 2 * math.floor(2 * t / p + 0.5 )) * (-1)^math.floor(2 * t / p + 0.5)) + 1
    end

    for _, bone in pairs(self._bones) do
        local bX = bone.Position.X
        local bY = bone.Position.Z
        local theta = math.atan2(bY, bX)
        local k = getDistanceRatio(theta)

        -- Reposition the bones to transform the mesh from rectangular to circular
        bone.Position /= Vector3.new(k, 1, k)

        local d = bone.Position.Magnitude
        if d > 1 then
            bone.Position *= d^(1 + self._distanceFactor)
        end
    end
end

return SeaRenderer
