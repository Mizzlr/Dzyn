function newDesign = updateIntrs(design, config)
	newDesign = [];
	if (config.nintr > 0)
		for i=1:config.nintr
			intr = config.intrs{i};
			productCol = ones(config.nrows,1);
			for col=1:length(intr)
				% compensate for the first column of ones
				col2 = intr(col) + 1; 
				productCol = productCol .* design.X(:,col2);
			end
			newDesign = [newDesign productCol];
		end
		design.X(:,2+config.ndisc+config.ncont:end) = newDesign;
	end
	newDesign = design;
end