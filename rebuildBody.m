function newPopulation = rebuildBody(population, config)
	newPopulation = {};
	for i=1:length(population)
		design = population{i,1};
		newPopulation(i,1) = updateIntrs(design, config);
	end	
end