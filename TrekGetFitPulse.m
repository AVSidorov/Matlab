function FitPulse=TrekGetFitPulse(STP,Shift)
Stp=STP.Stp;
StpN=STP.size;

FitPulse=interp1([1:StpN]',Stp,[1:StpN]'+Shift,'spline',0);
FitPulse(FitPulse(1:STP.MaxInd)<0)=0;
bool=FitPulse<0;
bool(1:STP.IndPositiveTail(3))=false;
FitPulse(bool)=0;
FitPulse(1:STP.BckgFitN-round(Shift))=0;
FitPulse(end-(STP.ZeroTailN-1+round(Shift)):end)=0;
IndNeg=find(FitPulse<0);
IndPos=find(FitPulse>0);
IndPos(IndPos<IndNeg(1))=[];
IndPulse=1:IndNeg(1)-1;
FitPulse(IndPulse)=FitPulse(IndPulse)*(sum(FitPulse(IndPulse))-sum(FitPulse))/sum(FitPulse(IndPulse));