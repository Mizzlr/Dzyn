function parents = selectParents(population, config, stage=1, sorted=true)
	if (stage == 1)
		numParents = round(config.elitismRate1 * length(population));
	else % obviously stage 2
		numParents = round(config.elitismRate2 * length(population));
	end

	if not(sorted)
		% sort population if not already sorted
		population = sortPopulation(population);
	end
	parents = population(1:numParents,1);
end
