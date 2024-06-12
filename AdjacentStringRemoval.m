function [s,temp_s,adj]=AdjacentStringRemoval(s,N,Dis,Demand,Cap)
    c_avg=10;
    L_max=10;
    alpha=0.5;
    beta=0.01;
    temp_s=s;
    r_boundary=[];
    d_route = find(temp_s == 1);
    %计算
    ls_max=min(L_max,length(d_route));
    ks_max=((4*c_avg)/(1+ls_max))-1;
    ks=randperm(floor(ks_max+1),1);
    adj=[];
    temp_seed=[];
    i=1;
    while i<=ks        
       if i==1
           cs_seed = randperm(N,1);
           while cs_seed==1
               cs_seed = randperm(N,1);
           end
       else
           last_seed=temp_seed(end);
           [~,co]=sort(Dis(last_seed,:));
           for ik=1:length(co)
              if ~ismember(co(ik),adj) && co(ik)~=1
                  break;
              end
           end
           cs_seed=co(ik);
       end
       temp_seed(end+1)=cs_seed;
       
       d_route = find(temp_s == 1); 
       [~,col]=find(temp_s==cs_seed);
       p1 = max(find(d_route < col));
       p2 = min(find(d_route > col));
       x1 = d_route(p1);
       x2 = d_route(p2);
       temp_route=temp_s(x1:x2-1);
       [~,cox]=find(temp_route==cs_seed);

       lt_max=min(length(temp_s(x1:x2-1)),ls_max);
       lt=randperm(floor(lt_max),1);
     
       dele_index=randperm(lt,1);
       a=0;
       b=0;
       temp_adj=[];
       for j=1:lt
           if cox+j-dele_index>length(temp_route)
               a=a+1;
               temp_adj(j)=temp_route(a);
           elseif cox+j-dele_index<=0
               temp_adj(j)=temp_route(length(temp_route)-b);
               b=b+1;
           else
               temp_adj(j)=temp_route(cox+j-dele_index);
           end    
       end
       [~,coi]=find(temp_route==temp_adj(1));
       [~,coj]=find(temp_route==temp_adj(end));
       if coi~=1
           startnode=temp_route(coi-1);
       else
           startnode=temp_route(end);
       end
       if coj~=length(temp_route)
           endnode=temp_route(coj+1);
       else
           endnode=temp_route(1);
       end
       tempnode=[startnode endnode];
       

       
       
       for ip=1:length(temp_adj)           
           if temp_adj(ip)~=1
               temp_s(temp_s==temp_adj(ip))=[];
           end
       end
       temp_adj(temp_adj==1)=[];
       adj=[adj temp_adj];
       i=i+1;
    end
    indexa=[];
    for k=1:length(temp_s)-1
        if temp_s(k)==1 && temp_s(k+1)==1
            indexa(end+1)=k+1;
        end
    end
    temp_s(indexa)=[];
    i=1;
    while i<length(temp_s)
        if temp_s(i)==temp_s(i+1)
            temp_s(i+1) = [];
        else
            i = i + 1;
        end
    end
    
                d_route=find(temp_s==1);
            routeDemand = zeros(1, length(d_route) - 1);
            for i = 1 : length(d_route) - 1
                routeDemand(i) = sum(Demand(temp_s(d_route(i) : d_route(i + 1))));
                if routeDemand(i)>Cap
                    break;
                end
            end
end








