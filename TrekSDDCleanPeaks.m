function TrekSet=TrekSDDCleanPeaks(TrekSet)
nl=TrekNullLineRunAvrFit(TrekSet);
Ind=round((TrekSet.peaks(:,2)-TrekSet.StartTime)/TrekSet.tau);
bool=abs(nl(Ind)-TrekSet.peaks(:,4))<=TrekSet.Threshold;
TrekSet.peaks=TrekSet.peaks(bool,:);