function [informationMatrix, modelMatrix, psyFunction] = getInformationMatrix(
		designMatrix, model)
	modelMatrix = getModelMatrix(designMatrix, model.params);
	psyFunction = getPsyFunction(model.linkName);
	informationMatrix = zeros(length(model.nominalBeta));
	for i=1:size(designMatrix,1)
		xi = modelMatrix(i,:)';
		eta = xi' * model.nominalBeta;
		informationMatrix = informationMatrix + psyFunction(eta) * xi * xi';
	end
end