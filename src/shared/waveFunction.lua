return function (p, t)
	return Vector3.new(
		p.X,
		math.sin(p.X + t) + math.cos(p.Z + t) * 20,
		p.Z
	)
end
