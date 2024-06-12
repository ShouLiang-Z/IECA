function cons=calCons(s,demand,DisCC,DisCS,DisDC,Dis,Cap,Bat,num,r,Node)
demand=[0;demand];
dec_route=find(s==1);
cons=0;
for ii=1:length(dec_route)-1
    bat=0;
    cap=0;
    temp_dec=s(dec_route(ii):dec_route(ii+1));
    if Cap< sum(demand(temp_dec))
        cap=sum(demand(temp_dec))-Cap;
    end

    currentBat=Bat;
    for i=1:length(temp_dec)-1
        if temp_dec(i)==1 || temp_dec(i)>Node+1
            currentBat=Bat;
        end
        if currentBat<r*Dis(temp_dec(i),temp_dec(i+1))
            bat=bat+currentBat-r*Dis(temp_dec(i),temp_dec(i+1));
        else
           currentBat=currentBat-r*Dis(temp_dec(i),temp_dec(i+1));
        end
    end
    cons=cons+cap-bat;
end


end
