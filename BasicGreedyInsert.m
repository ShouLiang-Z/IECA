function [s,tempS]=BasicGreedyInsert(s,tour,adj,N,x,y,dis,Demand,Cap)
% tour=[7,23,8,10,30,15,12,16,13,26,11,24,9,14];
% adj=[1,2,3,4,5,6];
% disp(tour);
% disp(adj);
    %绝对贪婪
while 1 
    if isempty(adj)
        break;
    end
    flag=0;%统计是否要新开路线
    rk = find(tour == 1);
    routeCost = zeros(1, length(rk) - 1);
    routeDemand = zeros(1, length(rk) - 1);
    for i = 1 : length(rk) - 1
        routeCost(i) = Eval (tour(rk(i) : rk(i + 1)) , dis);
        routeDemand(i) = sum(Demand(tour(rk(i) : rk(i + 1))));
    end
    e.rk_delta=[];
    e.index=[];
    delta = repmat(e,length(rk)-1,1);
    %对于每条路径，根据容量约束，判断有哪些客户能够插入
    for k=1:length(rk)-1
        set_c=[];
        route=tour(rk(k) : rk(k + 1));
        for j1=1:length(adj)
            if Demand(adj(j1)) + routeDemand(k) <= Cap
                set_c(end+1)= adj(j1);
            else
                flag=flag+1;
            end
        end
        temp_delta=[];
        if ~isempty(set_c)
            temp_delta=zeros(length(set_c),length(route)-1);
            for j2=1:length(set_c)
                temp_c=set_c(j2);%待插入的客户
                for j3=1:length(route)-1 %计算每一个插入位置 插入以后成本的增量
                    temp_delta(j2,j3)=  dis(route(j3),temp_c) + dis(route(j3+1),temp_c) - dis(route(j3),route(j3+1));
                end
            end
        end
        delta(k).rk_delta=temp_delta;
        delta(k).index=set_c;
    end
    
    d_route=find(tour==1);
    routeDemand = zeros(1, length(d_route) - 1);
    for i = 1 : length(d_route) - 1
        routeDemand(i) = sum(Demand(tour(d_route(i) : d_route(i + 1))));
        if routeDemand(i)>Cap
            break;
        end
    end
    
    if flag==length(adj)*(length(rk)-1) %每个客户每个路线都不能再插入 只能新开一条路线
        tour=[tour adj(1) 1];
        adj(1)=[];
    else
        %找出最好的一个客户加入
        min_cost=zeros(1,length(rk)-1);
        temp_b=[];
        for i1=1:length(rk)-1
            set=delta(i1).index;
            if ~isempty(set)
                temp=delta(i1).rk_delta;
                [l,r]=sort(temp');
                ib=ones(1,length(set))*i1;
                b=[set;l(1,:);ib;r(1,:)];
                temp_b=[temp_b;b'];
            end
        end
        %temp_b中包含所有信息，依次是客户；增量值；所在路径；插入位置
        tempb=sortrows(temp_b,2);
        [n,d]=size(tempb);
        for i=1:n
            route=[];
            routedemand=[];
            rk = find(tour == 1);
            route=tour(rk(tempb(i,3)) : rk(tempb(i,3) + 1));
            routedemand=sum(Demand(tour(rk(tempb(i,3)) : rk(tempb(i,3) + 1))));
            if ~isempty(adj)
                if ismember(tempb(i,1),adj)
                    %插入该客户
                    if Demand(tempb(i,1)) + routedemand <=Cap
                        route=[route(1:tempb(i,4)) tempb(i,1) route(tempb(i,4)+1:end)];
                        adj(adj==tempb(i,1))=[];
                        tour=[tour(1 : rk(tempb(i,3))) route(2:end-1) tour( rk(tempb(i,3) + 1):end)];
                    end  
                end
            else
                break;
            end
        end
        if isempty(adj)
            break;
        end
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
tempS=tour;
end