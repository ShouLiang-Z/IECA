function s1=isRouteFeasible(s,Cap,demand)
s1=s(1);
currentCap=Cap;
for i=2:length(s)
    Select=s(i);
 if currentCap>=demand(Select)
     s1(end+1)=Select;
     currentCap=currentCap-demand(Select);
 else
        currentCap=Cap;
        s1(end+1)=0;
        s1(end+1)=Select;
        currentCap=currentCap-demand(Select);
 end
end
end