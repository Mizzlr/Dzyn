function fitness = overallFitness(population)
	fitnesses = ones(length(population),1);
	for i=1:length(population)
		design = population{i,1};
		fitnesses(i) = design.fitness;
	end
	fitness = mean(fitnesses);
end