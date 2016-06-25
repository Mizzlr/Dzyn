function [parts] = partition(weights,N)
	parts = round(weights * N);
	[_, index] = max(weights, [], 1);
	parts(index) = parts(index) + N - sum(parts);
end