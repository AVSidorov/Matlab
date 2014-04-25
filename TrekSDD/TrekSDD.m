function TrekSet=TrekSDD(TrekSetIn,varargin)
TrekSet=TrekSetIn;
tic;
fprintf('>>>>>>>>>>>>>>>>>>>>> TrekSDD started\n');




%% Checking for existing and initialization
TrekSet=TrekSDDRecognize(TrekSet,varargin{:});
if TrekSet.type==0 
    return; 
end;
TrekSet.Plot=false;
TrekSet=TrekSDDMerge(TrekSet,varargin{:});

%Loading Standard Pulse
TrekSet=TrekSDDSTPLoad(TrekSet);
switch TrekSet.Amp
    case 9
        TrekSet.Threshold=160;
        TrekSet.ThresholdLD=205;
        TrekSet.StdVal=37;
    case 6 
        TrekSet.Threshold=115;
        TrekSet.ThresholdLD=140;
        TrekSet.StdVal=28;
    case 4
        TrekSet.Threshold=90;
        TrekSet.ThresholdLD=113;
        TrekSet.StdVal=21.3;        
end;

WorkSize=pow2(21); 
   for i=1:fix(TrekSet.size/WorkSize)
     TrekSet1=TrekPickTime(TrekSet,TrekSet.StartTime+(i-1)*WorkSize*TrekSet.tau,WorkSize*TrekSet.tau);
     if isstruct(TrekSetIn)
        TrekSet1.Plot=TrekSetIn.Plot;
     end;
     if isempty(TrekSet1.StdVal)||TrekSet1.StdVal<=0
         NoiseSet=NoiseFit(TrekSet1.trek);
         TrekSet.StdVal=NoiseSet.StdVal;
         TrekSet.OverSt=NoiseSet.OverSt;
         TrekSet.MeanVal=NoiseSet.MeanVal;
         TrekSet.Threshold=NoiseSet.Threshold;
         TrekSet.trek=TrekSet.PeakPolarity*(TrekSet.trek-TrekSet.MeanVal);
         TrekSet.MaxSignal=TrekSet.MaxSignal-TrekSet.MeanVal;   
         TrekSet.MinSignal=TrekSet.MinSignal-TrekSet.MeanVal;   
         if TrekSet.PeakPolarity<0
             TrekSet.MaxSignal=TrekSet.MaxSignal+TrekSet.MinSignal;
             TrekSet.MinSignal=TrekSet.MaxSignal-TrekSet.MinSignal;
             TrekSet.MaxSignal=TrekSet.MaxSignal-TrekSet.MinSignal;
             TrekSet.MaxSignal=TrekSet.PeakPolarity*TrekSet.MaxSignal;
             TrekSet.MinSignal=TrekSet.PeakPolarity*TrekSet.MinSignal;
         end;
         TrekSet1.StdVal=NoiseSet.StdVal;
         TrekSet1.OverSt=NoiseSet.OverSt;
         TrekSet1.MeanVal=NoiseSet.MeanVal;
         TrekSet1.Threshold=NoiseSet.Threshold;
         TrekSet1.trek=TrekSet1.PeakPolarity*(TrekSet1.trek-TrekSet1.MeanVal);
         longD=TrekSet1.trek-circshift(TrekSet1.trek,TrekSet1.STP.MaxInd);
         NoiseSet=NoiseFit(longD);
         TrekSet.ThresholdLD=NoiseSet.Threshold;
         TrekSet1.ThresholdLD=NoiseSet.Threshold;
         TrekSet1.MaxSignal=TrekSet.MaxSignal;
         TrekSet1.MinSignal=TrekSet.MinSignal;
     end;
     TrekSet1=TrekSDDGetPeaks(TrekSet1,1);
     TrekSet.trek(1+WorkSize*(i-1):TrekSet1.size+WorkSize*(i-1))=TrekSet1.trek;
     TrekSet.peaks=TrekSet1.peaks;
     assignin('base','T',TrekSet);
  end;
return;
