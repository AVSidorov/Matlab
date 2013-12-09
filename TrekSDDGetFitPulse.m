function FitPulse=TrekSDDGetFitPulse(STP,Shift)
Stp=STP.FinePulse;
StpN=STP.size;
TimeInd=STP.TimeInd;
FitPulse=zeros(StpN,1);
Nfit=round(1/min(diff(TimeInd)));

if Shift>=0
    iS=find(1+Shift==TimeInd);
    N=StpN-ceil(Shift);
    if ~isempty(iS)
        FitPulse(1:N)=Stp(iS:Nfit:iS+(N-1)*Nfit);
    else
        FitPulse=interp1(TimeInd,Stp,[1:StpN]'+Shift,'linear',0);
    end;
end;
if Shift<0
    iE=find(StpN+Shift==TimeInd);
    N=1-floor(Shift);
    if ~isempty(iE)
        FitPulse(N:StpN)=Stp(iE-Nfit*(StpN-N):Nfit:iE);
    else        
        FitPulse=interp1(TimeInd,Stp,[1:StpN]'+Shift,'linear',0);
    end;
end;
FitPulse(FitPulse(1:STP.MaxInd)<0)=0;
bool=FitPulse<0;
bool(1:STP.IndPositiveTail(3))=false;
FitPulse(bool)=0;
FitPulse(1:STP.BckgFitN-round(Shift))=0;
FitPulse(end-(STP.ZeroTailN-1+round(Shift)):end)=0; 

% FitPulse=FitPulse/max(FitPulse);