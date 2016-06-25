function [psyFunction] = getPsyFunction(linkName)
	switch (linkName)
		case 'logit'
			psyFunction = @(x) exp(x) ./ (1 + exp(x)) .^ 2;
		case 'probit'
			psyFunction = @(x) (2*exp(-x.^2)/sqrt(pi)).^2 ./ (erf(x)*erfc(x));
		case {'log-log', 'c-log-log'}
			psyFunction = @(x) loglogPsy(x);
		otherwise
			error('Unknown linkName for psyFunction');
	end
end

function r = loglogPsy(x)
	expx = exp(x);
	expmexpx = exp(-expx);
	r = (expmexpx .* expx ) .^2 ./ (expmexpx .* (1 - expmexpx));
end