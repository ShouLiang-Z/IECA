function [s,route_f] =ls(s,cost,Demand,dis,Cap,Node,N,x,y,cx,Bat,r,Disd,demand)
demand=[0;demand];
Demand=[0;Demand];
j=0;
D=1e15;
serve=0;
flag=0;
N1=Node+1;
c=1;
c2=0;
    for i=1:length(s)
if s(i)<Node+1 && s(i)~=1
adj=s(i);
tour=s;tour(tour==adj)=[];
     [s,tempS]=BasicGreedyInsert(s,tour,adj,N,x,y,dis,Demand,Cap);
    if issatifyelectricity(s,cx,Bat,dis,r)
        tempCost=Eval(tempS,dis);
        deta = tempCost - cost; 
        if tempCost - cost<0
            cost = tempCost; 
            s = tempS;
        end
    end
end
route_f=cost;
end


       