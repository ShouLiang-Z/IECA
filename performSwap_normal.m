function [s, cost, routeCost, routeDemand, oper] = performSwap_normal(s, cost, routeCost, routeDemand, Capacity, D, serve, Demand, dis)

route = find(s == 1);
nr = length(route) - 1;
t1 = clock;

if nr >= 2
    while 1
        
        r1 = ceil(rand * nr);
        r2 = ceil(rand * nr);
        if r1 == r2
            continue;
        end
        %         tic
        i1 = ceil(rand * (route(r1 + 1) - route(r1) - 1)) + route(r1);
        i2 = ceil(rand * (route(r2 + 1) - route(r2) - 1)) + route(r2);
        
        c1 = s(i1);
        c1_pre = s(i1 - 1);
        c1_next = s(i1 + 1);
        c2 = s(i2);
        c2_pre = s(i2 - 1);
        c2_next = s(i2 + 1);
        
        if routeDemand(r1) - Demand(c1) + Demand(c2) <= Capacity && ...
                routeDemand(r2) - Demand(c2) + Demand(c1) <= Capacity && ...
                routeCost(r1) - dis(c1_pre, c1) - dis(c1, c1_next) + ...
                dis(c1_pre, c2) + dis(c2, c1_next) <= D && ...
                routeCost(r2) - dis(c2_pre, c2) - dis(c2, c2_next) + ...
                dis(c2_pre, c1) + dis(c1, c2_next) <= D
            
            cost = cost - dis(c1_pre, c1) - dis(c1, c1_next) + dis(c1_pre, c2) + ...
                dis(c2, c1_next) - dis(c2_pre, c2) - dis(c2, c2_next) + dis(c2_pre, c1) + dis(c1, c2_next);
            routeCost(r1) = routeCost(r1) - dis(c1_pre, c1) - dis(c1, c1_next) + ...
                dis(c1_pre, c2) + dis(c2, c1_next);
            routeCost(r2) = routeCost(r2) - dis(c2_pre, c2) - dis(c2, c2_next) + ...
                dis(c2_pre, c1) + dis(c1, c2_next);
            routeDemand(r1) = routeDemand(r1) - Demand(c1) + Demand(c2);
            routeDemand(r2) = routeDemand(r2) - Demand(c2) + Demand(c1);
            oper = [1 c1 c2];
            
            s(i1) = c2;
            s(i2) = c1;
            %             toc
            break;
        end
        t2 = clock;
        if etime(t2, t1) > 0.001
            cost = inf;
            oper = [-1 -1 -1];
            break;
        end
    end
else
    cost = inf;
    oper = [-1 -1 -1];
end
end