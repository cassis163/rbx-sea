local SeaRenderer = {}
SeaRenderer.__index = SeaRenderer

function SeaRenderer:Update(x, y, t)
    self:_Reposition(x, y)

	for _, bone in pairs(self._bones) do
		bone.WorldPosition = self._waveFunction(bone.WorldPosition, t)
	end
end

function SeaRenderer:_Init()
	self._bones = self:_GetBones()
	self:_Resize()
	self._mesh.Parent = self._parent
end

function SeaRenderer.new(mesh, waveFunction, parent, radius)
	local obj = setmetatable({}, SeaRenderer)
	obj._mesh = mesh
	obj._meshPlane = mesh:WaitForChild("Plane")
	obj._waveFunction = waveFunction
	obj._parent = parent
	obj._radius = radius or 2
    obj._tileSize = 100
	obj:_Init()

	return obj
end

function SeaRenderer:_Reposition(x, y)
    self._meshPlane.CFrame = CFrame.new(x - x % (self._tileSize * self._radius), 0, y - y % (self._tileSize * self._radius))
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

function SeaRenderer:_Resize()
	self._meshPlane.Size = Vector3.new(1, 1, 1)
	for _, bone in pairs(self._bones) do
		bone.WorldPosition = bone.WorldPosition * self._radius
	end
end

return SeaRenderer
