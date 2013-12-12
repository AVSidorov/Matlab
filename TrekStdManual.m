function TrekSet=TrekStdManual(TrekSetIn)
TrekSet=TrekSetIn;
 sm=10001;
 trek=TrekSet.trek-smooth(TrekSet.trek,sm);
NoiseSet=NoiseFit(trek);


trek=TrekSet.trek;
MeanVal=mean(trek(NoiseSet.Ind));
trek=trek-MeanVal;
if numel(find(trek>NoiseSet.Threshold))>=numel(find(trek<-NoiseSet.Threshold))
    PeakPolarity = 1;
else
    PeakPolarity = -1;
end;
trek=PeakPolarity*trek;
MaxSignal=max([PeakPolarity*(TrekSet.MaxSignal-MeanVal);PeakPolarity*(TrekSet.MinSignal-MeanVal)]);
MinSignal=min([PeakPolarity*(TrekSet.MaxSignal-MeanVal);PeakPolarity*(TrekSet.MinSignal-MeanVal)]);

TrekSet.trek=trek;
TrekSet.MeanVal=MeanVal;
TrekSet.Threshold=NoiseSet.Threshold;
TrekSet.MinSignal=MinSignal;
TrekSet.MaxSignal=MaxSignal;
TrekSet.StdVal=NoiseSet.StdVal;
TrekSet.OverSt=NoiseSet.OverSt;

