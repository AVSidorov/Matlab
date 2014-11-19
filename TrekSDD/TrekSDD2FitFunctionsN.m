function FIT=TrekSDD2FitFunctionsN(TrekSet,FIT)
fprintf('Time fiting started. Ind is %6d\n',FIT.MaxInd);
% This function is gate between TrekSDD proccesing functions and Fit..
% functions

FitIndPulse=[1:TrekSet.STP.size]';
trek=TrekSet.trek;

MaxIndStp=TrekSet.STP.MaxInd;
MaxInd=FIT.MaxInd;
FitInd=FIT.FitInd;

ex=false;
while ~ex

    FitIndStart=FitInd;
    
    opt=optimset('TolX',1/20,'TolFun',1/100);
    sh=fminsearch(@(sh)FitMoved(trek,TrekSet.STP,FitInd,FitIndPulse,MaxInd,MaxIndStp,sh,@TrekSDD2FitShift,@FitABN),FIT.Shift,opt);
    [khi,FIT]=FitMoved(trek,TrekSet.STP,FitInd,FitIndPulse,MaxInd,MaxIndStp,sh,@TrekSDD2FitShift,@FitABN);
    [TrekSet,TrekSet1]=TrekSDDSubtractN(TrekSet,FIT);
    FitInd=TrekSDDGetFitIndDouble(TrekSet,TrekSet1);
    FitInd=union(FitInd,FitIndStart);
    if numel(FitIndStart)==numel(FitInd)&&numel(intersect(FitIndStart,FitInd))==numel(FitIndStart)
        ex=true;
    end;
end;

FIT.Khi=sum(((FIT.Y-FIT.Yfit)/TrekSet.StdVal).^2)/FIT.N;
FIT.FitFast=false;
FIT.FitIndStrict=FIT.FitInd;
FIT.FitFast=0;
FIT.BGLineFit=[0,0];

    
