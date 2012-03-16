function Hist=HistOnNet(A,net)
for i=1:numel(net)-1
    Hist(i,1)=(net(i)+net(i+1))/2;
    Hist(i,2)=numel(find(A>net(i)&A<=net(i+1)));
    Hist(i,3)=sqrt(Hist(i,2));
end;
    