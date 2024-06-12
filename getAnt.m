function [s,cost1,count]= getAnt(alpha, beta, pheromone, NCus, Cap, demand,Disd)
    count=0;
     NCus= NCus+1;
    usedCus = zeros(1, NCus);
    s(1) = randperm(NCus,1);
    usedCus(s(1)) = 1;
    if NCus<500
        while ~isempty(find(usedCus(1:end) == 0, 1))
            J = find(usedCus == 0);
            route = s;
            P = zeros(1, length(J));
            for k = 1:length(J)
                    P(k) = ((pheromone(route(end),J(k))) ^ alpha) * (1./((Disd(route(end),J(k))) ^ beta));
            end
            temp = find(P==0);                                                  
            if ~isempty(temp)
                P(temp) = [];
                J(temp) = [];
            end
            if ~isempty(P)
                count=count+length(P);
                P1 = P / (sum(P));

                Pcum = cumsum(P1);
                Select = find(Pcum >= rand, 1);
                if  isempty(Select)
                    [~,Select] = max(P);
                end
                to_visit=J(Select);
                s(end+1)=to_visit;
                usedCus(to_visit)=1;
            end
        end
    else
        J=[];
        while ~isempty(find(usedCus(1:end) == 0, 1))
            route = s;
            [~,col]=sort(Disd(route(end),:));
            for ii=1:min(length(find(usedCus==0)),20)
                if usedCus(col(ii))~=1
                    J(end+1)=col(ii);
                end 
            end

            P = zeros(1, length(J));
            for k = 1:length(J)
                    P(k) = ((pheromone(route(end),J(k))) ^ alpha) * (1./((Disd(route(end),J(k))) ^ beta));
            end
            temp = find(P==0);                                                  
            if ~isempty(temp)
                P(temp) = [];
                J(temp) = [];
            end
            if ~isempty(P)
                count=count+length(P);
                P1 = P / (sum(P));

                Pcum = cumsum(P1);
                Select = find(Pcum >= rand, 1);
                if  isempty(Select)
                    [~,Select] = max(P);
                end
                to_visit=J(Select);
                s(end+1)=to_visit;
                usedCus(to_visit)=1;
            end
        end
    end


    [~,index1]=find(s==1);
    if index1~=1
        s1=[];
        s1=s(index1:end);
        s1=[s1 s(1:index1-1)];
        s=s1;
    end
    

 p=zeros(NCus,1);
 v=ones(NCus,1)*1e15;
 v(1)=0;
 demand=[0;demand];
 for i=2:NCus
     j=i;
     tc=0;
     td=0;
     while j<=NCus && tc<=Cap
         tc=tc+demand(s(j));
         if i==j
             td=Disd(1,s(j))+Disd(1,s(j));
         else
             td=td-Disd(1,s(j-1))+Disd(s(j-1),s(j))+Disd(1,s(j));
         end
         if tc<=Cap
             
             if v(i-1)+td<v(j)
                 v(j)=v(i-1)+td;
                 p(j)=i-1;
             end
             j=j+1;
         end
     end
 end

    
    trip(1)=1;
    i=NCus;
    j=NCus;
     while i~=1
        i=p(j);
        for k=i+1:j
            trip(end+1)=s(k);
        end
        trip(end+1)=1;
        j=i;   
     end
    s=trip;


    D = 1e14;
    serve = 0;
    cost1=Eval(s,Disd);
    [s, cost1] = perform2opt(s, Cap, D, serve, demand, Disd);
end

