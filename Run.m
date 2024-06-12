function Run()
SHUJUJI=3;
if SHUJUJI==1 || SHUJUJI==2
    rrc=2;
else
    rrc=1;
end

switch SHUJUJI
    case 1
         
    case 2
        
    case 3
        %% EX数据集 
     clc;format compact;
     file='data\e-cvrp_benchmark_instances-master';
     fileFolder=fullfile(file);
     dirOutput=dir(fullfile(fileFolder,'*.evrp'));
     L=length(dirOutput);
     empty_in1.id = [];
     empty_in1.x = [];
     empty_in1.y = [];
     empty_in1.demand = [];
     empty_in2.num = [];
     empty_in2.Cap = [];
     empty_in2.Bat = [];
     empty_in2.r = [];
     empty_in2.c = [];
     Customer = repmat(empty_in1,1,L); 
     Depot = repmat(empty_in1,1,L); 
     Station = repmat(empty_in1,1,L); 
     parameter= repmat(empty_in2,1,L);
     
     for j=1:L
          fileNames{j}=strcat('data\e-cvrp_benchmark_instances-master\',dirOutput(j).name);  
          disp(dirOutput(j).name);   
          [~,c,~]=textread(fileNames{j},'%s%d%s',1,'delimiter',':','headerlines',3);
          [~,shuju]=textread(fileNames{j},'%s%f',6,'delimiter',':','headerlines',4);
          [d_id,d_x,d_y]=textread(fileNames{j},'%d%f%f',1,'delimiter', ' ','headerlines',12);
          [~,d_demand]=textread(fileNames{j},'%d%d',1,'delimiter',' ','headerlines',shuju(2)+12+1);
          Depot(j)=struct('id',d_id,'x',d_x,'y',d_y,'demand',d_demand);
          [c_id,c_x,c_y]=textread(fileNames{j},'%d%f%f',shuju(2)-shuju(3)-1,'delimiter',' ','headerlines',12+1);
          [~,c_demand]=textread(fileNames{j},'%f%f',shuju(2)-shuju(3)-1,'delimiter',' ','headerlines',shuju(2)+12+1+1);
          Customer(j)=struct('id',c_id,'x',c_x,'y',c_y,'demand',c_demand);
          [s_id,s_x,s_y]=textread(fileNames{j},'%d%f%f',shuju(3),'delimiter',' ','headerlines',shuju(2)-shuju(3)+12);
          s_demand=zeros(length(s_id),1);
          Station(j)=struct('id',s_id,'x',s_x,'y',s_y,'demand',s_demand);
          parameter(j)=struct('num',shuju(1),'Cap',shuju(4) ,'Bat',shuju(5),'r',shuju(6),'c',c);
     end
     
     for data=1:L
         disp(dirOutput(data).name); 
         fid=fopen(['test\testEX\','A.txt'],'a');
         fprintf(fid,'------ %s------------------\n',dirOutput(data).name);
         fid=fopen(['test\testEX\','B.txt'],'a');
         fprintf(fid,'------ %s------------------\n',dirOutput(data).name);
         fclose(fid); 
         x=[Depot(data).x;Customer(data).x;Station(data).x];
         y=[Depot(data).y;Customer(data).y;Station(data).y]; 
         cx=Customer(data).x;
         Dis=chulishuju(x,y,x,y);
         Disd=chulishuju([Depot(data).x;Customer(data).x],[Depot(data).y;Customer(data).y],[Depot(data).x;Customer(data).x],[Depot(data).y;Customer(data).y]);
         DisDC=chulishuju(Depot(data).x,Depot(data).y,Customer(data).x,Customer(data).y);
         DisDCS=chulishuju(Depot(data).x,Depot(data).y,[Customer(data).x;Station(data).x],[Customer(data).y;Station(data).y]);
         DisCC=chulishuju(Customer(data).x,Customer(data).y,Customer(data).x,Customer(data).y);
         DisCSCS=chulishuju([Customer(data).x;Station(data).x],[Customer(data).y;Station(data).y],[Customer(data).x;Station(data).x],[Customer(data).y;Station(data).y]);
         DisCS=chulishuju(Customer(data).x,Customer(data).y,Station(data).x,Station(data).y);
         DisDCsDCs=chulishuju([Depot(data).x;Customer(data).x],[Depot(data).y;Customer(data).y],Station(data).x,Station(data).y);
         DisDS=chulishuju(Depot(data).x,Depot(data).y,Station(data).x,Station(data).y);
         demand=Customer(data).demand;
         c=parameter(data).c;
         sdemand=zeros(length(Station(data).x),1);
         Demand=[Customer(data).demand;sdemand];
         Cap=parameter(data).Cap; 
         Bat=parameter(data).Bat;
         num=parameter(data).num;
         r=parameter(data).r;

         coi=[];
         for k=1:length(cx)
             min1(k)=min(DisCS(k,:));
             [~,co]=find(DisCS(k,:)==min1(k));
             coi=[coi co(1)];
         end
         maxxx=[];
         minnn=[];
          for k=1:length(Station(data).x)
             max1(k)=max(DisCS(:,k));
             [~,xx]=find(coi==k);
             if isempty(xx)
                maxx=1000;
                minn=0;
             else
                maxx=max(min1(xx));
                minn=min(min1(xx));
             end
             maxxx=[maxxx maxx];  
             minnn=[minnn minn];
          end
          pmaxa=[];
          a1=1;
          a2=0.1;
          for l=1:length(cx)%(1-min1(l)/max1(coi(l)));
                pmax=((maxxx(coi(l)))-(min1(l)-a2))/((maxxx(coi(l))+a1)-(minnn(coi(l))));
                pmaxa=[pmaxa pmax];
          end         

          bestDec=cell(1,length(cx));
          bestMask=zeros(10,length(cx));
          bestCost=ones(1,10)*1e15;
          Did=Depot(data).id;
          Cid=Customer(data).id;
          Sid=Station(data).id;
          tic
          parfor k=1:10
              [bestdec,bestmask,bestcost]=main(Did,Cid,Sid,x,y,cx,Dis,Disd,DisDC,DisCC,DisCS,DisDS,demand,Demand,Cap,Bat,r,pmaxa,dirOutput(data).name,DisDCS,DisCSCS,DisDCsDCs);
              fprintf("MMAS-GA-EX: 数据集%s第%d次运行的结果为最终结果：%f\n",dirOutput(data).name,k,bestcost);
              bestRoute1=uncode(bestdec,bestmask,Did,Cid,Sid,DisCS,DisCC,DisDS,demand,Cap,num);
              numc=length(find(bestRoute1==1))-1;
              fid=fopen(['test\testEX\','A.txt'],'a');
              fprintf(fid,'MMAS-GA-EX: 数据集%s第%d次运行的结果为：%.2f,车辆数：%d\n', dirOutput(data).name, k,bestcost,numc);
              fclose(fid);
              fid=fopen(['test\testEX\','B.txt'],'a');
              fprintf(fid,'MMAS-GA-EX: 数据集%s第%d次运行的结果为：%.2f,车辆数：%d\n', dirOutput(data).name,k,bestcost,numc);
              fprintf(fid,'-%s-\n',num2str(bestdec)); 
              fprintf(fid,'-%s-\n',num2str(bestmask));
              fprintf(fid,'-%s-\n',num2str(bestRoute1));
              fprintf(fid,'------------------------------------------------------------------------------------\n');
              fclose(fid);
              
              if ~isempty(bestmask)
                  bestCost(k)=bestcost;
                  bestMask(k,:)=bestmask;
                  bestDec{k}=bestdec;
              end
          end
          time=toc;
            

         [~,min_index]=min(bestCost);
         if bestCost(min_index)~=1e15
             bestRoute=uncode(bestDec{min_index},bestMask(min_index,:),Depot(data).id,Customer(data).id,Station(data).id,DisCS,DisCC,DisDS,demand,Cap,num);
             figure;
             plot(Station(data).x,Station(data).y,'ks','MarkerFaceColor', 'k','MarkerSize',10);
             hold on;
             plot(Customer(data).x,Customer(data).y,'ks','MarkerFaceColor', 'b','MarkerSize',5);
             hold on;
             plot(Depot(data).x,Depot(data).y,'ks','MarkerFaceColor', 'r','MarkerSize',10);
             hold on;
             for i=1:size(x)
                 text(x(i)+0.5,y(i)+0.5,num2str(i),'color',[1,0,0]);
             end
             for i=1:length(bestRoute)-1
                 if(bestRoute(i)==1)
                     plot(x(bestRoute(i),1),y(bestRoute(i),1),'ro','MarkerFaceColor', 'r','MarkerSize',10);
                 else
                     if(bestRoute(i)>=Station(data).id(1,:) && bestRoute(i)<=Station(data).id(end,:))
                         plot(x(bestRoute(i),1),y(bestRoute(i),1),'ks','MarkerFaceColor', 'k','MarkerSize',10);
                     else
                         plot(x(bestRoute(i),1),y(bestRoute(i),1),'b>','MarkerFaceColor', 'b','MarkerSize',5);
                     end
                 end
                 hold on;
                 if(bestRoute(i+1)==1)
                     plot(x(bestRoute(i+1),1),y(bestRoute(i+1),1),'ro','MarkerFaceColor', 'r','MarkerSize',10);
                 else
                     if(bestRoute(i+1)>=Station(data).id(1,:) && bestRoute(i+1)<=Station(data).id(end,:))
                         plot(x(bestRoute(i+1),1),y(bestRoute(i+1),1),'ks','MarkerFaceColor', 'k','MarkerSize',10);
                     else
                         plot(x(bestRoute(i+1),1),y(bestRoute(i+1),1),'b>','MarkerFaceColor', 'b','MarkerSize',5);
                     end
                 end
                 hold on;
                 plot([x(bestRoute(i),1),x(bestRoute(i+1),1)],[y(bestRoute(i),1),y(bestRoute(i+1),1)],'Color','b');
                 hold on;  
             end
             title([dirOutput(data).name]);
             xlabel('坐标X');
             ylabel('坐标Y');
             hold on;
             numc=length(find(bestRoute==1))-1;      
             f=getframe(gcf);
             imwrite(f.cdata,['test\testEX\figure\',dirOutput(data).name,' ',num2str(bestCost(min_index)),'+ ',num2str(numc),'.jpg']);
             close all
         end
     
          fid=fopen(['test\testEX\','A.txt'],'a');
          fprintf(fid,'MMAS-GA-EX: 数据集%s最终结果为：%.2f,车辆数：%d,10次运行总时间：%f\n', dirOutput(data).name,bestCost(min_index),(length(find(bestRoute==1))-1),time);
          fprintf(fid,'\n');
          fprintf(fid,'\n');
          fclose(fid);
     end

    case 4
        %% EX数据集 
     clc;format compact;
     file='data\R-C';
     fileFolder=fullfile(file);
     dirOutput=dir(fullfile(fileFolder,'*.txt'));
     L=length(dirOutput);
     empty_in1.x = [];
     empty_in1.y = [];
     empty_in1.demand = [];
     empty_in2.numc = [];
     empty_in2.nume = [];
     empty_in2.Cap = [];
     empty_in2.Bat = [];
%      empty_in2.r = [];
     Customer = repmat(empty_in1,1,L); 
     Depot = repmat(empty_in1,1,L); 
     Station = repmat(empty_in1,1,L); 
     parameter= repmat(empty_in2,1,L);
     

     for j=1:L
          fileNames{j}=strcat('data\R-C\',dirOutput(j).name); 
          disp(dirOutput(j).name);   
          shuju=textread(fileNames{j},'%f',5,'delimiter', ' ');
          [d_x,d_y]=textread(fileNames{j},'%f%f',1,'delimiter', ' ','headerlines',5);
          d_demand=0;
          Depot(j)=struct('x',d_x,'y',d_y,'demand',d_demand);
          [c_x,c_y,c_demand]=textread(fileNames{j},'%f%f%f',shuju(1),'delimiter',' ','headerlines',1+5);
          Customer(j)=struct('x',c_x,'y',c_y,'demand',c_demand);
          [s_x,s_y]=textread(fileNames{j},'%f%f',shuju(2),'delimiter',' ','headerlines',shuju(1)+1+5);
          s_demand=zeros(length(s_x),1);
          Station(j)=struct('x',s_x,'y',s_y,'demand',s_demand);
          parameter(j)=struct('numc',shuju(1),'nume',shuju(2),'Cap',shuju(3) ,'Bat',shuju(4));
     end
     

     for data=1:L
         disp(dirOutput(data).name); 
         Did(1)=1;
         Cid1=(1:length(Customer(data).x))+1;Cid=Cid1';
         Sid1=(1:length(Station(data).x))+length(Customer(data).x)+1;Sid=Sid1';
         fid=fopen(['test\testRC\','A.txt'],'a');
         fprintf(fid,'------ %s------------------\n',dirOutput(data).name);
         fid=fopen(['test\testRC\','B.txt'],'a');
         fprintf(fid,'------ %s------------------\n',dirOutput(data).name);
         fclose(fid); 
         x=[Depot(data).x;Customer(data).x;Station(data).x];
         y=[Depot(data).y;Customer(data).y;Station(data).y]; 
         cx=Customer(data).x;
         cy=Customer(data).y;
         Dis=chulishuju(x,y,x,y);
         Disd=chulishuju([Depot(data).x;Customer(data).x],[Depot(data).y;Customer(data).y],[Depot(data).x;Customer(data).x],[Depot(data).y;Customer(data).y]);
         DisDC=chulishuju(Depot(data).x,Depot(data).y,Customer(data).x,Customer(data).y);
         DisDCS=chulishuju(Depot(data).x,Depot(data).y,[Customer(data).x;Station(data).x],[Customer(data).y;Station(data).y]);
         DisCC=chulishuju(Customer(data).x,Customer(data).y,Customer(data).x,Customer(data).y);
         DisCSCS=chulishuju([Customer(data).x;Station(data).x],[Customer(data).y;Station(data).y],[Customer(data).x;Station(data).x],[Customer(data).y;Station(data).y]);
         DisCS=chulishuju(Customer(data).x,Customer(data).y,Station(data).x,Station(data).y);
         DisDCsDCs=chulishuju([Depot(data).x;Customer(data).x],[Depot(data).y;Customer(data).y],Station(data).x,Station(data).y);
         DisDS=chulishuju(Depot(data).x,Depot(data).y,Station(data).x,Station(data).y);
         demand=Customer(data).demand;
         sdemand=zeros(length(Station(data).x),1);
         Demand=[Customer(data).demand;sdemand];
         Cap=parameter(data).Cap; 
         Bat=parameter(data).Bat;
         num=20;
         r=1;

         coi=[];
         for k=1:length(cx)
             min1(k)=min(DisCS(k,:));
             [~,co]=find(DisCS(k,:)==min1(k));
             coi=[coi co(1)];
         end
         maxxx=[];
         minnn=[];
          for k=1:length(Station(data).x)
             max1(k)=max(DisCS(:,k));
             [~,xx]=find(coi==k);
             if isempty(xx)
                maxx=1000;
                minn=0;
             else
                maxx=max(min1(xx));
                minn=min(min1(xx));
             end
             maxxx=[maxxx maxx];  
             minnn=[minnn minn];
          end
          pmaxa=[];
          a1=1;
          a2=0.1;
          for l=1:length(cx)%(1-min1(l)/max1(coi(l)));
                pmax=((maxxx(coi(l)))-(min1(l)-a2))/((maxxx(coi(l))+a1)-(minnn(coi(l))));
                pmaxa=[pmaxa pmax];
          end         

          bestDec=cell(1,length(cx));
          bestMask=zeros(10,length(cx));
          bestCost=ones(1,10)*1e15;

          tic
          for k=1:1
              [bestdec,bestmask,bestcost]=main(Did,Cid,Sid,x,y,cx,Dis,Disd,DisDC,DisCC,DisCS,DisDS,demand,Demand,Cap,Bat,r,pmaxa,dirOutput(data).name,DisDCS,DisCSCS,DisDCsDCs);
              fprintf("MMAS-GA-RC: 数据集%s第%d次运行的结果为最终结果：%f\n",dirOutput(data).name,k,bestcost);
              bestRoute1=bestdec;
              numc=length(find(bestRoute1==1))-1;
              fid=fopen(['test\testRC\','A.txt'],'a');
              fprintf(fid,'MMAS-GA-RC: 数据集%s第%d次运行的结果为：%.2f,车辆数：%d\n', dirOutput(data).name, k,bestcost,numc);
              fclose(fid);
              fid=fopen(['test\testRC\','B.txt'],'a');
              fprintf(fid,'MMAS-GA-RC: 数据集%s第%d次运行的结果为：%.2f,车辆数：%d\n', dirOutput(data).name,k,bestcost,numc);
              fprintf(fid,'-%s-\n',num2str(bestdec)); 
              fprintf(fid,'-%s-\n',num2str(bestmask));
              fprintf(fid,'-%s-\n',num2str(bestRoute1));
              fprintf(fid,'------------------------------------------------------------------------------------\n');
              fclose(fid);
              
              if ~isempty(bestmask)
                  bestCost(k)=bestcost;
                  bestMask(k,:)=bestmask;
                  bestDec{k}=bestdec;
              end
          end
          time=toc;
            

          fid=fopen(['test\testRC\','A.txt'],'a');
          fprintf(fid,'MMAS-GA-RC: 数据集%s最终结果为：%.2f,车辆数：%d,10次运行总时间：%f\n', dirOutput(data).name,bestCost(min_index),(length(find(bestRoute==1))-1),time);
          fprintf(fid,'\n');
          fprintf(fid,'\n');
          fclose(fid);
     end
       
end
end
        

