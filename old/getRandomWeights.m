function [distribution] = getRandomWeights(numSamples)
	distribution = rand(numSamples,1);
	distribution = distribution / sum(distribution);
end