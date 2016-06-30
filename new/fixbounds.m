function swarm = fixbounds(swarm, config)
	for n=1:length(swarm)
		particle = swarm{n,1};

		% fix bounds on X
		X = particle.X;
		for i=2:1+config.ndisc+config.ncont
			col = i-1;
			ub = config.ub(col);
			lb = config.lb(col);
			for j=1:config.nrows
				if (X(j,i) > ub)
					X(j,i) = ub;
				elseif (X(j,i) < lb)
					X(j,i) = lb;
				end
			end
		end
		particle.X = X;
		particle = updateIntrs(particle, config);

		p = particle.p;
		% fix bounds on p
		for i=1:config.nrows
			if (p(i)>1)
				p(i) = 1;
			elseif (p(i)<0)
				p(i) = 0;
			end
		end
		p = p / sum(p);
		particle.p = p;

		particle.fitness = evalFitness(particle, config);
		particle = updatePBest(particle);

		swarm(n,1) = particle;
	end
end