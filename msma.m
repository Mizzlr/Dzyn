config = getConfig(1);
best = [];

for reset=1:config.maxReset
	% reset the population
	population = createRandomPopulation(config);

	for iter1=1:config.maxIter1
		% stage 1 of MSMA
		population = sortPopulation(population);
		parents = selectParents(population, config, stage=1, sorted=true);
		survivers = selectSurvivers(population, config, stage=1, sorted=true);

		children = breedChildren(parents, config, stage=1);
		mutants = applyMutation(children, config, stage=1);
		population = mergePopulation(survivers, mutants);

		population = sortPopulation(population);
		population2 = promotedPopulation(population, config);
		disp('')
		
		for iter2=1:config.maxIter2
			% stage 2 of MSMA
			parents2 = selectParents(population2, config, stage=2, sorted=true);
			survivers2 = selectSurvivers(population2, config, stage=2, sorted=true);

			children2 = breedChildren(parents2, config, stage=2);
			mutants2 = applyMutation(children2, config, stage=2);
			population2 = mergePopulation(survivers2, mutants2);
			
			disp(sprintf('Run (%d,%d,%d): fitness => %.2f',
				reset, iter1, iter2, overallFitness(population2)));
			best = getBestDesign(best, population2);
			% displayPopulation(parents2,'parents2');
			% displayPopulation(mutants2,'mutants2');
			% displayPopulation(survivers2,'survivers2');
			% displayPopulation(population2,'pop2');
		end
	end
end

disp(sprintf('\n# Best design fitness => %.2f', best.fitness));


