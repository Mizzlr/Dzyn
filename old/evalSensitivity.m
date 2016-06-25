function [sensitivity] = evalSensitivity(designMatrix, model)
	[informationMatrix, modelMatrix, psyFunction] = ...
		getInformationMatrix(designMatrix, model);
	dispersionMatrix = inv(informationMatrix);

	sensitivity = zeros(size(designMatrix,1),1);
	for i=1:length(sensitivity)
		x = modelMatrix(i,:)';
		eta = x' * model.nominalBeta;
		sensitivity(i) = psyFunction(eta) * x' * dispersionMatrix * x; 
	end
end