 function jiajiao=jiajiaojuzhen(X,Y)
    jiajiao=zeros(length(X),length(Y));
    for i=1:length(X)
        for j=1:length(Y)
            jiajiao(i,j)=abs(((X(i,1)-X(1,1))*(Y(i,1)-Y(1,1))+(X(j,1)-X(1,1))*(Y(j,1)-Y(1,1)))/(sqrt((X(i,1)-X(1,1))^2+(Y(i,1)-Y(1,1))^2)*sqrt((X(j,1)-X(1,1))^2+(Y(j,1)-Y(1,1))^2)));
        end
    end
 end