function FIT=TrekSDD2FitFunctions(TrekSet,FIT)
fprintf('Time fiting started. Ind is %6d\n',FIT.MaxInd);
% This function is gate between TrekSDD proccesing functions and Fit..
% functions

FitIndPulse=[1:TrekSet.STP.size]';
FitIndPulseStrict=FIT.FitIndPulseStrict;
trek=TrekSet.trek;
MaxIndStp=TrekSet.STP.MaxInd;
MaxShiftR=FIT.ShiftRangeR;
MaxShiftL=-FIT.ShiftRangeL;


ex=false;
FitIndDir=0;
while ~ex
    FitIndStart=FIT.FitInd;

    FitInd=FIT.FitInd;
    MaxInd=FIT.MaxInd;
      
    sh=fminbnd(@(sh)FitMoved(trek,TrekSet.STP,FitInd,FitIndPulse,MaxInd,MaxIndStp,sh,@TrekSDD2FitShift,@FitAB),MaxShiftL,MaxShiftR);
    [khi,FIT1]=FitMoved(trek,TrekSet.STP,FitInd,FitIndPulse,MaxInd,MaxIndStp,sh,@TrekSDD2FitShift,@FitAB);
    [Y,F,FIT]=TrekSDD2FitShift(trek,TrekSet.STP,FitInd,FitIndPulse,MaxInd,MaxIndStp,sh);
    FIT.A=FIT1.A;
    FIT.B=FIT1.B;
    FIT.Shift=sh;
    FIT.N=numel(Y);
    FIT.Khi=sqrt(sum(((Y-FIT.A*F-FIT.B)/TrekSet.StdVal).^2)/FIT.N);
    FIT.FitIndStrict=FIT.FitInd;
    FIT.FitIndPulseStrict=FitIndPulseStrict;
    FIT.ShiftRangeL=MaxShiftL;
    FIT.ShiftRangeR=MaxShiftR;
    FIT.FitFast=0;
    FIT.BGLineFit=[0,0];
    if abs(sh-MaxShiftL)<0.5||abs(sh-MaxShiftR)<0.5
        FIT.MaxInd=FIT.MaxInd+round(sh);
    end;
    FIT=TrekSDDGetFitInd(TrekSet,FIT);
    
    if FIT.MaxInd==MaxInd&&numel(FitIndStart)==numel(FIT.FitInd)&&numel(intersect(FitIndStart,FIT.FitInd))==numel(FitIndStart)
        ex=true;
    end;
    if FitIndDir*sign(numel(FIT.FitInd)-numel(FitIndStart))<0
        ex=true;
    end;
    FitIndDir=sign(numel(FIT.FitInd)-numel(FitIndStart));
end;