function cost=Cost2(mask,DisCS)
    cost=0;
    for i=1:length(mask)
        if mask(i)~=0
            [~,co]=min(DisCS(i,:));
            cost=cost+DisCS(i,co);
        end
    end       
end