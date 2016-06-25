function survivers = selectSurvivers(population, config, stage=1, sorted=true)
	if (stage == 1)
		numSurvivers = round(config.survivalRate1 * length(population));
	else % obviously stage 2
		numSurvivers = round(config.survivalRate2 * length(population));
	end

	if not(sorted)
		% sort population if not already sorted
		population = sortPopulation(population);
	end
	survivers = population(1:numSurvivers,1);
end
