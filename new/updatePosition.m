function swarm = updatePosition(swarm, config, velocities)

		for i=1:length(swarm)
			particle = swarm{i,1};
			X = particle.X;
			p = particle.p;

			velocity = velocities{i,1};
			vX = velocity.X;
			vP = velocity.p;
			% whos
			last = 1+config.ndisc+config.ncont;

			X(:,2:last) = X(:,2:last) + vX;
			p = p + vP;

			particle.X = X;
			particle.p = p;

			swarm(i,1) = particle;
		end
end
