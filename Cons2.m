function cons=Cons2(dec,mask,Dis,Bat,Did,Cid,Sid,DisCS,DisCC,DisDS,demand,Cap)
    s=uncode(dec,mask,Did,Cid,Sid,DisCS,DisCC,DisDS,demand,Cap,num);
    cost=Eval(s,Dis);
    num=length(find(s==1))-1;
    Node=length(Cid)+1;
    snum=length(find(s>Node));
    cons=-(min((cost-(num+snum)*Bat),0));

end