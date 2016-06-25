function [designMatrix] = getRandomDesignMatrix(factors, N)
	designMatrix = [];
	for i=1:length(factors)
		factor = factors{1,i};
		if (factor.type == 'd')
			column = factor.range(randi(length(factor.range),N,1))';
			designMatrix= [designMatrix column];
		else % continuous case
			column = factor.range(1) + ...
				rand(N,1)*(factor.range(2) - factor.range(1));
			designMatrix= [designMatrix column];
		end
	end
end