function Khi2=FitQualityAnalysis(Specs)
% Khi2=FitQualityAnalysis(Specs)
% This function work with array of HistSets
% HistSet is struct with histogram in Energy Range.Histogram is 
% obtained from pulses wich obtained with TrekPeaks2keV

minE=0.8;
maxE=2.5;

N=numel(Specs);

for i=1:N
    S=interp1(Specs(i).Hist(:,1),Specs(i).Hist(:,2),[minE:0.01:maxE],'cubic',0);
    Sintrp(:,i)=S'/mean(S);
end;

NPair=N*(N-1)/2;

n=size(Sintrp,1);

Khi2=0;
for i=1:N
    for ii=i+1:N
        Khi2=Khi2+sum((Sintrp(:,i)-Sintrp(:,ii)).^2)/NPair/n;
    end;
end;
