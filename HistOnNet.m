function Hist=HistOnNet(A,net)
tic;
Hist=zeros(numel(net)-1,3);
Hist(:,1)=(net(1:end-1)+net(2:end))/2;
for i=1:numel(net)-1
    N=numel(find(A>net(i)&A<=net(i+1)));
    Hist(i,2)=N/(net(i+1)-net(i));
end;
Hist(:,3)=sqrt(Hist(:,2));    
toc;