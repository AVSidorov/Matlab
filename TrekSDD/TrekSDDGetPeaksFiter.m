function TrekSDDGetPeaksFiter(TrekSet,varargin)
NoiseTime=[6000,12000];
TrekSet=TrekSDDRecognize(TrekSet,varargin{:});
if TrekSet.type==0 
    return; 
end;
TrekSet=TrekLoad(TrekSet);
NoiseInd=[fix((NoiseTime(1)-TrekSet.StartTime)/TrekSet.tau):fix((NoiseTime(end)-TrekSet.StartTime)/TrekSet.tau)];
NoiseSet=NoiseFitAuto(TrekSet.trek(NoiseInd));
TrekSet.trek=TrekSet.trek-NoiseSet.MeanVal;
TrekSet.MeanVal=0;
TrekSet.StdVal=NoiseSet.StdVal;
TrekSet.MaxSignal=TrekSet.MaxSignal-NoiseSet.MeanVal;
TrekSet.MinSignal=TrekSet.MinSignal-NoiseSet.MeanVal;
TrekSet.Threshold=ceil(NoiseSet.Threshold);
TrekSet.OverSt=3.5;
TrekSet=TrekSDDPeakSearchFilter(TrekSet,NoiseInd);
