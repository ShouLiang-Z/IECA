function flag=issatifyelectricity(s,cx,Bat,Dis,r)
    flag=1;
    currentBat=Bat;
    for i=1:length(s)-1
        if s(i)==1 || s(i)>length(cx)+1
            currentBat=Bat;
        end
        if currentBat<r*Dis(s(i),s(i+1))
            flag=0;
            break;
        else
           currentBat=currentBat-r*Dis(s(i),s(i+1));
        end
    end
end