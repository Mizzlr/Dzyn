function population = createRandomPopulation(config)
	assert(config.popSize > 0);
	population = {};
	for i=1:config.popSize
		population(i,1) = createRandomDesign(config);
	end
end