function FIT=TrekSDD2FitFunctions(TrekSet,FIT)
fprintf('Time fiting started. Ind is %6d\n',FIT.MaxInd);
% This function is gate between TrekSDD proccesing functions and Fit..
% functions
CutN=2;
BckgFitN=5;

FitIndPulse=[1:TrekSet.STP.size]';
trek=TrekSet.trek;
Stp=TrekSet.STP.Stp;
MaxIndStp=TrekSet.STP.MaxInd;
MaxShiftR=FIT.ShiftRangeR;
MaxShiftL=-FIT.ShiftRangeL;
FitIndPulseStrict=[TrekSet.STP.BckgFitN-BckgFitN:TrekSet.STP.MinFitPoint];

ex=false;
while ~ex
    FitIndStart=FIT.FitInd;

    FitInd=FIT.FitInd;
    MaxInd=FIT.MaxInd;
    
    [Y,F,FIT]=FitShift(trek,Stp,FitInd,FitIndPulse,MaxInd,MaxIndStp,0);
    if  FIT.MaxShiftR==0 
        FitInd=FitInd(1+CutN:end);
        MaxShiftR=CutN;
    else
        MaxShiftR=min([FIT.MaxShiftR,MaxShiftR]);
    end;
    if FIT.MaxShiftL==0 
        FitInd=FitInd(1:end-CutN); 
        MaxShiftL=-CutN;
    else
        MaxShiftL=max([FIT.MaxShiftL,MaxShiftL]);
    end;
    




    sh=fminbnd(@(sh)FitMoved(trek,TrekSet.STP,FitInd,FitIndPulse,MaxInd,MaxIndStp,sh,@TrekSDD2FitShift,@FitAB),MaxShiftL,MaxShiftR);
    [khi,FIT1]=FitMoved(trek,TrekSet.STP,FitInd,FitIndPulse,MaxInd,MaxIndStp,sh,@TrekSDD2FitShift,@FitAB);
    [Y,F,FIT]=TrekSDD2FitShift(trek,TrekSet.STP,FitInd,FitIndPulse,MaxInd,MaxIndStp,sh);
    FIT.A=FIT1.A;
    FIT.B=FIT1.B;
    FIT.Shift=sh;
    FIT.N=numel(Y);
    FIT.Khi=sqrt(sum(((Y-FIT.A*F-FIT.B)/TrekSet.StdVal).^2)/FIT.N);
    FIT.FitIndStrict=FIT.FitInd;
    FIT.FitIndPulseStrict=[];
    FIT.ShiftRangeL=MaxShiftL;
    FIT.ShiftRangeR=MaxShiftR;
    FIT.FitFast=0;
    FIT.BGLineFit=[0,0];
    if abs(sh-MaxShiftL)<0.5||abs(sh-MaxShiftL)<0.5
        FIT.MaxInd=FIT.MaxInd+round(sh);
    end;
    FIT=TrekSDDGetFitInd(TrekSet,FIT);
    
    if FIT.MaxInd==MaxInd&&numel(FitIndStart)==numel(FIT.FitInd)&&numel(intersect(FitIndStart,FIT.FitInd))==numel(FitIndStart)
        ex=true;
    end;
end;