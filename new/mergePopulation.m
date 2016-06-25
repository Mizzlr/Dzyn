function population = mergePopulation(pop1, pop2)
	population = pop1;
	for i=1:length(pop2)
		population(end+1,1) = pop2{i,1};
	end
	population = sortPopulation(population);
end