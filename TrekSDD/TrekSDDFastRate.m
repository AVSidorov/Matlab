function TrekSDDFastRate(TrekSet,varargin)
NoiseTime=[68000,75000];
TrekSet=TrekSDDRecognize(TrekSet,varargin{:});
if TrekSet.type==0 
    return; 
end;
TrekSet=TrekLoad(TrekSet);
NoiseInd=[fix((NoiseTime(1)-TrekSet.StartTime)/TrekSet.tau):fix((NoiseTime(end)-TrekSet.StartTime)/TrekSet.tau)];
% NoiseSet=NoiseFitAuto(TrekSet.trek(NoiseInd));
NoiseSet.MeanVal=median(TrekSet.trek(NoiseInd));
NoiseSet.StdVal=std(TrekSet.trek(NoiseInd));
NoiseSet.Threshold=5*NoiseSet.StdVal;
TrekSet.trek=TrekSet.trek-NoiseSet.MeanVal;
TrekSet.MeanVal=0;
TrekSet.StdVal=NoiseSet.StdVal;
TrekSet.MaxSignal=TrekSet.MaxSignal-NoiseSet.MeanVal;
TrekSet.MinSignal=TrekSet.MinSignal-NoiseSet.MeanVal;
TrekSet.Threshold=ceil(NoiseSet.Threshold);
TrekSet.OverSt=3.5;
TrekSet=TrekSDDPeakSearchFilter(TrekSet,NoiseInd);
Hist=HistOnNet(TrekSet.SelectedPeakInd*TrekSet.tau+TrekSet.StartTime,[15000:300:55000]);
figure;
errorbar(Hist(:,1)/1000,Hist(:,2),Hist(:,3),'.r-','LineWidth',2);
grid on; hold on;
title(TrekSet.FileName);
