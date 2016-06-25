function [sensitivity] = evalSensitivityv2(individual, model)

	modelMatrix = getModelMatrix(individual.X, model.params);
	psyFunction = getPsyFunction(model.linkName);
	informationMatrix = zeros(length(model.nominalBeta));
	% n = partition(individual.W, size(individual.W,1));
	n = individual.W * size(individual.W,1);
	
	for i=1:size(individual.X,1)
		xi = modelMatrix(i,:)';
		eta = xi' * model.nominalBeta;
		informationMatrix = informationMatrix + ...
			n(i,1) * psyFunction(eta) * xi * xi';
	end

	dispersionMatrix = inv(informationMatrix);

	sensitivity = zeros(size(individual.X,1),1);
	for i=1:length(sensitivity)
		x = modelMatrix(i,:)';
		eta = x' * model.nominalBeta;
		sensitivity(i) = psyFunction(eta) * x' * dispersionMatrix * x; 
	end
end