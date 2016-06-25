function [GGBest] = PSOv4(config, model)

	% initialize PSO parameters
	inertiaFactor = 0.9;
	cognitiveLearingFactor = 2;
	socialLearningFactor = 2;

	GGBest = {};
	reset = 1;
	while (reset <= config.maxResets)
		% initialize swarm of particles
		GBest = {};
		PBests = {};
		swarm = {};

		for i=1:config.numParticles
			particle = generateRandomIndividual(
				model.factors, model.numDesignRuns);
			fitnessScore = evaluateFitness(particle, model);
			particle.fitnessScore = fitnessScore;
			swarm(1,i) = particle;
			PBests(1,i) = particle;
		end

		GBest = getGBest(PBests);

		currGBestMLEB = 0;		
		iter = 1;

		velocitiesX = {};
		velocitiesW = {};

		swarm;

		for i=1:config.numParticles
			particle = swarm{1,i};
			velocitiesX(1,i) = zeros(size(particle.X));
			velocitiesW(1,i) = rand(size(particle.W));
		end

		velocitiesX;
		velocitiesW;

	 	while (iter <= config.maxIter)
			for i=1:config.numParticles

				% update velocity
				velocitiesX(1,i) = inertiaFactor * velocitiesX{1,i} + ...
					cognitiveLearingFactor * rand * ...
					distanceX(PBests{1,i},swarm{1,i}) + ...
					socialLearningFactor   * rand * ...
					distanceX(GBest{1,1},swarm{1,i});

				velocitiesW(1,i) = inertiaFactor * velocitiesW{1,i} + ...
					cognitiveLearingFactor * rand * ...
					distanceW(PBests{1,i},swarm{1,i}) + ...
					socialLearningFactor   * rand * ...
					distanceW(GBest{1,1},swarm{1,i});

				if (inertiaFactor > 0.4)
					inertiaFactor = inertiaFactor - 0.01;
				end 

	 			% update position 
	 			particle = swarm{1,i};
	 			velocityX = velocitiesX{1,i};
	 			velocityW = velocitiesW{1,i};
	 			particle.X = particle.X + velocityX;
	 			particle.W = particle.W + velocityW;
	 			particle.W = particle.W / sum(particle.W);


				%constrain the support point to the compact design space
				particle = constrain(particle, model);

	 			%calculate fitness 
				fitnessScore = evaluateFitness(particle, model);
				particle.fitnessScore = fitnessScore;

				particleSenstivity = evalSensitivityv2(particle,model);
				particle.MLEB = evalDEfficiency(max(particleSenstivity), ...
					length(model.nominalBeta));

				swarm(1,i) = particle;

	 			% update PBests
	 			Best = PBests{1,i};
				if (particle.fitnessScore >= Best.fitnessScore)
					PBests(1,i) = swarm{1,i};
				end
	 		end 

	 		% update GBest
	 		GBest 
	 		GBest = getGBest(PBests);
	 		GBest
		 	% check if lower bound is achieved 
	 		Best = GBest{1,1};
			GBestSenstivity = evalSensitivityv2(Best,model);
			currGBestMLEB = evalDEfficiency(max(GBestSenstivity), ...
				length(model.nominalBeta));
			Best.MLEB = currGBestMLEB;
			
			if (currGBestMLEB > config.MLEB)
				disp(sprintf('#MLEB of %f > %f achieved. Stopping Algorithm.',
				currGBestMLEB, config.MLEB));
				MLEBachieved = true;
				break;
			end

			GBest(1,1) = Best;
			% displaySwarm(swarm,' the swarm ');
	 		disp(sprintf('Reset: %d Iter: %d GBestScore: %f GBestMLEB: %f',
	 			reset,iter,Best.fitnessScore, Best.MLEB));

	 		% check if the swarm has converged or lost in search space
	 		if (Best.fitnessScore <= -30)
	 			disp('#The swarm is lost in search terrain. Resetting now.');
	 			break;
	 		end 
	 		

	 		[convergence, achieved] = converged(GBest, swarm, config.convThreshold);
			if  (convergence == 1)
				if (config.breakOnConvergence)
					disp(sprintf('#%2.2f %% of the swarm has converged. Resetting now.',
						achieved * 100));
					break
				end
			end
			iter ++;
		end
		% update the all time best (a.k.a Global Global best, GGBest)
		if (reset == 1)
			GGBest = GBest;
		else
			GG = GGBest{1,1};
			G = GBest{1,1};
			if (GG.fitnessScore < G.fitnessScore)
				GGBest = GBest;
			end
		end

		% Best = GGBest{1,1};
		% disp(sprintf('Reset: %d GGBestScore: %f\n',
	 % 			reset,Best.fitnessScore));

		reset ++;
	end
end

function [GBest] = getGBest(PBests)
	scores = zeros(length(PBests),1);
	for i=1:length(PBests)
		scores(i,1) = PBests{1,i}.fitnessScore;
	end 
	[_, index] = max(scores,[],1);
	GBest = PBests(index);
end

function [distances] = distanceX(Best, Pos)
	distances = Best.X - Pos.X;
end


function [distances] = distanceW(Best, Pos)
	distances = Best.W - Pos.W;
end


function [particle] = constrain(particle, model)
	for i=1:length(model.factors)
		factor = model.factors{1,i};
		if (factor.type == 'd')
			particle.X(:,i) = round(particle.X(:,i));
		end
		particle.X(:,i) = constrainMinMax(particle.X(:,i),factor.range);
	end 
end

function [vector] = constrainMinMax(vector, minmax)
	for i=1:length(vector)
		if (vector(i) < minmax(1))
			vector(i) = minmax(1);
		elseif (vector(i) > minmax(2))
			vector(i) = minmax(2);
		end
	end 			
end

function [convergence, achieved] = converged(GBest, particles,convThreshold)
	convergence = ones(length(particles),1);
	Best = GBest{1,1};
	BestSum = sqrt(sum(sum(Best.X .^ 2)) + sum(Best.W .^ 2));
	for i=1:length(particles)
		particle = particles{1,i};
		convergence(i,1) = sqrt(sum(sum(distanceX(Best,particle) .^ 2)) + ...
			sum(distanceW(Best, particle) .^ 2)) / BestSum;
	end 
	%convergence;
	% when 90% of the particles are close to GBest then the swarm is consider to have
	% converged, unlike suggested in the paper
	achieved = sum(convergence < convThreshold) / length(convergence) ;
	convergence = achieved >=  1.0; %FIXME
	%convThreshold = max(convergence)
end 


function [fitnessScore] = evaluateFitness(particle, model)
	if (any(strcmp('fitnessScore',fieldnames(particle))))
		fitnessScore = particle.fitnessScore;
		return
	end

	modelMatrix = getModelMatrix(particle.X, model.params);
	psyFunction = getPsyFunction(model.linkName);
	informationMatrix = zeros(length(model.nominalBeta));
	n = partition(particle.W, size(particle.W,1));

	for i=1:size(particle.X,1)
		xi = modelMatrix(i,:)';
		eta = xi' * model.nominalBeta;
		informationMatrix = informationMatrix + ...
			n(i,1) * psyFunction(eta) * xi * xi';
	end

	fitnessScore = log(det(informationMatrix));
end


function [] = displaySwarm(swarm, msg)

	disp(msg)
	disp('---------------------------------');
	for i=1:length(swarm)
		particle = swarm{1,i};
		disp(sprintf('particle %d: score: %f MLEB: %f',
			i,particle.fitnessScore,particle.MLEB));
		disp(mat2str(particle.W'(1:end)))
	end
	disp('---------------------------------');	
end

