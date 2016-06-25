function [supportPoints, weights] = evalSupportPoints(designMatrix)
	supportPoints = [];
	weights = [];
	N = size(designMatrix,1);
	for i=1:N
		designPoint = designMatrix(i,:);
		found = 0;
		for j=1:size(supportPoints,1)
			if (supportPoints(j,:) == designPoint)
				found = 1;
				weights(j) = weights(j) + 1;
				break;
			end
		end
		if (found == 0)
			supportPoints = [supportPoints; designPoint];
			weights = [weights; 1];
		end
	end
	weights = weights / N;
end