 function FIT=TrekSDDFitByMove(TrekSetIn,Ind)
% function TrekSet=TrekSDDFitByMove(TrekSetIn,Ind)
T=0;
Tmax=120;

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
FitIndPulseL=[1:STP.MaxInd]';
%%

FitPulse=TrekSet.STP.Stp(FitIndPulse);
FitPulseL=TrekSet.STP.Stp(FitIndPulseL);
A=zeros(TrekSet.size,3);
B=zeros(TrekSet.size,3);
good=false(TrekSet.size,2);
if nargin<2
    Ind=1;
else
    IndInitial=Ind;
end;

Flag=false(6,1);
I=zeros(2,1);
timeId=tic;

while T<Tmax&&Ind<TrekSet.size-STP.MaxInd;
FitInd=FitIndPulse+Ind-1;
p=polyfit(FitPulse,TrekSet.trek(FitInd),1);
khi=sqrt(sum(((TrekSet.trek(FitInd)-p(1)*FitPulse-p(2))/TrekSet.StdVal).^2)/N);
good(Ind,1)=all(TrekSet.trek(FitInd)-p(1)*FitPulse-p(2)<TrekSet.StdVal*TrekSet.OverSt);
A(Ind,1:2)=p;
A(Ind,3)=khi;

FitInd=FitIndPulseL+Ind-1;
p=polyfit(FitPulseL,TrekSet.trek(FitInd),1);
khi=sqrt(sum(((TrekSet.trek(FitInd)-p(1)*FitPulseL-p(2))/TrekSet.StdVal).^2)/N);
good(Ind,2)=all(TrekSet.trek(FitInd)-p(1)*FitPulseL-p(2)<TrekSet.StdVal*TrekSet.OverSt);
B(Ind,1:2)=p;
B(Ind,3)=khi;


if A(Ind,1)>TrekSet.OverSt*TrekSet.StdVal
    Flag(1)=true;
else
    Flag(1)=false;    
end;
if B(Ind,1)>TrekSet.OverSt*TrekSet.StdVal
    Flag(2)=true;
else
    Flag(2)=false;    
end;
if  Ind>2&&Flag(1)&&A(Ind,3)>A(Ind-1,3)&&A(Ind-2,3)>A(Ind-1,3)
    Flag(3)=true;
    I(1)=Ind-1;
end;
if  Ind>2&&Flag(2)&&B(Ind,3)>B(Ind-1,3)&&B(Ind-2,3)>B(Ind-1,3)
    Flag(4)=true;
    I(2)=Ind-1;
end;

if  Ind>2&&Flag(1)&&A(Ind,1)<A(Ind-1,1)&&A(Ind-2,1)<A(Ind-1,1)
    Flag(5)=true;
end;

if  Ind>2&&Flag(2)&&B(Ind,1)<B(Ind-1,1)&&B(Ind-2,1)<B(Ind-1,1)
    Flag(6)=true;
end;

if all(Flag(1:2))&&any(Flag(3:4))&&any(Flag(5:6))
    FIT.Shift=0;
    FIT.FitPulse=TrekSet.STP.Stp;
    FIT.FitPulseN=TrekSet.STP.size;
    FIT.BGLineFit=[0,0];
    if all(Flag(3:4))&&good(I(1),1)&&good(I(2),2)&&range(I)<3&&abs(A(I(1),1)-B(I(1),1))<TrekSet.OverSt*TrekSet.StdVal
        FIT.MaxInd=round(mean(I(I>0))-1+TrekSet.STP.MaxInd);
        FIT.A=B(FIT.MaxInd+1-TrekSet.STP.MaxInd,1);
        FIT.B=B(FIT.MaxInd+1-TrekSet.STP.MaxInd,2);
        FIT.Khi=B(FIT.MaxInd+1-TrekSet.STP.MaxInd,3);
        FIT.N=TrekSet.STP.MaxInd;
        FIT.FitIndPulseStrict=FitIndPulseL;
        FIT.FitIndStrict=FitIndPulseL+FIT.MaxInd+1-TrekSet.STP.MaxInd;
    elseif Flag(3)
        FIT.MaxInd=I(1)-1+TrekSet.STP.MaxInd;
        FIT.A=A(FIT.MaxInd+1-TrekSet.STP.MaxInd,1);
        FIT.B=A(FIT.MaxInd+1-TrekSet.STP.MaxInd,2);
        FIT.Khi=A(FIT.MaxInd+1-TrekSet.STP.MaxInd,3);
        FIT.FitIndPulseStrict=FitIndPulse;
        FIT.FitIndStrict=FitIndPulse+FIT.MaxInd+1-TrekSet.STP.MaxInd;
        FIT.N=N;
   elseif Flag(4)
        FIT.MaxInd=I(2)-1+TrekSet.STP.MaxInd;
        FIT.A=B(FIT.MaxInd+1-TrekSet.STP.MaxInd,1);
        FIT.B=B(FIT.MaxInd+1-TrekSet.STP.MaxInd,2);
        FIT.Khi=B(FIT.MaxInd+1-TrekSet.STP.MaxInd,3);
        FIT.N=TrekSet.STP.MaxInd;
        FIT.FitIndPulseStrict=FitIndPulseL;
        FIT.FitIndStrict=FitIndPulseL+FIT.MaxInd+1-TrekSet.STP.MaxInd;           
    end;        
    FIT.Good=all((TrekSet.trek(FIT.FitIndStrict-1)-FIT.A*FIT.FitPulse(FIT.FitIndPulseStrict)-FIT.B)<TrekSet.OverSt*TrekSet.StdVal);
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
end; %while
Ind;
