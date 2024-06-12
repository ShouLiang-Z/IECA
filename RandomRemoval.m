function [s,tour,adj]=RandomRemoval(s,N,dis,Demand,Cap)
    d_route=find(s==1);
    for i = 1 : length(d_route) - 1
        routeDemand(i) = sum(Demand(s(d_route(i) : d_route(i + 1))));
        if routeDemand(i)>Cap
            break;
        end
    end


    avg_num=length(s)/length(find(s==1));
    temp_s=s;
    tour=s;
    temp_s(temp_s==1)=[];
    Nq=randperm(floor(avg_num/2),1);
    remove_locate=randperm(length(temp_s),Nq);
    adj= temp_s(remove_locate);
    for i=1:length(adj)
        tour(tour==adj(i))=[];
    end
    i=1;
    while i<length(tour)
        if tour(i)==tour(i+1)
            tour(i+1) = [];
        else
            i = i + 1;
        end
    end
    d_route=find(tour==1);
    routeDemand = zeros(1, length(d_route) - 1);
    for i = 1 : length(d_route) - 1
        routeDemand(i) = sum(Demand(tour(d_route(i) : d_route(i + 1))));
        if routeDemand(i)>Cap
            break;
        end
    end
end                                                                                                                                                                                                            