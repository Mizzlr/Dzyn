function mutants = applyMutation(children, config, stage=1)
	mutants = children; % stub code
	if (stage == 1)
		% stage 1 mutation strategy
		for i=1:length(children)
			% mutate the X (design matrix) of each children
			if rand < config.mutationProb1
				design = children{i,1};
				randomDesign = createRandomDesign(config);
				% upto a fourth of the values of X are mutated
				mutationSites = randperm(config.nrows,
					randperm(config.nrows/4,1));

				for j=1:length(mutationSites)
					site = mutationSites(j);
					design.X(site,:) = randomDesign.X(site,:);
				end
				mutants(i,1) = design;
			end
		end
		% update interaction terms of each mutant
		mutants = rebuildBody(mutants, config);
	else % obviously stage 2
		% stage 2 mutation strategy
		for i=1:length(children)
			% mutate the p (proportions) of each children
			if rand < config.mutationProb2
				design = children{i,1};
				% upto a fourth of the values of p are mutated
				mutationSites = randperm(config.nrows,
					randperm(config.nrows/4,1));

				for j=1:length(mutationSites)
					site = mutationSites(j);
					design.p(site) = rand;
				end

				design.p = design.p / sum(design.p);
				mutants(i,1) = design;
			end
		end
	end
end