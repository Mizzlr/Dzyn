config = getConfig(1);
best = [];

for reset=1:config.maxReset
	% reset the swarm
	swarm = createRandomSwarm(config);
	gbest = [];
	gbest = getGBestDesign(gbest, swarm);
	inertia = 0.9;
	velocities = getInitialVelocities(config);
	% displayPopulation(swarm, 'Swarm')
	% gbest

	for iter1=1:config.maxIter1

		velocities = updateVelocity(swarm, config, gbest, velocities, inertia);
		swarm = updatePosition(swarm, config, velocities);
		swarm = fixbounds(swarm, config);
		
		% update gbest from swarm
		gbest = getGBestDesign(gbest, swarm);
		% update best from gbest
		if (length(best) == 0)
			best = gbest;
		elseif (gbest.pbestFitness > best.fitness)
			best = gbest;
		end

		disp(sprintf('Run (%d,%d): fitness => %.2f',
			reset, iter1, gbest.pbestFitness));

		if (iter1 <= 40)
			inertia -= 0.01;
		end
	end
end

disp(sprintf('\n# Best design fitness => %.2f', best.fitness));


