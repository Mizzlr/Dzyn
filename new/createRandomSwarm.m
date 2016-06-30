function randomSwarm = createRandomSwarm(config)
	assert(config.popSize > 0);
	randomSwarm = {};
	for i=1:config.popSize
		particle = createRandomDesign(config);
		particle.pbestX = particle.X;
		particle.pbestP = particle.p;
		particle.pbestFitness = particle.fitness;
		randomSwarm(i,1) = particle;
	end
end
