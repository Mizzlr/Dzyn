function W = evalWeights(xb, link)
	switch link
		case 'logit'
			W = exp(xb) ./ (1 + exp(xb)) .^ 2; 
		case 'loglog'
			W = exp(2*xb - exp(xb)) ./ (1 - exp(-exp(xb)));
		case 'cloglog'
			W = (exp(exp(xb)) - 1) .* log(1 - exp(-exp(xb))) .^ 2;
		case 'probit'
			num = exp(-(xb.^2)/2) / sqrt(2*pi);
			current = xb;
			iterSum = xb;
			for i=1:50
				iterSum = iterSum .* (xb .^ 2) / (2*i+1);
				current += iterSum;
			end
			cdf = 0.5 + (current / sqrt(2*pi)) .* exp(-(xb.^2) / 2);
			W = (num .* num) ./ (cdf .* (1 - cdf));
			
			for i=1:length(W)
				if W(i) > 1
					W(i) = 0;
				end 
			end

		otherwise
			error(sprintf('Invalid link function %s',link));
			exit(1);
	end
end