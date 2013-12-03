function FitPulse=TrekSDDGetFitPulse(STP,Shift)
Stp=STP.FinePulse;
StpN=STP.size;
TimeInd=STP.TimeInd;

FitPulse=interp1(TimeInd,Stp,[1:StpN]'+Shift,'linear',0);
FitPulse(FitPulse(1:STP.MaxInd)<0)=0;
bool=FitPulse<0;
bool(1:STP.IndPositiveTail(3))=false;
FitPulse(bool)=0;
FitPulse(1:STP.BckgFitN-round(Shift))=0;
FitPulse(end-(STP.ZeroTailN-1+round(Shift)):end)=0; 

% FitPulse=FitPulse/max(FitPulse);