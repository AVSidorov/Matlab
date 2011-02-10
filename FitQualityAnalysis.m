function Khi2=FitQualityAnalysis(Specs);

minE=0.5;
maxE=4;

N=size(Specs,2);

for i=1:N
    S=interp1(Specs(i).Hist(:,1),Specs(i).Hist(:,2)/max(Specs(i).Hist(:,2)),[minE:0.01:maxE],'cubic',0);
    Sintrp(:,i)=S';
end;

NPair=N*(N-1)/2;

n=size(Sintrp,1);

Khi2=0;
for i=1:N
    for ii=i+1:N
        Khi2=Khi2+sum((Sintrp(:,i)-Sintrp(:,ii)).^2)/NPair/n;
    end;
end;
