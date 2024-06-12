function cost=theNearestNeigbourHeuristic(NCus,Dis,rrc,Node,Bat)
    usedCus = zeros(1, NCus);
    s(1) = randperm(NCus,1);
    usedCus(s(1)) = 1;
    while ~isempty(find(usedCus(1:end) == 0, 1))
        J = find(usedCus == 0);
        min_dis=1e15;
        for k = 1:length(J)
            if min_dis > Dis(s(end),J(k))
                min_dis=Dis(s(end),J(k));
                index=k;
            end
        end
        if ~isempty(index)
            s(end+1)=J(index);
            usedCus(J(index))=1;
        end
    end
    cost=Eval(s,Dis);
end