function promoted = promotedPopulation(population, config)
	numPromoted = round(config.stage2SelectionRate * length(population));
	promoted = population(1:numPromoted,1);
end