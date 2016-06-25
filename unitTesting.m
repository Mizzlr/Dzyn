config = getConfig(1)

% -- testing --
design = createRandomDesign(config);
fitness = evalFitness(design, config);

population = createRandomPopulation(config);
displayPopulation(population, 'Intial population');

population = sortPopulation(population);
displayPopulation(population, 'sortedPopulation');

parents = selectParents(population, config, stage=1, sorted=false);
displayPopulation(parents, 'parents');

survivers = selectSurvivers(population, config, stage=1, sorted=false);
displayPopulation(survivers, 'survivers');
% -- end testing --

% to run on terminal, $ octave unitTesting.m