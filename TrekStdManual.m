function TrekSet=TrekStdManual(TrekSetIn)
TrekSet=TrekSetIn;
 sm=10001;
 trek=TrekSet.trek-smooth(TrekSet.trek,sm);
NoiseSet=NoiseFit(trek);


trek=TrekSet.trek;
trek=trek-NoiseSet.MeanVal;
if numel(find(trek>NoiseSet.Threshold))>=numel(find(trek<-NoiseSet.Threshold))
    PeakPolarity = 1;
else
    PeakPolarity = -1;
end;
trek=PeakPolarity*trek;
MaxSignal=max([PeakPolarity*(TrekSet.MaxSignal-NoiseSet.MeanVal);PeakPolarity*(TrekSet.MinSignal-NoiseSet.MeanVal)]);
MinSignal=min([PeakPolarity*(TrekSet.MaxSignal-NoiseSet.MeanVal);PeakPolarity*(TrekSet.MinSignal-NoiseSet.MeanVal)]);

TrekSet.trek=trek;
TrekSet.MeanVal=TrekSet.MeanVal+NoiseSet.MeanVal;
TrekSet.Threshold=NoiseSet.Threshold;
TrekSet.MinSignal=MinSignal;
TrekSet.MaxSignal=MaxSignal;
TrekSet.StdVal=NoiseSet.StdVal;
TrekSet.OverSt=NoiseSet.OverSt;

