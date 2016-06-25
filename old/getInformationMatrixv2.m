function [informationMatrix, modelMatrix, psyFunction] = getInformationMatrixv2(
		designMatrix, model, weights)
	modelMatrix = getModelMatrix(designMatrix, model.params);
	psyFunction = getPsyFunction(model.linkName);
	informationMatrix = zeros(length(model.nominalBeta));
	for i=1:size(designMatrix,1)
		xi = modelMatrix(i,:)';
		eta = xi' * model.nominalBeta;
		informationMatrix = informationMatrix + ...
			weights(i) * psyFunction(eta) * xi * xi';
	end
end