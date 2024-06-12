function pheromone = getIncrement(best,s,cost,Pbest, pheromone, Tmax, Tmin,Node,x,rbestS,rbest)
if ~isempty(rbestS)
    for i = 1:length(rbestS)-1
        pheromone(rbestS(i), rbestS(i+1)) = pheromone(rbestS(i), rbestS(i+1)) + 1 ./ rbest;
    end
else
if ~isempty(s)
    for i = 1:length(s)-1
         pheromone(s(i), s(i+1)) = pheromone(s(i), s(i+1)) + 1 ./ Pbest;
    end
end
end
if mod(x,25)==0
    for i = 1:length(best)-1
        pheromone(best(i), best(i+1)) = pheromone(best(i), best(i+1)) + 1 ./ cost;
    end
end
pheromone((pheromone>Tmax))=Tmax;
pheromone((pheromone<Tmin))=Tmin;
end