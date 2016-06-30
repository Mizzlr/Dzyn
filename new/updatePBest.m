function particle = updatePBest(particle)
	if (particle.pbestFitness < particle.fitness)
		particle.pbestFitness = particle.fitness;
		particle.pbestX = particle.X;
		particle.pbestP = particle.p;
	end
end