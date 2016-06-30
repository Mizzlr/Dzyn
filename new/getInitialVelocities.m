function velocities = getInitialVelocities(config)
	velocities = {};
	for i=1:config.popSize
		X = zeros(config.nrows, config.ndisc+config.ncont);
		p = rand(config.nrows,1);
		velocity.X = X;
		velocity.p = p / sum(p);
		velocities(i,1) = velocity;
	end
end