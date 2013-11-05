function TrekSet=TrekSDDFitByMove(TrekSetIn,Ind)
T=0;
Tmax=900;

TrekSet=TrekSetIn;
FitIndPulse=[1:49];
N=numel(FitIndPulse);
FitPulse=TrekSet.STP.Stp(FitIndPulse);
A=zeros(TrekSet.size,3);
if nargin<2
    Ind=1;
end;

timeId=tic;
while T<Tmax&&Ind<TrekSet.size-N;
FitInd=FitIndPulse+Ind-1;
p=polyfit(FitPulse,TrekSet.trek(FitInd),1);
khi=sqrt(sum(((TrekSet.trek(FitInd)-p(1)*FitPulse(FitIndPulse)-p(2))/TrekSet.StdVal).^2)/N);
A(Ind,1:2)=p;
A(Ind,3)=khi;
if Ind>2&&all(A(Ind-2:Ind,1)>TrekSet.Threshold)&&A(Ind,3)>A(Ind-1,3)&&A(Ind-2,3)>A(Ind-1,3)
    FIT.A=A(Ind-1,1);
    FIT.B=A(Ind-1,2);
    FIT.Good=all((TrekSet.trek(FitInd-1)-FIT.A*FitPulse(FitIndPulse)-FIT.B)<TrekSet.OverSt*TrekSet.StdVal);
    FIT.Shift=0;
    FIT.Khi=A(Ind-1,3);
    FIT.FitPulse=TrekSet.STP.Stp;
    FIT.FitPulseN=TrekSet.STP.size;
    FIT.BGLineFit=[0,0];
    FIT.FitIndPulse=FitIndPulse;
    FIT.FitInd=FitInd-1;
    FIT.N=N;
    FIT.MaxInd=(Ind-1)-1+TrekSet.STP.MaxInd;
    [TrekSet,TrekSet1]=TrekSDDSubtract(TrekSet,FIT);
    TrekSet=TrekSet1;
    Ind=Ind-TrekSet.STP.MaxInd;
    A(Ind+1:end,:)=0;
end;    
Ind=Ind+1;
T=toc(timeId);
end;
