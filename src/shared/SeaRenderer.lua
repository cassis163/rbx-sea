local INITIAL_RADIUS = 125
local TEXTURE_STRETCH_FIX = 8

local scaleMesh = require(script.Parent:WaitForChild("scaleMesh"))

local SeaRenderer = {}
SeaRenderer.__index = SeaRenderer

function SeaRenderer.new(mesh, waveFunction, parent, distanceFactor)
	local obj = setmetatable({}, SeaRenderer)
	obj._mesh = mesh
	obj._meshPlane = mesh:WaitForChild("Plane")
    obj._texture = obj._meshPlane:WaitForChild("Texture")
	obj._waveFunction = waveFunction
	obj._parent = parent
	obj._distanceFactor = distanceFactor or 0.1
    obj._bones = obj:_GetBones()
	obj:_Init()

	return obj
end

function SeaRenderer:Update(x, y, t)
    self:_Reposition(x, y)
    self:_UpdateTexture(x, y)
    self:_RecalculateBonePositions(t)
end

function SeaRenderer:_Init()
    self:_Normalize()
    self:_Resize(INITIAL_RADIUS)
    self:_DisplaceBones()
    -- self:_Test()

	self._mesh.Parent = self._parent
end

function SeaRenderer:_RecalculateBonePositions(t)
    for _, bone in pairs(self._bones) do
		bone.WorldPosition = self._waveFunction(bone.WorldPosition, t)
	end
end

function SeaRenderer:_UpdateTexture(x, y)
    -- This should be -x and -y in theory, but the textures are stretched
    self._texture.OffsetStudsU = -x / TEXTURE_STRETCH_FIX
    self._texture.OffsetStudsV = -y / TEXTURE_STRETCH_FIX
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

function SeaRenderer:_DisplaceBones()
    for _, bone in pairs(self._bones) do
        local bX = bone.Position.X
        local bY = bone.Position.Z

        local d = math.sqrt((bX)^2 + (bY)^2)
        local l = -0.01 * d^(1 + self._distanceFactor) + 1
        local k = d^(1 - math.clamp(l, 0, 1))

        bone.Position *= Vector3.new(k, 1, k)
    end
end

-- function SeaRenderer:_Test()
--     for _, bone in pairs(self._bones) do
--         local test = Instance.new("Part")
--         test.Anchored = true
--         test.Shape = Enum.PartType.Ball
--         test.CanCollide = false
--         test.CFrame = bone.WorldCFrame + Vector3.new(0, 50, 0)
--         test.BrickColor = BrickColor.Red()
--         test.Size = Vector3.new(1, 1, 1) * 4
--         test.Parent = workspace
--     end
-- end

return SeaRenderer
