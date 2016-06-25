function fitness = evalFitness(design, config)
	xb = design.X * config.beta;
	% test cases
	% w1 = evalWeights(xb, 'logit');
	% w2 = evalWeights(xb, 'probit');
	% w3 = evalWeights(xb, 'cloglog');
	% w4 = evalWeights(xb, 'loglog');
	Wp = evalWeights(xb, config.link) .* design.p;
	fisher = design.X' * diag(Wp) * design.X;
	fitness = log(det(fisher));
end