tic; 
config.maxIterS1 = 5;
config.maxIterS2 = 10;
config.mutationProbS1 = 0.4;
config.mutationProbS2 = 0.4;
config.elitismRateS1 = 0.4;
config.elitismRateS2 = 0.4;
config.survivalRateS1 = 1 - config.elitismRateS1;
config.survivalRateS2 = 1 - config.elitismRateS2;
config.populationSizeS1 = 25;
config.populationSizeS2 = 10;

config.convThreshold = 0.9;
config.maxResets = 1;
config.MLEB = 0.9999;
config.stage2SelectionRate = 0.4;

factor1.range = [-1, 1];
factor2.range = [-1, 2];
factor3.range = [-1, 2];
factor4.range = [-2, 2];

factor1.type = 'd'; % discrete
factor2.type = 'c'; % discrete
factor3.type = 'd'; % c for continuous
factor4.type = 'd';

model1.factors = { factor1 factor2};
model1.params = {[1],[2]};
model1.linkName = 'logit';
model1.numDesignRuns = 6;

model2.factors = { factor1 factor2 factor3};
model2.params = {[1],[2],[3]};
model2.linkName = 'logit';
model2.numDesignRuns = 6;

model3.factors = { factor1 factor2 factor3 factor4};
model3.params = {[1],[2],[3],[4]};
model3.linkName = 'logit';
model3.numDesignRuns = 6;

numDesigns = 1;

Algo = @(p) MSMAv2(config, p);

disp('Generating Designs for 2^2 discrete factorial design');
design(Algo, model3, numDesigns);
% design(config, model2, numDesigns);
% design(config, model3, numDesigns);
toc;

function [] = design(Algo, model, numDesigns)
	for i=1:numDesigns
		model.nominalBeta = rand(length(model.params) + 1 ,1) * 3;
		bestDesignMatrix = Algo(model);
		% disp('------------------------------');
		% disp('Best Design computed by ');
		% Algo
		% disp('------------------------------');
		% model
		% bestDesignMatrix
		% disp('------------------------------');
	end
end