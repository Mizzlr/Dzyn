function randomDesign = createRandomDesign(config)
	dim = 1 + config.ndisc;
	X = ones(config.nrows, dim);

	for col=2:dim
		flipcount = pow2(dim-col+2);
		lowerbound = true;
		counter = 0;

		for row=1:config.nrows
			if (lowerbound)
				X(row, col) = config.lb(col);
			else
				X(row, col) = config.ub(col);
			end

			counter ++;
			if (counter == flipcount)
				counter = 0;
				lowerbound = not(lowerbound);
			end
		end
	end

	% if continous terms are included
	X2 = [];
	if (config.ncont > 0)
		X2 = rand(config.nrows,config.ncont);
		for col=1:config.ncont 
			col2 = config.ndisc + col;
			X2(:,col) = config.lb(col2) + X2(:,col) * ...
				(config.ub(col2)-config.lb(col2));
		end
	end
	X2 = [X, X2];
	
	% if interaction terms are included
	X3 = [];
	if (config.nintr > 0)
		for i=1:config.nintr
			intr = config.intrs{i};
			productCol = ones(config.nrows,1);
			for col=1:length(intr)
				% compensate for the first column of ones
				col2 = intr(col) + 1; 
				productCol .*= X2(:,col2);
			end
			X3 = [X3 productCol];
		end
	end
	X3 = [X2 X3];

	randomDesign.X = X3;

	% add the proportions
	p = rand(config.nrows,1);
	p = p / sum(p); % normalize p

	randomDesign.p = p;

	% evaluate fitness
	randomDesign.fitness = evalFitness(randomDesign, config);
end