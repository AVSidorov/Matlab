function TrekSet=TrekSDDResetFind(TrekSet)

trek=TrekSet.trek;
trD=diff(TrekSet.trek);
ResetBool=trek(1:end-1)==TrekSet.MinSignal&trD~=0;
ResetBool(end+1)=false;
ResetInd=find(ResetBool);
MinMaxSet=SpecialTreks(trek);

[Ind,iMinMax,iReset]=intersect(MinMaxSet.MinInd,ResetInd);
ResetStartInd=MinMaxSet.MaxInd(iMinMax-1);
TrekSet.ResetInd=ResetInd;
TrekSet.ResetStartInd=ResetStartInd;
 
