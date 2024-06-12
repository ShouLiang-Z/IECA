function [s,tour,adj]=AdjacentInsert(s,tour,adj,N,x,y,Dis,Demand,Cap)
    if ~isempty(adj)
        edge_node=[];
        r_boundary=[];
        temp_route{1}=[];
        temp_x1=[];
        d_route=find(tour==1);
        sore=zeros(length(adj),length(d_route));
        a=0;
       
        routeCost = zeros(1, length(d_route) - 1);
        routeDemand = zeros(1, length(d_route) - 1);

        for i = 1 : length(d_route) - 1
            routeCost(i) =Eval (tour(d_route(i) : d_route(i + 1)) , Dis);
            routeDemand(i) = sum(Demand(tour(d_route(i) : d_route(i + 1))));
        end
        sum_cost=sum(routeCost);

        for k=1:length(adj)
           [~,cok]=sort(Dis(adj(k),:));
           te=setdiff(cok,s);
           for kl=1:length(te)
                cok(cok==te(kl))=[];
           end
           for kl=1:length(cok)
               if ~ismember(cok(kl),adj) && cok(kl)~=1
                   break;
               end
           end
           edge_node(end+1)=cok(kl);
           [~,cox]=find(tour==cok(kl));
           p1 = max(find(d_route < cox));
           p2 = min(find(d_route > cox));
           X1 = d_route(p1);
           X2 = d_route(p2);
           if ~ismember(X1,temp_x1)
               a=a+1;
               temp_route{a}=tour(X1:X2);
           end
           temp_x1(end+1)=X1;
           sore(k,p1) =sore(k,p1)+1;

        end

        for j=1:length(tour)-1
            if ismember(tour(j),edge_node) && ismember(tour(j+1),edge_node)
                q1 = max(find(d_route < j));
                q2 = min(find(d_route > j));
                Y1 = d_route(q1);
                Y2 = d_route(q2);
                r_boundary=[r_boundary;q1 q2 tour(j) tour(j+1) ];
            end
        end
        [N1,~]=size(r_boundary);


        if N1~=0
            for i=1:length(adj)
                for j=1:N1
                    x0=x(adj(i));
                    y0=y(adj(i));
                    x1=x(r_boundary(j,3));
                    y1=y(r_boundary(j,3));
                    x2=x(r_boundary(j,4));
                    y2=y(r_boundary(j,4));
                    adjdis(i,j)=(abs( (x0-x1)*(y2-y1)-(x2-x1)*(y0-y1)  ))/(sqrt((x1-x2)^2 +(y1+y2)^2 ));
                end
                [~,co(i)]=min(adjdis(i,:));
                sore(i,r_boundary(co(i),1)) =sore(i,r_boundary(co(i),1))+1;
            end
        end

        mohu_node{1}=[];
        for ii=1:a
            B_node{ii}=[];
        end
        
        

        a2=0;
        if length(adj)~=1
            [~,B]=find(any(sore));
            sore(:,~any(sore)) = [];
            mohu_node{1}=[];
            for p=1:length(adj)
                [~,do]=find(sore(p,:)~=0);
                if length(do)==1
                    B_node{do}=[B_node{do} adj(p)];
                else
                    a2=a2+1;
                    mohu_node{a2}=[adj(p) do];

                end    
            end
        else
            [~,B]=find(sore~=0);
            [~,doi]=find(sore~=0);
            B_node{doi}=[];
            B_node{1}=[B_node{doi} adj(1)];
        end


        for q=1:length(B)-1
            d_route=find(tour==1);
            yy1 = d_route(B(q));
            yy2 = d_route(B(q)+1);
            temp_tour=tour(yy1:yy2);
            if ~isempty(B_node{q})

                index=[];
                for qq=1:length(B_node{q})

                    if routeDemand(B(q)) + Demand(B_node{q}(qq)) <=Cap

                        index_r=temp_tour;min_c=1e15;
                        for pp=1:length(temp_tour)-1
                            temp_r=[temp_tour(1:pp),B_node{q}(qq),temp_tour(pp+1:end)];
                            temp_c=Eval (temp_r, Dis);
                            if temp_c<min_c
                                index_r=temp_r;
                                min_c=temp_c;
                            end
                        end
                        index=[index qq];
                        temp_tour=index_r;
                        routeDemand(B(q))=routeDemand(B(q)) + Demand(B_node{q}(qq));
                    end
                end
                B_node{q}(index)=[];
            end
            tour=[tour(1:yy1) temp_tour(2:end-1) tour(yy2:end) ];
        end
       
        d_route=find(tour==1);
        routeDemand = zeros(1, length(d_route) - 1);
        for i = 1 : length(d_route) - 1
            routeDemand(i) = sum(Demand(tour(d_route(i) : d_route(i + 1))));
            if routeDemand(i)>Cap
                break;
            end
        end


        index_r1{1}=[];
        indexa=[];
        if ~isempty(mohu_node)
            for i1=1:a2
                d_route=find(tour==1);
                min_c(1)=1e14;

                for i2=2:length(mohu_node{i1})
                    index_r1{i2}=[];min_c(i2)=1e15;

                    xx1(i2) = d_route(B(mohu_node{i1}(i2)));
                    xx2(i2) = d_route(B(mohu_node{i1}(i2))+1);
                    mohu_tour=tour(xx1(i2):xx2(i2));

                    if routeDemand(B(mohu_node{i1}(i2))) + Demand(mohu_node{i1}(1)) <=Cap

                        for i3=1:length(mohu_tour)-1
                            temp_r=[mohu_tour(1:i3),mohu_node{i1}(1),mohu_tour(i3+1:end)];
                            temp_c=Eval (temp_r, Dis)+ sum_cost - routeCost(B(mohu_node{i1}(i2)));
                            if temp_c<min_c(i2)
                                index_r1{i2}=temp_r;  
                                min_c(i2)=temp_c;
                            end
                        end
                        
                    end
                end
                [~,cii]=min(min_c);
                if cii~=1
                    mohu_tour=index_r1{cii};
                    tour=[tour(1:xx1(cii)) mohu_tour(2:end-1) tour(xx2(cii):end)];
                    routeDemand(B(mohu_node{i1}(cii))) =routeDemand(B(mohu_node{i1}(cii))) + Demand(mohu_node{i1}(1));
                    mohu_node{i1}=[];
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
        

        yuxia_node=[];
        if a>1
        for i4=1:a
            if ~isempty(B_node{i4})
                indexi5=[];
                for i5=1:length(B_node{i4})
                     temp_cost=[];
                     flag=0;
                     for j1=1:a
                         temp_cost(j1)=1e14;
                         if j1~=i4
                             d_route=find(tour==1);
                             xyy1(j1) = d_route(B(j1));
                             xyy2(j1) = d_route(B(j1)+1);
                             temp_tour=tour(xyy1(j1):xyy2(j1));
                             if routeDemand(B(j1)) + Demand(B_node{i4}(i5)) <=Cap
                                index_r2{j1}=temp_tour;min_c=1e15;
                                for i3=1:length(temp_tour)-1
                                    temp_r=[temp_tour(1:i3),B_node{i4}(i5),temp_tour(i3+1:end)];
                                    temp_c=Eval (temp_r, Dis);
                                    if temp_c<min_c
                                        index_r2{j1}=temp_r;
                                        min_c=temp_c;
                                    end
                                end
                                flag=1;
                                temp_cost(j1)= min_c + sum_cost - routeCost(j1);
                             end
                         end  
                     end
                     if ~isempty(temp_cost) && flag==1
                         [~,coii]=min(temp_cost);
                         tour=[tour(1:xyy1(coii)) index_r2{coii}(2:end-1) tour(xyy2(coii):end) ]; %
                         routeDemand(B(coii))=routeDemand(B(coii)) + Demand(B_node{i4}(i5));
                         indexi5(end+1)=i5;
                     end
                end
                B_node{i4}(indexi5)=[];
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
        
        if ~isempty(mohu_node)
           for iii=1:a2
               if ~isempty(mohu_node{iii})
                    yuxia_node=[yuxia_node mohu_node{iii}(1)];
               end
           end
        end
        if ~isempty(B_node)
           for iii=1:length(B_node)
               if ~isempty(B_node{iii})
                    yuxia_node=[yuxia_node B_node{iii}];
               end
           end
        end
        temp_t=[];
        index_r=[];
        while ~isempty(yuxia_node)
            temp_t=[];
            index_r=[];
            temp_t(1)=1;
            currentCap=Cap;
            temp_yuxia_node=[];
            for i7=1:length(yuxia_node)
                if i7==1
                    temp_t=[temp_t yuxia_node(i7) 1];
                    currentCap=currentCap-Demand(yuxia_node(i7));
                    index_r=temp_t;
                else
                    if currentCap - Demand(yuxia_node(i7)) >=0
                        index_r=temp_t;min_c=1e15;
                        for i3=1:length(temp_t)-1
                            temp_r=[temp_t(1:i3),yuxia_node(i7),temp_t(i3+1:end)];
                            temp_c=Eval (temp_r, Dis);
                            if temp_c<min_c
                                index_r=temp_r;
                                min_c=temp_c;
                            end
                        end
                         currentCap=currentCap-Demand(yuxia_node(i7));
                    else
                        temp_yuxia_node(end+1)=yuxia_node(i7);
                    end
                end
                temp_t=index_r;
            end
            tour=[tour(1:end-1) temp_t];
            yuxia_node=[];
            yuxia_node=temp_yuxia_node;
        end
    end
        if length(tour)-length(find(tour==1))+1~=N
            b=1;
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



