function [s,route_f,flag,pheromone]=localsearch1(s,cost,Demand,dis,Cap,Node,N,x,y,pheromone,bestcost,bestS,best,cost1,rho,a)
Demand=[0;Demand];
j=0;
D=1e15;
serve=0;
flag=0;
N1=Node+1;
c=1;
c2=0;
while 1 
    j=j+1;
    [s,tour,adj]=AdjacentStringRemoval(s,N,dis,Demand,Cap);
    [s,tempS]=AdjacentInsert(s,tour,adj,N,x,y,dis,Demand,Cap);
    tempCost=Eval(tempS,dis);
    deta = tempCost - cost; 
    if tempCost - cost<0
        cost = tempCost; 
        s = tempS;
    end
    if deta<0 
        flag=1;  
        break;
    end 
    if j>N*a
        flag=2;
        break;
    end
end
route_f=cost;
end


    