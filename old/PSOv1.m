function [GBest] = PSOv1(config, model)

	% initialize PSO parameters
	inertiaFactor = 0.9;
	cognitiveLearingFactor = 2;
	socialLearningFactor = 2;

	% initialize swarm of particles
	GBest = [];
	PBests = {};
	particles = {};
	informationMatrices = {};

	for i=1:config.numParticles
		particles(1,i) = getRandomDesignMatrix(model.factors, ...
			model.numDesignRuns);
		PBests(1,i) = particles(1,i);
		informationMatrices(1,i) = getInformationMatrix(PBests{1,i}, ...
			model);
	end
	GBest = getGBest(PBests, informationMatrices)


	currGBestMLEB = 0;
	reset = 1;
	while (reset < config.maxResets)
		currConvThreshold = 1e4 * config.convThreshold;
		iter = 1;

		velocities = zeros(length(particles),1);

		while (iter < config.maxIter)
			% update velocity
			velocities = inertiaFactor * velocities + ...
				cognitiveLearingFactor * rand * distance(PBests,particles) + ...
				socialLearningFactor   * rand * distance({GBest},particles);
			
			if (inertiaFactor > 0.4)
				inertiaFactor = inertiaFactor - 0.01;
			end 
			% update position
			

			% calculate fitness
			

			% update PBest and GBest
			

			% check equivalence theorem
			if (currConvThreshold < config.convThreshold)
				break
			end

			iter ++;
		end

		GBestSenstivity = evalSensitivity(GBest,model);
		currGBestMLEB = evalDEfficiency(max(GBestSenstivity), ...
			length(model.nominalBeta))

		if (currGBestMLEB > config.MLEB)
			break
		end

		reset ++;
	end
end

function [GBest] = getGBest(PBests, informationMatrices)
	optimalityScores = zeros(length(PBests),1);

	for i=1:length(PBests)
		optimalityScores(i) = evalDOptimalityScore(informationMatrices{1,i});
	end

	[_, index] = max(optimalityScores,[],1);
	GBest = PBests{1,index};
end

function [distances] = distance(Bests, Pos)
	distances = rand(length(Pos),1); % FIXME:// define the distance metric.
end