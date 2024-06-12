function [dec,mask]=RouteToDecMask(route,Node)
    dec=[];
    mask=[];
    route(route==0)=[];
    for i=1:length(route)-1
       if route(i)<Node+1 
           if route(i+1)>=Node+1
               dec=[dec route(i)];
               mask=[mask 1];
           else
               dec=[dec route(i)];
               mask=[mask 0];
           end
       end
    end
    if route(end)<Node+1
        dec(end+1)=route(end);
        mask(end+1)=0;
    end

    mask1=[];
    for k=1:length(mask)
        mask1(k)=mask(dec==k);
    end
    mask=mask1;
end