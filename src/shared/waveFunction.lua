local SCALE = 30
local BIAS = 100

return function (p, t)
	return Vector3.new(
		p.X,
		math.sin(p.X / SCALE + t) * math.cos(p.Z / SCALE + t) + BIAS,
		p.Z
	)
end
