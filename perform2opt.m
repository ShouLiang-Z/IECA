function [s,cost] = perform2opt(s, Capacity, D, serve, Demand, dis)
%穷举式2-opt
route = find(s == 1);
for k=1:length(route)-1
    Route=s(route(k) : route(k + 1));
    temp_cost=Eval(Route,dis);
    while 1
        minchange = 0;
        cus1Index=[];
        cus2Index=[];
        if length(Route) <=4
            break;
        end
        temp_route1=Route;
        temp_route1(temp_route1==1)=[];
        for i=1:length(temp_route1)-1
            for j=i+1:length(temp_route1)
                temp_route2=temp_route1;
                temp_route2(i:j) = temp_route2(j:-1:i);
                temp_route2=[1 temp_route2 1];
                temp_cost2=Eval(temp_route2,dis);
                change=temp_cost2-temp_cost;
                if abs(change) < 0.00000001
                    change = 0;
                end
                if minchange> change
                    minchange=change;
                    cus1Index=i;
                    cus2Index=j;
                end
            end
        end
        if minchange<0
            route1=temp_route1;
            route1(cus1Index:cus2Index) = route1(cus2Index:-1:cus1Index);
            route1=[1 route1 1];
            Route=route1;
            temp_cost=Eval(route1,dis);
        end
        
        if minchange>=0
            break;
        end
    end
    s(route(k) : route(k + 1))=Route; 
end
cost=Eval(s,dis);
end












% function [s,cost] = perform2opt(s, Capacity, D, serve, Demand, dis)
% %穷举式2-opt
% route = find(s == 1);
% for k=1:length(route)-1
%     while 1
%         Route=s(route(k) : route(k + 1));
%         temp_cost=Eval(Route,dis);
%         minchange = 0;
%         cus1Index=[];
%         cus2Index=[];
%         if length(Route) <=4
%             break;
%         end
%         temp_route1=Route;
%         temp_route1(temp_route1==1)=[];
%         for i=1:length(temp_route1)-1
%             for j=i+1:length(temp_route1)
%                 temp_route2=temp_route1;
%                 temp_route2(i:j) = temp_route2(j:-1:i);
%                 temp_route2=[1 temp_route2 1];
%                 temp_cost2=Eval(temp_route2,dis);
%                 change=temp_cost2-temp_cost;
%                 if abs(change) < 0.00000001
%                     change = 0;
%                 end
%                 if minchange> change
%                     minchange=change;
%                     cus1Index=i;
%                     cus2Index=j;
%                 end
%             end
%         end
%         if minchange<0
%             route1=temp_route1;
%             route1(cus1Index:cus2Index) = route1(cus2Index:-1:cus1Index);
%             route1=[1 route1 1];
%             s(route(k) : route(k + 1))=route1;
%         end
%         if minchange>=0
%             break;
%         end
%     end
%     
% end
% cost=Eval(s,dis);
% end
% 
% 
% 
% % function [s,cost] = perform2opt(s, Capacity, D, serve, Demand, dis)
% % route = find(s == 1);
% % routeCost = zeros(1, length(route) - 1);
% % routeDemand = zeros(1, length(route) - 1);
% % for i = 1 : length(route) - 1
% %         routeCost(i) = Eval(s(route(i) : route(i + 1)) , dis);
% %         routeDemand(i) = sum(Demand(s(route(i) : route(i + 1))));
% % end
% % j=0;
% % while 1
% %     j=j+1;
% %     if j>length(Demand)*length(Demand)
% %         break;
% %     end
% %     routeIndex = randi(length(route)-1);
% %     Route=s(route(routeIndex) : route(routeIndex + 1));
% %     Route(Route==1)=[];
% %     if length(Route) == 1
% %         continue;
% %     end
% %     while 1
% %         Route1=[1 Route 1];
% %         cost1=Eval(Route1,dis);
% %         cus1Index = randi(length(Route));
% %         cus2Index = randi(length(Route));
% %         
% %         if cus1Index ~= cus2Index
% %             if cus2Index < cus1Index
% %                 temp = cus1Index;
% %                 cus1Index = cus2Index;
% %                 cus2Index = temp;
% %             end
% %             break;
% %         end
% %     end
% %     
% %     route1 = Route;
% %     route1(cus1Index:cus2Index) = route1(cus2Index:-1:cus1Index);
% %     route1=[1 route1 1];
% %     if Eval(route1,dis)<cost1
% %         s(route(routeIndex) : route(routeIndex + 1))=route1;
% % %         break;
% %     end
% % end
% % cost=Eval(s,dis);
% % end
