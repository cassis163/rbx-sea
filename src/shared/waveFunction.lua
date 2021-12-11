local AMPLITUDE = 20
local SCALE = 100

return function (p, t)
	return Vector3.new(
		p.X,
		AMPLITUDE * math.sin(p.X / SCALE + t) * math.cos(p.Z / SCALE + t),
		p.Z
	)
end
