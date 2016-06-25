function [DOptimality] = evalDOptimalityScore(informationMatrix)
	DOptimality = log(det(informationMatrix));
end