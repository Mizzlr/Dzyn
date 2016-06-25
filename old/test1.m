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

designMatrix = getRandomDesignMatrix(model.factors, ...
		model.numDesignRuns)

modelMatrix = getModelMatrix(designMatrix, model.params)