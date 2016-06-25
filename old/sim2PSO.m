tic; 

config.numParticles = 25;
config.maxIter = 5;
config.convThreshold = 1e-1;
config.maxResets = 10;
config.MLEB = 0.9999;

factor1.range = [-1, 1];
factor2.range = [-1, 2];
factor3.range = [-1, 2];
factor4.range = [-2, 2];

factor1.type = 'd'; % discrete
factor2.type = 'c'; % discrete
factor3.type = 'd'; % c for continuous
factor4.type = 'd';

model1.factors = {factor1 factor2};
model1.params = {[1],[2]};
model1.linkName = 'logit';
model1.numDesignRuns = 6;

model2.factors = { factor1 factor2 factor3};
model2.params = {[1],[2],[3]};
model2.linkName = 'logit';
model2.numDesignRuns = 6;

model3.factors = { factor1 factor2 factor3 factor4};
model3.params = {[1],[2],[3],[4]};
model3.linkName = 'probit';
model3.numDesignRuns = 16;


Algo = @(p) PSOv4(config, p);

disp('Generating Designs for 2^2 discrete factorial design');
% design(Algo, model3, numDesigns);
% design(config, model2, numDesigns);
% design(config, model3, numDesigns);
toc;

model = model3
numDesigns = 1;
for i=1:numDesigns
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