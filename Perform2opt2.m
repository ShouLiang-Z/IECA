function [s,cost] = Perform2opt2(s,rbest, Capacity, D, serve, Demand, dis)
time = 0;
route
index = randi(length(s));
route = s;
cus1 = 0;
cus2 = 0;
while 1
    if length(route) > 1
        while 1
            index1 = randi(length(route));
            index2 = randi(length(route));
            if index1 ~= index2
                break;
            end
        end
        if index1 > index2
            temp = index1;
            index1 = index2;
            index2 = temp;
        end
        
        cus1 = route(index1);
        cus2 = route(index2);
        
        temp = route;
        temp(index1:index2) = temp(index2:-1:index1);
        [cv, dv, ~] = isRouteFeasible(temp, Capacity, D, serve, Demand, dis);
        
        if ~cv && ~dv
            route = temp;
            break;
        else
            time = time + 1;
        end
        
        if time > 10
            cus1 = 0;
            cus2 = 0;
            break;
        end
    else
        cus1 = 0;
        cus2 = 0;
        break;
    end
end
s{index} = route;
end