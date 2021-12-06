return function (p, t)
	return Vector3.new(
		p.X,
		p.X * p.Z + t,
		p.Z
	)
end
