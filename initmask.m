function mask=initmask(Node,DisCS,pmaxa)
pmax=[];
mask=[];
media=median(pmaxa);
pmax=pmaxa;
pmax(find(pmax<=media))=0;
for i=1:Node
        if rand()<pmaxa(i)
            mask(i)=1;
        else
            mask(i)=0;
        end    
    end


end