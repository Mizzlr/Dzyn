function velocities = updateVelocity(swarm, config, gbest, velocities, inertia)
	for i=1:length(velocities)
		velocity = velocities{i,1};
		particle = swarm{i,1};
		last = 1+config.ndisc+config.ncont;

		particlePos = particle.X(:,2:last);
		pbestPos = particle.pbestX(:,2:last);
		gbestPos = gbest.X(:,2:last);

		pbestP = particle.pbestP;
		gbestP = gbest.p;

		vPrev = inertia * velocity.X;
		cognitive = 2 * rand * (pbestPos - particlePos);
		social = 2 * rand * (gbestPos - particlePos);

		velocity.X = vPrev + cognitive + social;

		[rows, cols] = size(velocity.X);
		for row=1:rows
			for col=1:cols
				if (abs(velocity.X(row,col)) > config.ub(col))
					velocity.X(row,col) = velocity.X(row,col) / ...
						abs(velocity.X(row,col)) * config.ub(col);
				end
			end
		end

		pPrev = inertia * velocity.p;
		cognitive = 2 * rand * (pbestP - particle.p);
		social = 2 * rand * (gbestP - particle.p);

		velocity.p = pPrev + cognitive + social;
		for j=1:length(velocity.p)
			if (velocity.p(j) > 1)
				velocity.p(j) = velocity.p(j) / abs(velocity.p(j));
			end
		end
		velocities(i,1) = velocity;
	end 
end