tic; 

config.numParticles = 25;
config.maxIter = 100;
config.maxResets = 20;
config.convThreshold = 1e-1;
config.MLEB = 0.85;

factor1.range = [-1, 1];
factor2.range = [-2, 2];
factor3.range = [-1, 1 ,2 , 4];

factor1.type = 'd'; % discrete
factor2.type = 'd'; % discrete
factor3.type = 'd'; % continuous

model.factors = { factor1 factor2 factor3 };
model.params = {[1],[2],[3],[2 3]};
model.nominalBeta = [1.5 2 1.3 -2.4 0.45]';
model.linkName = 'logit';
model.numDesignRuns = 20;

test.numDesigns = 1;
for i=1:test.numDesigns
	model.nominalBeta = rand(length(model.nominalBeta),1) * 3;
	bestDesignMatrix = PSOv3(config, model);
	disp('------------------------------');
	disp('Best Design computed by PSOv3:');
	disp('------------------------------');
	bestDesignMatrix
	disp('------------------------------');
end

toc;
