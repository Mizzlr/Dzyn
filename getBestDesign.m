function best = getBestDesign(best, population, sorted=true)
	if not(sorted)
		population = sortPopulation(population)
	end
	if (length(best) == 0)
		best = population{1,1};
	else
		design = population{1,1};
		if (design.fitness > best.fitness)
			best = design;
		end
	end
end