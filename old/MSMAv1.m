function [GGGBest] = MSMAv1(config, model)
	numDesignRuns = length(model.params) + 1
	numDesignRunsMax = numDesignRuns + 2

	for K=numDesignRuns:numDesignRunsMax
		for reset=1:config.maxResets
			% generate initial random population
			% evaluate fitness of the population 
			% and sort them by fitness scores
			population = {};
			for i=1:config.populationSizeS1
				individual = generateRandomIndividual(
					model.factors, K);
				fitnessScore = evaluateFitness(individual, model);
				individual.fitnessScore = fitnessScore;
				population(1,i) = individual;
			end

			sortedPopulation = sortPopulation(population);
			% displayPopulation(sortedPopulation, 'Sorted population');

			% stage 1
			for iter1=1:config.maxIterS1

				% breed child population using genetic operator Omega1
				% and apply mutation using genetic operator Omega2
				numElites = floor(config.populationSizeS1 * ...
					config.elitismRateS1);
				children = {};
				for i=1:2:numElites
					father = sortedPopulation{1,i};
					mother = sortedPopulation{1,i+1};

					[child1, child2] = Omega1(father, mother, model);
					
					child1 = Omega2(child1, config.mutationProbS1, model);
					child2 = Omega2(child2, config.mutationProbS1, model);

					child1.fitnessScore = evaluateFitness(child1, model);
					child2.fitnessScore = evaluateFitness(child2, model);
					
					children(1,i) = child1;
					children(1,i+1) = child2;
				end
				% displayPopulation(children, 'Child population');

				% select the surviver
				numSurvivers = ceil(config.populationSizeS1 * ...
					config.survivalRateS1);

				survivers = {};
				for i=1:numSurvivers
					survivers(1,i) = sortedPopulation(1,i);
				end
				% displayPopulation( survivers, 'surviver population');
				% merge the population (survivers and children)
				population = survivers;
				for i=1:length(children)
					population(1,end+1) = children{1,i};
				end
				sortedPopulation = sortPopulation(population);

				% displayPopulation( sortedPopulation,'merged population');

				% stage 2
				% --------------------------
				%  code here
				% --------------------------

				if (iter1 == 1)
					GBest = population{1,1};
				else
					Best = population{1,1};
				 	if (!iscomplex(Best.fitnessScore) &&
				 		GBest.fitnessScore < Best.fitnessScore)
				 		GBest = Best;
				 	end
				end

				
				% check if lower bound is achieved 
				currGBestMLEB = 0;
				if (GBest.fitnessScore > -15)
					GBestSenstivity = evalSensitivity(GBest.X,model);
					currGBestMLEB = evalDEfficiency(max(GBestSenstivity), ...
						length(model.nominalBeta));

					if (currGBestMLEB > config.MLEB)
						disp(sprintf('MLEB of %f > %f achieved. Stopping Algorithm.',
						currGBestMLEB, config.MLEB));
						break;
					end
				end 
				disp(sprintf('K = %d, reset = %d, iter1 = %d, GBestScore = %f, GBestMLEB = %f',
					K, reset, iter1, GBest.fitnessScore, currGBestMLEB));
			end % end of stage 1

			if (reset == 1)
				GGBest = GBest;
			else
			 	if (GGBest.fitnessScore < GBest.fitnessScore)
			 		GGBest = GBest;
			 	end
			end

		end % end of resets 

		if (K == numDesignRuns)
			GGGBest = GGBest;
		else
		 	if (GGGBest.fitnessScore < GGBest.fitnessScore)
		 		GGGBest = GGBest;
		 	end
		end
	end % end of K=k:k+j
end


function [fitnessScore] = evaluateFitness(individual, model)
	if (any(strcmp('fitnessScore',fieldnames(individual))))
		fitnessScore = individual.fitnessScore;
		return
	end

	modelMatrix = getModelMatrix(individual.X, model.params);
	psyFunction = getPsyFunction(model.linkName);
	informationMatrix = zeros(length(model.nominalBeta));
	n = partition(individual.W, size(individual.W,1));

	for i=1:size(individual.X,1)
		xi = modelMatrix(i,:)';
		eta = xi' * model.nominalBeta;
		informationMatrix = informationMatrix + ...
			n(i,1) * psyFunction(eta) * xi * xi';
	end

	fitnessScore = log(det(informationMatrix));
end

function [sortedPopulation] = sortPopulation(population)
	scores = zeros(length(population),1);
	
	% extract fitness scores
	for i=1:length(population)
		individual = population{1,i};
		scores(i,1) = individual.fitnessScore;
	end

	% sort the scores
	[_, indices] = sort(scores);
	sortedPopulation = {};
	
	% build the sorted population in descending order
	populationSizeS1 = length(population);
	for i=1:populationSizeS1
		index = indices(i,1);
		sortedPopulation(1,populationSizeS1 + 1 - i) = ...
			population{1,index};
	end

end

function [child1, child2] = Omega1(father, mother, model)
	spliceIndex = randperm(size(father.X,1),1);

	child1.W = father.W;
	child2.W = mother.W;
	% note: father.W and mother.W have the same value in Stage 1

	child1.X = [father.X(1:spliceIndex,:);
				mother.X(spliceIndex+1:end,:)];
	child2.X = [mother.X(1:spliceIndex,:);
				father.X(spliceIndex+1:end,:)];

end

function [mutatedChild] = Omega2(child, mutationProbS1, model)
	numMutationSites = 3;
	mutatedChild = child;
	if (rand < mutationProbS1)
		% generate mutatant genes
		genes = generateRandomIndividual(model.factors,
			numMutationSites);
		% apply mutation
		for i=1:numMutationSites
			mutationSite = randperm(size(child.X,1),1);
			mutatedChild.X(mutationSite,:) = genes.X(i,:);
		end
	end
end


function [] = displayPopulation(population, msg)

	disp(msg)
	disp('---------------------------------');
	for i=1:length(population)
		individual = population{1,i};
		disp(sprintf('individual %d: score %f\n',
			i,individual.fitnessScore));
	end
	disp('---------------------------------');	
end