function NoiseSet=NoiseFitAuto(trek)
%This function is similiar to NoiseFit in using Gaussian fit but works automatic 
%Itterative procedure similiar to TrekStdVal (but Gaussian fit used) ;)
trSize=numel(trek);
Ind=[1:trSize]';
trD=diff(trek);
MinHistStep=min(abs(trD(abs(trD)>0)));

StdVal=std(trek(Ind));
MeanVal=mean(trek(Ind));
Ind=find(abs(trek-MeanVal)<3.5*StdVal);
Step=max(MinHistStep,range(trek(Ind))/100);

Nold=inf;
Hist=[];
while numel(Ind)<Nold
    MedianVal=median(trek(Ind));
    Range=range(trek(Ind));
    if ~isempty(Hist)
        Step=max([MinHistStep,Step/max(Hist(:,2))/100]);
    end;
    Net=[max([MedianVal-50*Step,min(trek)-Step/2]):Step:min([MedianVal+50*Step,max(trek)+Step/2])];
    Hist=HistOnNet(trek(Ind),Net);
    [M,MaxInd]=max(Hist(:,2));
    IndHist=[find(Hist(1:MaxInd,2)<=M/exp(1),1,'last'):MaxInd+find(Hist(MaxInd:end,2)<=M/exp(1),1,'first')]';
    [fit,s,m]=polyfit(Hist(IndHist,1),log(Hist(IndHist,2)),2);
    mid=-fit(2)/(2*fit(1))*m(2)+m(1);
    r=roots(fit)*m(2)+m(1);
    StdDev=sqrt(-1/fit(1)/2)*m(2);
    Thr=mean(abs(r-mid));
    OverSt=Thr/StdDev;
    Nold=numel(Ind);
    Ind=find(abs(trek-mid)<Thr);
end;

fprintf('Std is %3.3f by std() %3.3f\n',StdDev,StdVal);
fprintf('Mean is %3.3f by mean() %3.3f\n',mid,MeanVal);
fprintf('Threshold is %3.3f, and OverSt %3.3f\n',Thr,OverSt);


NoiseSet.MeanVal=mid;
NoiseSet.StdVal=StdDev;
NoiseSet.Threshold=Thr;
NoiseSet.OverSt=OverSt;
NoiseSet.Ind=Ind;