tic; 
% generate designs with all discrete factors numFactors is 2

% setup configuration parameters
config.numParticles = 25;
config.convThreshold = 1e-1;
config.maxIter = 50;
config.maxResets = 10;
config.MLEB = 0.9999;
config.breakOnConvergence = true;

factor1.range = [-1, 1];
factor2.range = [-1, 1];

factor1.type = 'd'; % discrete
factor2.type = 'c'; % discrete

model.factors = { factor1 factor2};
model.params = {[1],[2]};
model.linkName = 'logit';

model.numDesignRuns = 20;
Algo = @(p) PSOv4(config, p);

numDesigns = 2;

for i=1:numDesigns

	% beta0, beta1 and beta2 are randomly generated in range(-3,3)
	model.nominalBeta = rand(length(model.params) + 1 ,1) * 3;

	bestDesignMatrix = Algo(model);
	disp('------------------------------');
	disp('Best Design computed by ');
	Algo
	disp('------------------------------');
	model
	bestDesignMatrix
	disp('------------------------------');
end
toc;