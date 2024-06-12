function pheromone = UpdatePheromone(pheromone, rho, s, cost,bestS, best,Cap,demand, Tmax, Tmin,Node,PbestS,Pbest,x,rbestS,rbest,phase)
pheromone = pheromone * rho;
pheromone((pheromone>Tmax))=Tmax;
pheromone((pheromone<Tmin))=Tmin;
pheromone = getIncrement(bestS,PbestS, best,Pbest, pheromone, Tmax, Tmin,Node,x,rbestS,rbest);
end