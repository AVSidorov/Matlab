function FitPulse=TrekSDDGetFitPulse(STP,Shift)
Stp=STP.FinePulse;
StpN=STP.size;
TimeInd=STP.TimeInd;
FitPulse=zeros(StpN,1);
Nfit=1/STP.TimeStep;

%to avoid not integer Nfit
ex=0;
if (Nfit-fix(Nfit))<Nfit/100
    Nfit=round(Nfit);
    ex=1;
end;
ex=0;    

if Shift>=0
    iS=1+Shift*Nfit;
    N=StpN-ceil(Shift);
    if ex==1&&abs(round(iS)-iS)<Nfit/10000
        FitPulse(1:N)=Stp(round(iS):Nfit:round(iS+(N-1)*Nfit));
    else
        FitPulse=interp1(TimeInd,Stp,[1:StpN]'+Shift,'PCHIP',0);
    end;
end;
if Shift<0
    iE=1+(StpN-1)*Nfit+Shift*Nfit;
    N=1-floor(Shift);
    if ex==1&&abs(round(iE)-iE)<Nfit/10000        
        FitPulse(N:StpN)=Stp(round(iE-Nfit*(StpN-N)):Nfit:round(iE));
    else        
        FitPulse=interp1(TimeInd,Stp,[1:StpN]'+Shift,'PCHIP',0);
    end;
end;
FitPulse(FitPulse(1:STP.MaxInd)<0)=0;
bool=FitPulse<0;
if ~isempty(STP.IndNegativeTail)
    Ind=STP.IndNegativeTail(end);
    % if numel(STP.IndPositiveTail)>=3
    %     Ind=STP.IndPositiveTail(3);
    % end;
    bool(1:Ind)=false;
end;
FitPulse(bool)=0;

if STP.BckgFitN-round(Shift)>=1&&STP.BckgFitN-round(Shift)<=StpN
    FitPulse(1:STP.BckgFitN-round(Shift))=0;
end;
if STP.ZeroTailN-1+round(Shift)>0&&STP.ZeroTailN-1+round(Shift)<StpN
    FitPulse(end-(STP.ZeroTailN-1+round(Shift)):end)=0; 
end;

% FitPulse=FitPulse/max(FitPulse);