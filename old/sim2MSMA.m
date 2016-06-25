tic; 

config.maxIterS1 = 2;
config.maxIterS2 = 10;
config.mutationProbS1 = 0.4;
config.mutationProbS2 = 0.4;
config.elitismRateS1 = 0.35;
config.elitismRateS2 = 0.4;
config.survivalRateS1 = 1 - config.elitismRateS1;
config.survivalRateS2 = 1 - config.elitismRateS2;
config.populationSizeS1 = 5;
config.populationSizeS2 = 10;

config.maxResets = 1;
config.MLEB = 0.85;

factor1.range = [-1, 1];
factor2.range = [-2, 2];
factor3.range = [-1, 1 ,2 , 4];

factor1.type = 'd'; % discrete
factor2.type = 'c'; % discrete
factor3.type = 'd'; % continuous

model.factors = { factor1 factor2 factor3 };
model.params = {[1],[2],[3],[2 3]};
model.nominalBeta = [1.5 2 1.3 -2.4 0.45]';
model.linkName = 'logit';

test.numDesigns = 1;
for i=1:test.numDesigns
	% model.nominalBeta = rand(length(model.nominalBeta),1) * 3;
	bestDesignMatrix = MSMAv2(config, model);
	disp('------------------------------');
	disp('Best Design computed by MSMAv2:');
	disp('------------------------------');
	bestDesignMatrix
	disp('------------------------------');
end

toc;
