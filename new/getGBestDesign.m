function gbest = getGBestDesign(gbest, swarm)

	best = swarm{1,1};
	for i=1:length(swarm)
		design = swarm{i,1};
		if (design.pbestFitness > best.pbestFitness)
			best = design;
		end
	end

	if (length(gbest) == 0)
		gbest = best;
	else
		if (gbest.pbestFitness < best.pbestFitness)
			gbest = best;
		end
	end

end
