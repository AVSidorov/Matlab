function Hist=HistOnNet(A,net)
tic;
Hist=zeros(numel(net)-1,3);
Hist(:,1)=(net(1:end-1)+net(2:end))/2;
Nmax=0;
Imax=[];
for i=1:numel(net)-1
    N=numel(find(A>net(i)&A<=net(i+1)));
    Hist(i,2)=N/(net(i+1)-net(i));
    if N>Nmax
     Nmax=N;
     Imax=i;
    end;
end;
if ~isempty(Imax)
    k=(net(Imax+1)-net(Imax));
else 
    k=1;
end;
Hist(:,2)=Hist(:,2)*k;
Hist(:,3)=sqrt(Hist(:,2));    
toc;