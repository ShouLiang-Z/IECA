function [bestDec,bestMask,bestcost] = main(Did,Cid,Sid,x,y,cx,Dis,Disd,DisDC,DisCC,DisCS,DisDS,demand,Demand,Cap,Bat,r,pmaxa,name,DisDCS,DisCSCS,DisDCsDCs)
    N = length(x);
    num=20;
    bestcost=1e15;
    Node = length(cx);
    NNode = length(x)-1;
    popnum =length(cx); 
    generations=5000;
    NAnt =length(cx);
    empty_individua2.mask = [];
    empty_individua2.cost = [];
    empty_individua2.cons = [];
    population2 = repmat(empty_individua2,popnum,1);   
    bestDec=[];
    bestMask=[];
    cost=ones(NAnt,1)*1e15;
    cost2=ones(popnum,1)*1e15;
    cons2=ones(popnum,1)*1e15;
    phrc=zeros(popnum,1);
    up_pbest(1)=1e15;
    upbest=1e15;
%% 参数设置
    detaF=5;
    alpha = 1;
    beta = 2;
    rho = 0.98;
    best = 1e15;
    bestS = {};
    init_cost=theNearestNeigbourHeuristic(N,Dis,1,Node,Bat);
    pheromone = ones(length(x), length(x))*(1/((1-rho)*init_cost));
    for i=1:length(x)
        pheromone(i,i)=0;
    end
    w1=NAnt;
    nobetter=0;
    nobetter1=0;
    c1=0;
    c2=0;
    c3=0;
    c4=0;
    c5=0;
    restartiteration=0;
    archives{1}=[];
    sc1=ones(1,w1)*1e15;
    s=cell(popnum);

    for i = 1:popnum
        population2(i).mask = initmask(Node,DisCS,pmaxa);
        population2(i).cost=Cost2(population2(i).mask,DisCS);
        population2(i).cons=1e15;
    end     
    [population2,FrontNo2,CrowdDis2] = EnvironmentalSelection(population2,popnum);


    for gene=1:generations
        tempbest=1e15;
        indexx=[];
        rbestS=[];
        rbest=1e15;

        for i = 1:NAnt 
            [s{i},cost(i),c(i)]= getAnt(alpha, beta, pheromone, NNode, Cap, Demand,Dis);    
        end
        count=sum(c);
        [~, index] = min(cost);   
        Pbest = cost(index);
        PbestS  = s{index};
        serve=0;
        D=1e14;
        [PbestS,Pbest,flag,pheromone]=localsearch(PbestS,Pbest,Demand,Dis,Cap,Node,N,x,y,pheromone,bestcost,bestS,best,best,rho,2);
        if Pbest <best
            best = Pbest;
            bestS = PbestS;
            [bestS,best,flag,pheromone]=localsearch(bestS,best,Demand,Dis,Cap,Node,N,x,y,pheromone,bestcost,bestS,best,best,rho,2);
            [bestS,best] = perform2opt(bestS, Cap, D, serve, Demand, Dis);
            nobetter=0;
            restartiteration=gene;
            c5=gene;
        else
            nobetter=nobetter+1;
        end 
        index_jj_1=[];
        for jj=1:length(PbestS)-1
            if PbestS(jj)==1 && PbestS(jj+1)==1
                index_jj_1(end+1)=jj+1;
            end
        end
        PbestS(index_jj_1)=[];
        

        dec1=PbestS-1;dec1(dec1==0)=[]; [dec,flagmask]=RouteToDecMask(dec1,Node); 
        MatingPool2 = TournamentSelection(2,2*popnum,FrontNo2,-CrowdDis2);
        Offspring2 = Operator2(population2(MatingPool2),flagmask,DisCS,DisDS);

        S1=cell(1,popnum);

        for i2=1:popnum
            S1{i2}=uncode(PbestS,Offspring2(i2).mask,Did,Cid,Sid,DisCS,DisCC,DisDS,demand,Cap,num);
            cons2(i2)=calCons(S1{i2},Demand,DisCC,DisCS,DisDC,Dis,Cap,Bat,num,r,Node);
            cost2(i2)= Eval(S1{i2},Dis);
            Offspring2(i2).cons=cons2(i2);
            Offspring2(i2).cost=cost2(i2);
        end
        
        if min(cost2(cons2==0))<tempbest
            c1=c1+length(find(cons2==0));
            b2=find(cons2==0);
            [~,d2]=min(cost2(b2));
            indexx=b2(d2);
     
        end
        if min(cost2(cons2==0))<bestcost
            b1=find(cons2==0);
            [bestcost,d12]=min(cost2(b1));
            bestDec=S1{indexx};  
            bestMask=Offspring2(b1(d12)).mask;  
            nobetter1=0; 
            c3=gene;
            c4=Pbest;
        else
            nobetter1=nobetter1+1;
        end
         if ~isempty(indexx)
                rbest=cost2(indexx);
                rbestS=S1{indexx};
                c2=c2+1;
         end
         

        newpopulation2 = [population2;Offspring2];
        [population2,FrontNo2,CrowdDis2] = EnvironmentalSelection(newpopulation2,popnum);  

        avg=N+1;
        Tmax=1/((1-rho)*best);
        Tmin=Tmax*(1-((0.05).^(1/N)))/((avg/2)*((0.05).^(1/N)));
        pheromone = UpdatePheromone(pheromone, rho, s, cost,bestS, best,Cap,demand, Tmax, Tmin,Node,PbestS,Pbest,gene,rbestS,rbest);

        fprintf('%s已完成%d次迭代,最优解cvrp为：%f\n',name,gene,best);
          
    end
    [rbestS,rbest]=ls(bestDec,bestcost,Demand,Dis,Cap,Node,N,x,y, cx,Bat,r,Disd,demand);
    if rbest<bestcost
       bestDec=rbestS;bestcost=rbest;
    end

    fid=fopen(['test\testEX\','C.txt'],'a');%写入文件路径
    fprintf(fid,'%s已完成迭代,在第%d代找到最优解：%f,找到时种群1解为：%f;种群1在第%d代找到最终解：%f,匹配成功%d次，交互%d次\n',name,c3,bestcost,c4,c5,best,c1,c2);
    fclose(fid);
end

