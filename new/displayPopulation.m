function displayPopulation(population, message='somePopulation')
	disp(sprintf('\nPopulation: %s (%d)', message, length(population)));
	disp('----------------------------');
	for i=1:length(population)
		design = population{i,1};
		disp(sprintf('Design: %d fitness: %.2f', i, design.fitness));
	end
end