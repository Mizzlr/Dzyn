function [GGBest] = PSOv3(config, model)

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
		particles = {};

		for i=1:config.numParticles
			particle.body = getRandomDesignMatrix(model.factors, ...
				model.numDesignRuns);
			particle.info = getInformationMatrix(particle.body, model);
			particle.score = evalDOptimalityScore(particle.info);
			particles(1,i) = particle;
			PBests(1,i) = particle;
		end
		GBest = getGBest(PBests);


		currGBestMLEB = 0;
		
		iter = 1;

		velocities = {};
		for i=1:config.numParticles
			velocities(1,i) = zeros(size(particles{1,i}.body));
		end

	 	while (iter <= config.maxIter)
	 		% update velocity
			for i=1:config.numParticles
				velocities(1,i) = inertiaFactor * velocities{1,i} + ...
					cognitiveLearingFactor * rand * ...
					distance(PBests{1,i},particles{1,i}) + ...
					socialLearningFactor   * rand * ...
					distance(GBest{1,1},particles{1,i});
			end
			
			if (inertiaFactor > 0.4)
				inertiaFactor = inertiaFactor - 0.01;
			end 
	 		% update position calculate fitness and update PBests
	 		% loop normalization (compute velocity, new position and update PBest) 
	 		% all in the same loop
	 		for i=1:config.numParticles
	 			particle = particles{1,i};
	 			velocity = velocities{1,i};
	 			particle.body = particle.body + velocity;


				% TODO:// constrain the support point to the compact design space

				particle.info = getInformationMatrix(particle.body, model);
				particle.score = evalDOptimalityScore(particle.info);
				
	 			particles(1,i) = particle;
	 			Best = PBests{1,i};
				if (particle.score > Best.score)
					PBests(1,i) = particles{1,i};
				end
	 		end 

	 		% update GBest
	 		GBest = getGBest(PBests);
	 		Best = GBest{1,1};
	 		disp(sprintf('Reset: %d Iter: %d Score: %f\n',reset,iter,Best.score));
	 		
	 		% check equivalence theorem
	 		% GBestSenstivity = evalSensitivity(Best.body,model);
	 		% disp(sprintf('GBest MLEB: %f', max(GBestSenstivity)));

	 		% if (max(GBestSenstivity) < 0)
	 		% 	disp('Current GBest is D-Optimal');
	 		% end


	 		% check if the swarm has converged or lost in search space
	 		if (Best.score <= -30)
	 			disp('The swarm is lost in search terrain. Resetting now.');
	 			break;
	 		end 
	 		

	 		[convergence, achieved] = converged(GBest, particles,config.convThreshold);
	 		if  (convergence == 1)
				disp(sprintf('%2.2f %% of the swarm has converged. Resetting now.',
					achieved * 100));
				break
			end


	 		iter ++;
	 	end

	 	disp(sprintf('\n============================================\n'));
		% update the all time best (a.k.a Global Global best, GGBest)
		if (reset == 1)
			GGBest = GBest;
		else
			GG = GGBest{1,1};
			G = GBest{1,1};
			if (GG.score < G.score)
				GGBest = GBest;
			end
		end

	 	% check if lower bound is achieved 
	 	Best = GBest{1,1};
	 	GBestSenstivity = evalSensitivity(Best.body,model);
	 	currGBestMLEB = evalDEfficiency(max(GBestSenstivity), ...
	 		length(model.nominalBeta))

		if (currGBestMLEB > config.MLEB && Best.score > -5)
			disp(sprintf('MLEB of %f > %f achieved. Stopping Algorithm.',
				currGBestMLEB, config.MLEB));
			break
		end
		reset ++;
	end
end

function [GBest] = getGBest(PBests)
	scores = zeros(length(PBests),1);
	for i=1:length(PBests)
		scores(i,1) = PBests{1,i}.score;
	end 
	[_, index] = max(scores,[],1);
	GBest = PBests(index);
end

function [distances] = distance(Best, Pos)
	distances = Best.body - Pos.body;
end


function [convergence, achieved] = converged(GBest, particles,convThreshold)
	convergence = ones(length(particles),1);
	Best = GBest{1,1};
	BestSum = sqrt(sum(sum(Best.body .^ 2)));
	for i=1:length(particles)
		particle = particles{1,i};
		convergence(i,1) = sqrt(sum(sum(distance(Best,particle) .^ 2))) / BestSum;

	end 
	%convergence;
	% when 90% of the particles are close to GBest then the swarm is consider to have
	% converged, unlike suggested in the paper
	achieved = sum(convergence < convThreshold) / length(convergence) ;
	convergence = achieved >  0.9; %FIXME
	%convThreshold = max(convergence)
end 