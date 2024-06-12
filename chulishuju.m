 function Dis=chulishuju(X1,Y1,X2,Y2)
    Dis=zeros(length(X1),length(X2));
    for i=1:length(X1)
        for j=1:length(X2)
            Dis(i,j)=sqrt((X1(i,1)-X2(j,1))^2+(Y1(i,1)-Y2(j,1))^2);
        end
    end 
 end