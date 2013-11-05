 function FIT=TrekSDDFitByMove(TrekSetIn,Ind)
% function TrekSet=TrekSDDFitByMove(TrekSetIn,Ind)
T=0;
Tmax=900;

TrekSet=TrekSetIn;


%% determination of strict part of standard pulse
if ~isempty(TrekSet.STP)
    STP=TrekSet.STP;
else
    STP=StpStruct;
end;

STPD=StpStruct([STP.TimeInd(1:end-1),diff(STP.FinePulse)]);
SPSetStpD=SpecialTreks(STPD.FinePulse);
endIndPulse=round(STPD.TimeInd(SPSetStpD.MinInd(find(STPD.TimeInd(SPSetStpD.MinInd)>STPD.MaxInd,1,'first'))));
if isempty(endIndPulse)||endIndPulse>=STP.MaxInd
    endIndPulse=round((STPD.MaxInd+STP.MaxInd)/2);
end;
FitIndPulse=[1:endIndPulse]';
N=numel(FitIndPulse);
%%

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
if Ind>2&&all(A(Ind-1,1)>TrekSet.OverSt*TrekSet.StdVal)&&((A(Ind,3)>A(Ind-1,3)&&A(Ind-2,3)>A(Ind-1,3))||(A(Ind,3)<A(Ind-1,3)&&A(Ind-2,3)<A(Ind-1,3)))
    FIT.A=A(Ind-1,1);
    FIT.B=A(Ind-1,2);
    FIT.Good=all((TrekSet.trek(FitInd-1)-FIT.A*FitPulse(FitIndPulse)-FIT.B)<TrekSet.OverSt*TrekSet.StdVal);
    FIT.Shift=0;
    FIT.Khi=A(Ind-1,3);
    FIT.FitPulse=TrekSet.STP.Stp;
    FIT.FitPulseN=TrekSet.STP.size;
    FIT.BGLineFit=[0,0];
    FIT.N=N;
    FIT.MaxInd=(Ind-1)-1+TrekSet.STP.MaxInd;
    FIT.FitIndPulseStrict=FitIndPulse;
    FIT.FitIndStrict=FitInd;
    if FIT.Good
        FIT.ShiftRangeR=3;
        FIT.ShiftRangeL=3;
    else
        FIT.ShiftRangeR=5;
        FIT.ShiftRangeL=5;
    end;
    FIT=TrekSDDGetFitInd(TrekSet,FIT);
    FIT.FitFast=false;
    break;
end;    
Ind=Ind+1;
T=toc(timeId);
end;
