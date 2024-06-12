function S=uncode(Dec,Mask,Did,Cid,Sid,DisCS,DisCC,DisDS,demand,Cap,num)
Dec(Dec>length(Mask)+1)=[];
OffDec1=Dec-1;
OffDec1(OffDec1==0)=[];
dec_route=find(Dec==1);
Mask1=[];
for k=1:length(Mask)
    Mask1(end+1)=Mask(OffDec1(k));
end
Mask=Mask1;
temp_mask=Mask;
decdec=cell(1,length(dec_route)-1);
maskmask=cell(1,length(dec_route)-1);
for ii=1:length(dec_route)-1
    temp_dec=Dec(dec_route(ii):dec_route(ii+1));
    temp_dec=temp_dec-1;
    temp_dec(temp_dec==0)=[];
    if ~isempty(temp_dec)
        decdec{ii}=temp_dec;
        maskmask{ii}=temp_mask(1:length(temp_dec));
        temp_mask(1:length(decdec{ii}))=[];
    end
end
S=[];
S(end+1)=Did(1);
for ii=1:length(dec_route)-1
    dec=decdec{ii};
    mask=maskmask{ii};
    if ~isempty(dec)
        if length(dec)~=1 
            for i=1:length(dec)-1
                S(end+1)=Cid(dec(i));
                if(mask(i)~=0)
                    [~,index]=min(DisCS(dec(i),:)+DisCS(dec(i+1),:));
                    S(end+1)=Sid(index);
                end
            end
            i=i+1;
            S(end+1)=Cid(dec(i));
            if(mask(i)~=0)
                [~,index]=min(DisCS(dec(i),:)+DisDS(1,:));
                S(end+1)=Sid(index);  
            end
            S(end+1)=Did(1);
        else
            S(end+1)=Cid(dec(1));
            if (mask(1)~=0)
                [~,index]=min(DisCS(dec(1),:)+DisDS(1,:));
                S(end+1)=Sid(index);  
            end
            S(end+1)=Did(1);
        end
    end
end
end