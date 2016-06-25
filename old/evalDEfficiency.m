function [DEfficiency] = evalDEfficiency(theta , k)
	DEfficiency = exp(-theta / k);
end 