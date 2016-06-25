function children = breedChildren(parents, config, stage=1)
	% children = parents;% stub code
	if (stage == 1)
		% stage 1 breeding strategy
		children = {};
		for i=1:2:length(parents)
			father = parents{i,1};
			mother = parents{i+1,1};

			child1 = father;
			child2 = mother;

			% modify X (design matrix) of children
			traspositionSites = randperm(config.nrows,
				randperm(config.nrows,1));

			for j=1:length(traspositionSites)
				site = traspositionSites(j);
				child1.X(site,:) = mother.X(site,:);
				child2.X(site,:) = father.X(site,:);
			end

			children(i,1) = child1;
			children(i+1,1) = child2;
		end

	else % obviously stage 2
		% stage 2 breeding strategy
		children = {};
		for i=1:2:length(parents)-1
			father = parents{i,1};
			mother = parents{i+1,1};

			child1 = father;
			child2 = mother;

			% modify p (proportions) of the children
			split = randperm(length(child1.p)-1,1);
			child1.p = [father.p(1:split); mother.p(split+1:end)];
			child2.p = [mother.p(1:split); father.p(split+1:end)];

			% normalize the proportions
			child1.p = child1.p / sum(child1.p);
			child2.p = child2.p / sum(child2.p);

			assert(length(child1.p) == length(father.p));

			children(i,1) = child1;
			children(i+1,1) = child2;
		end
	end
end
