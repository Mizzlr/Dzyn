function [GBest] = PSOv2(config, model)

	% initialize PSO parameters
	inertiaFactor = 0.9;
	cognitiveLearingFactor = 2;
	socialLearningFactor = 2;

	% initialize swarm of particles
	designMatrix = getRandomDesignMatrix(model.factors, ...
		model.numDesignRuns);

	PBests = {};
	particles = {};
	for i=1:config.numParticles
		particles(1,i) = getRandomWeights(model.numDesignRuns);
		PBests(1,i) = particles(1,i);
	end	
	GBest = getGBest(PBests, designMatrix, model)

	currGBestMLEB = 0;
	reset = 1;
	while (reset < config.maxResets)

		currConvThreshold = 1e4 * config.convThreshold;
		iter = 1;

		velocities = {};
		for i=1:config.numParticles
			velocities(1,i) = rand(model.numDesignRuns,1);
		end

		while (iter < config.maxIter)
			% update velocity
			for i=1:config.numParticles
				velocities(1,i) = inertiaFactor * velocities{1,i} + ...
					cognitiveLearingFactor * rand * ...
					distance(PBests{1,i},particles{1,i}) + ...
					socialLearningFactor   * rand * ...
					distance(GBest,particles{1,i});
			end

			if (inertiaFactor > 0.4)
				inertiaFactor = inertiaFactor - 0.01;
			end 
			
			% update position
			for i=1:config.numParticles
				particles(1,i) = particles{1,i} + velocities{1,i};
				particles(1,i) = particles{1,i} / sum(particles{1,i});
			end 

			% calculate fitness and updat PBest
			
			for i=1:config.numParticles
				informationMatrix = getInformationMatrixv2(designMatrix, model,
					particles{1,i});
				optimalityScoresParticle = evalDOptimalityScore(informationMatrix);
				informationMatrix = getInformationMatrixv2(designMatrix, model,
					PBests{1,i});
				optimalityScoresPBest = evalDOptimalityScore(informationMatrix);
				if (optimalityScoresParticle > optimalityScoresPBest)
					PBests(1,i) = particles{1,i};
				end
			end
			% update GBest
			GBest = getGBest(PBests, designMatrix, model)
			
			% check equivalence theorem
			if (currConvThreshold < config.convThreshold)
				break
			end

			iter ++;
		end

		GBestSenstivity = evalSensitivityv2(designMatrix,model,GBest);

		currGBestMLEB = evalDEfficiency(max(GBestSenstivity), ...
			length(model.nominalBeta))

		if (currGBestMLEB > config.MLEB)
			break
		end
		
		designMatrix = getRandomDesignMatrix(model.factors, ...
			model.numDesignRuns);
			
		for i=1:config.numParticles
			particles(1,i) = getRandomWeights(model.numDesignRuns);
		end
		reset ++;
	end
end

function [GBest] = getGBest(PBests, designMatrix, model)
	optimalityScores = zeros(length(PBests),1);

	for i=1:length(PBests)
		informationMatrix = getInformationMatrixv2(designMatrix, model, PBests{1,i});
		optimalityScores(i) = evalDOptimalityScore(informationMatrix);
	end
	optimalityScores
	[_, index] = max(optimalityScores,[],1)
	GBest = PBests{1,index};
end

function [distance] = distance(Bests, Pos)
	distance = Bests - Pos;
end