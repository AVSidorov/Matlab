function TrekSet=TrekSDDClearReset(TrekSet)
if ~isfield(TrekSet,'ResetInd')||isempty(TrekSet.ResetInd)
    TrekSet=TrekSDDResetFind(TrekSet);
end;
for i=1:numel(TrekSet.ResetInd);
%     MaxInd=mean([TrekSet.ResetStartInd(i);TrekSet.ResetInd(i)]);
    MaxInd=TrekSet.ResetStartInd(i);
    [khi,FIT]=FitMoved(TrekSet.trek,TrekSet.STP.Stp,[TrekSet.ResetInd(i)+1:TrekSet.ResetInd(i)+4500],[1:TrekSet.STP.size],MaxInd,TrekSet.STP.MaxInd,0,@FitShift,@FitAB);
    sh=fminbnd(@(sh)FitMoved(TrekSet.trek,TrekSet.STP,[TrekSet.ResetInd(i)+1:TrekSet.ResetInd(i)+4500],[1:TrekSet.STP.size],MaxInd,TrekSet.STP.MaxInd,sh,@TrekSDD2FitShift,@FitAB),FIT.MaxShiftL,FIT.MaxShiftR);
    [khi,FIT]=FitMoved(TrekSet.trek,TrekSet.STP,[TrekSet.ResetInd(i)+1:TrekSet.ResetInd(i)+4500],[1:TrekSet.STP.size],MaxInd,TrekSet.STP.MaxInd,sh,@TrekSDD2FitShift,@FitAB);
    FITs(i)=FIT;
end;
A=mean(FITs(:).A);
