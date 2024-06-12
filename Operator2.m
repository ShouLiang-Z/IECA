function Offspring = Operator2(population,mask1,DisCS,DisDS)
    %% Parameter settingmatrix,
    ParentMask = transforjuzhenmask(population);
    [N1,D]=size(ParentMask);
    N=N1/2;   
    ParentMask1 = ParentMask(1:floor(end/2),:);
    ParentMask2 = ParentMask(floor(end/2)+1:floor(end/2)*2,:);
    empty_offspring.mask = [];
    empty_offspring.cost = [];
    OffspringMask1=zeros(N,D);
    Offspring = repmat(empty_offspring,N,1);  
    l = rand(N,D) < 0.5;
    l(repmat(rand(N,1)>1,1,D)) = false; 
    OffspringMask1=ParentMask1&mask1;
    OffspringMask1(l) = ParentMask2(l);
    Site = rand(N,D) < 1/D;
    OffspringMask1(Site) = ~OffspringMask1(Site);
    for i=1:N
       Offspring(i).mask=OffspringMask1(i,:);
       Offspring(i).cost=1e15;
       Offspring(i).cons=1e15;
    end

end




function  mask= transforjuzhenmask(Parent)
    for j=1:length(Parent)
        mask(j,:)=Parent(j).mask;
    end
end



