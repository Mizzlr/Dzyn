function [modelMatrix] = getModelMatrix(designMatrix, modelParams)
	modelMatrix = ones(size(designMatrix,1),1);
	for i=1:length(modelParams)
		indices = cell2mat(modelParams(i));
		productColumn = getProductColumn(designMatrix, indices);
		modelMatrix = [modelMatrix productColumn]; 
	end
end

