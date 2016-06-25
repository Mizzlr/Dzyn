function config = getConfig(index)
	configs = {};

	config1.ndisc = 4;
	config1.ncont = 2;
	config1.nintr = 0;

	config1.ncols = 1 + config1.ndisc + config1.ncont + config1.nintr;
	config1.nrows = pow2((config1.ndisc + config1.ncont));

	config1.intrs = {}; % {[1,2]}; %[3,3]}; %,[1,1,2]};

	config1.beta = -3 + 6 * rand(config1.ncols,1); % between U(-3,3)
	config1.lb = ones(config1.ndisc + config1.ncont,1) * -1;
	config1.ub = ones(config1.ndisc + config1.ncont,1);

	config1.link = 'logit';

	% MSMA hyperparameters
	config1.popSize = 30;

	config1.maxReset = 20;
	config1.maxIter1 = 10;
	config1.maxIter2 = 5;

	config1.mutationProb1 = 0.4;
	config1.mutationProb2 = 0.4;
	config1.elitismRate1  = 0.2;
	config1.elitismRate2  = 0.2;
	config1.survivalRate1 = 1 - config1.elitismRate1;
	config1.survivalRate2 = 1 - config1.elitismRate2;
	config1.stage2SelectionRate = 0.5;

	configs(1,1) = config1;

	% more configs here, one per experiment
	% define the config2, config3, etc here
	% configs(2,1) = config2

	for i=1:length(configs)
		% common assertions for every configuration
		config = configs{i,1};
		assert(length(config.lb) == config.ndisc + config.ncont);
		assert(length(config.ub) == config.ndisc + config.ncont);
		assert(length(config.intrs) == config.nintr);
	end

	config = configs{index,1};
end