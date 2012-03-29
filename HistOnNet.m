function Hist=HistOnNet(A,net)
for i=1:numel(net)-1
    Hist(i,1)=(net(i)+net(i+1))/2;
    N=numel(find(A>net(i)&A<=net(i+1)));
    err=1/sqrt(N);
    Hist(i,2)=N/(net(i+1)-net(i));
    Hist(i,3)=Hist(i,2)*err;
end;
    