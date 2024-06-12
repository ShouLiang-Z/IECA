function [population,FrontNo,CrowdDis] = EnvironmentalSelection(population,N)
    Next=[];

    %% Non-dominated sorting
    a=[cat(1,population.cost),cat(1,population.cons)];
    [FrontNo,MaxFNo] = NDSort(cat(1,population.cost),cat(1,population.cons),N);
    Next = FrontNo < MaxFNo;
    CrowdDis = CrowdingDistance(cat(1,population.cost),FrontNo);
    
    %% Select the solutions in the last front based on their crowding distances
    Last     = find(FrontNo==MaxFNo);
    [~,Rank] = sort(CrowdDis(Last),'descend');
    Next(Last(Rank(1:N-sum(Next)))) = true;
    
    %% Population for next generation
    FrontNo    = FrontNo(Next);
    CrowdDis   = CrowdDis(Next);
    population= population(Next);
end