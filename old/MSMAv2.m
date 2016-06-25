function [GGGBest] = MSMAv2(config, model)
	numDesignRuns = model.numDesignRuns; %length(model.params) + 2
	numDesignRunsMax = numDesignRuns + 0;

	if (numDesignRuns < length(model.params))
		error('numDesignRuns should be greater than length(model.params)');
		exit 
	end

	MLEBachieved = false;
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
				% -----------------------------------------------------------
				%  code here

				for iter3=1:floor(config.populationSizeS1 * ...
					config.stage2SelectionRate)

					currIndividual = sortedPopulation{1,i};
					
					% generate population of weights
					population2 = {};
					for j=1:config.populationSizeS2
						randomW = rand(K,1);
						individual2 = [];
						individual2.W = randomW / sum(randomW);
						individual2.X = currIndividual.X;
						individual2.fitnessScore = evaluateFitness(
							individual2, model);
						population2(1,j) = individual2;
					end
					population2;
					sortedPopulation2 = sortPopulation(population2);
					% displayPopulation(sortedPopulation2, 'initial sorted population2');
					
					for iter2=1:config.maxIterS2
						% breed children with Omega3
						% mutate children with Omega4
						numElites2 = floor(config.populationSizeS2 * ...
							config.elitismRateS2);
						children2 = {};

						for i=1:2:numElites2
							father = sortedPopulation2{1,i};
							mother = sortedPopulation2{1,i+1};

							[child1, child2] = Omega3(father, mother, model);
					
							child1 = Omega4(child1, config.mutationProbS2, model);
							child2 = Omega4(child2, config.mutationProbS2, model);

							child1.fitnessScore = evaluateFitness(child1, model);
							child2.fitnessScore = evaluateFitness(child2, model);
					
							children2(1,i) = child1;
							children2(1,i+1) = child2;
						end
						% displayPopulation(children2, 'Child population - 2');

						% select survivers and create new population
						numSurvivers2 = ceil(config.populationSizeS2 * ...
							config.survivalRateS2);

						survivers2 = {};
						for i=1:numSurvivers2
							survivers2(1,i) = sortedPopulation2(1,i);
						end
			
						% displayPopulation( survivers2, 'surviver population');
						
						% merge the population (survivers and children)
						% population2 = survivers;
						for i=1:length(children2)
							survivers2(1,end+1) = children2{1,i};
						end
						
						sortedPopulation2 = sortPopulation(survivers2);

						% displayPopulation( sortedPopulation2,'sortedPopulation2 ');

						% update GBest
						if (iter1 == 1 && iter3 == 1 && iter2 == 1)
							GBest = sortedPopulation2{1,1};
						else
							Best = sortedPopulation2{1,1};
						 	if (!iscomplex(Best.fitnessScore) &&
						 		GBest.fitnessScore < Best.fitnessScore)
						 		GBest = Best;
						 	end
						end
			
						% check if lower bound is achieved 
						currGBestMLEB = 0;
						if (GBest.fitnessScore > -100)
							GBestSenstivity = evalSensitivityv2(GBest,model);
							currGBestMLEB = evalDEfficiency(max(GBestSenstivity), ...
								length(model.nominalBeta));
							GBest.MLEB = currGBestMLEB;
							
							if (currGBestMLEB > config.MLEB)
								disp(sprintf('MLEB of %f > %f achieved. Stopping Algorithm.',
								currGBestMLEB, config.MLEB));
								MLEBachieved = true;
								break;
							end
						end 

% out of indent, note that
disp(sprintf('Reset: %d iter1: %d currIndividual: %d iter2: %d GBestScore: %f GBestMLEB: %f',
reset, iter1, iter3, iter2, GBest.fitnessScore, currGBestMLEB));
					end

					if(MLEBachieved)
						break
					end

				end % end of stage 2
				% -----------------------------------------------------------

				if (!exist('GBest'))
					GBest = population{1,1};
				else
					Best = population{1,1};
				 	if (!iscomplex(Best.fitnessScore) &&
				 		GBest.fitnessScore < Best.fitnessScore)
				 		GBest = Best;
				 	end
				end
				
				if(MLEBachieved)
					break
				end
				
				[convergence, achieved] = converged(GBest,
					population, config.convThreshold);
				if  (convergence == 1)
					disp(sprintf(
				'%2.2f %% of the population has converged. Resetting now.',
						achieved * 100));
					break
				end

			end % end of stage 1

			if (reset == 1)
				GGBest = GBest;
			else
			 	if (GGBest.fitnessScore < GBest.fitnessScore)
			 		GGBest = GBest;
			 	end
			end

			if(MLEBachieved)
						break
			end
			

		end % end of resets 

		if (K == numDesignRuns)
			GGGBest = GGBest;
		else
		 	if (GGGBest.fitnessScore < GGBest.fitnessScore)
		 		GGGBest = GGBest;
		 	end
		end

		if(MLEBachieved)
						break
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
	%n = partition(individual.W, size(individual.W,1));
	n = individual.W * size(individual.W,1);

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

function [child1, child2] = Omega3(father, mother, model)
	spliceIndex = randperm(size(father.X,1),1);

	child1.X = father.X;
	child2.X = mother.X;
	% note: father.X and mother.X have the same value in Stage 2

	child1.W = [father.W(1:spliceIndex,:);
				mother.W(spliceIndex+1:end,:)];
	child2.W = [mother.W(1:spliceIndex,:);
				father.W(spliceIndex+1:end,:)];

	child1.W = child1.W / sum(child1.W);
	child2.W = child2.W / sum(child2.W);
end

function [mutatedChild] = Omega4(child, mutationProbS2, model)

	numMutationSites2 = 3;
	mutatedChild = child;
	if (rand < mutationProbS2)
		for i=1:numMutationSites2
			mutationSite = randperm(length(child.W),1);
			mutatedChild.W(mutationSite,1) = rand / length(child.W); 
			mutatedChild.W = mutatedChild.W / sum(mutatedChild.W);
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

function [convergence, achieved] = converged(GBest, particles, convThreshold)
	
	convergence = ones(length(particles),1);
	Best = GBest;
	BestSum = sqrt(sum(sum(Best.X .^ 2)));
	for i=1:length(particles)
		particle = particles{1,i};
		convergence(i,1) = sqrt(sum(sum((Best.X - particle.X) .^ 2))) / BestSum;
	end 
	%convergence;
	% when 90% of the particles are close to GBest then the swarm is consider to have
	% converged, unlike suggested in the paper
	achieved = sum(convergence < convThreshold) / length(convergence) ;
	convergence = achieved >  0.9; %FIXME
	%convThreshold = max(convergence)
end 

