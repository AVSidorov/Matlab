function [FIT1,FIT2]=TrekSDD2FitFunctionsDouble(TrekSet,FIT)
fprintf('Time fiting started. Ind is %6d\n',FIT.MaxInd);
% This function is gate between TrekSDD proccesing functions and Fit..
% functions

FitIndPulse=[1:TrekSet.STP.size]';
trek=TrekSet.trek;

MaxIndStp=TrekSet.STP.MaxInd;
MaxInd=FIT.MaxInd;
FitInd=FIT.FitInd;
sh=FIT.Shift;

ex=false;
while ~ex

    FitIndStart=FitInd;
    
    opt=optimset('TolX',1/20,'TolFun',1/100);
    sh=fminsearch(@(sh)FitMovedDouble(trek,TrekSet.STP,FitInd,FitIndPulse,MaxInd,MaxIndStp,sh,@TrekSDD2FitShift,@FitDoubleAB),sh,opt);
    sh=sort(sh);
    [khi,FIT]=FitMovedDouble(trek,TrekSet.STP,FitInd,FitIndPulse,MaxInd,MaxIndStp,sh,@TrekSDD2FitShift,@FitDoubleAB);
    [Y,F1,FIT1]=TrekSDD2FitShift(trek,TrekSet.STP,FitInd,FitIndPulse,MaxInd,MaxIndStp,sh(1));
    [Y,F2,FIT2]=TrekSDD2FitShift(trek,TrekSet.STP,FitInd,FitIndPulse,MaxInd,MaxIndStp,sh(2));
    FIT1.A=FIT.A1;
    FIT1.B=FIT.B/2;
    FIT1.Shift=sh(1);
    FIT1.N=numel(Y);
    FIT1.Khi=sqrt(sum(((Y-FIT.A1*F1-FIT.A2*F2-FIT.B)/TrekSet.StdVal).^2)/FIT1.N);
    FIT1.FitIndStrict=FIT1.FitInd;
    FIT1.FitIndPulseStrict=[];
    FIT1.FitFast=0;
    FIT1.BGLineFit=[0,0];

    FIT2.A=FIT.A2;
    FIT2.B=FIT.B/2;
    FIT2.Shift=sh(2);
    FIT2.N=numel(Y);
    FIT2.Khi=sqrt(sum(((Y-FIT.A1*F1-FIT.A2*F2-FIT.B)/TrekSet.StdVal).^2)/FIT1.N);
    FIT2.FitIndStrict=FIT1.FitInd;
    FIT2.FitIndPulseStrict=[];
    FIT2.FitFast=0;
    FIT2.BGLineFit=[0,0];
    
    [TrekSet,TrekSet1]=TrekSDDSubtract(TrekSet,FIT1);
    [TrekSet1,TrekSet2]=TrekSDDSubtract(TrekSet1,FIT2);
    FitInd=TrekSDDGetFitIndDouble(TrekSet,TrekSet2);
    FitInd=union(FitInd,FitIndStart);
    if numel(FitIndStart)==numel(FitInd)&&numel(intersect(FitIndStart,FitInd))==numel(FitIndStart)
        ex=true;
    end;
end;
 

    
