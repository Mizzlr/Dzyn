function [productColumn] = getProductColumn(designMatrix, indices)
	if (length(indices) == 1)
		productColumn = designMatrix(:,indices(1));
	else 
		productColumn = designMatrix(:,indices(1));
		for i=2:length(indices)
			index = indices(i);
			productColumn = productColumn .* designMatrix(:,index);
		end
	end
end
