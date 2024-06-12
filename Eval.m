function cost = Eval(Solution,Dis)
s=Solution;
cost=0;
    for i=1:length(s)-1
        cost=cost+Dis(s(i),s(i+1));
    end
end