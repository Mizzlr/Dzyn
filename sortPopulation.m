function sortedPopulation = sortPopulation(population)
	fitnesses = ones(length(population),1);
	for i=1:length(population)
		design = population{i,1};
		fitnesses(i) = design.fitness;
	end

	[_, indexes] = sort(fitnesses);
	sortedPopulation = {};
	popSize = length(population);

	for i=1:length(indexes)
		index = indexes(i,1);
		sortedPopulation(popSize-i+1,1) = population{index,1};
	end 
end