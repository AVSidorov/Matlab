function TrekSet = TrekSubtractByPeaks(TrekSet)

if ~isempty(TrekSet.STP)
   STP=TrekSet.STP;
else
   STP=StpStruct;
end;
MaxInd=STP.MaxInd;
tau=TrekSet.tau;

i=find(TrekSet.peaks(:,2)>=TrekSet.StartTime,1,'first');
I=find(TrekSet.peaks(:,2)<=TrekSet.StartTime+TrekSet.size*tau,1,'last');
TrekSet.Pulses=zeros(((I-i)+1)*STP.size,2);
stI=i;
while i<=size(TrekSet.peaks,1)&&TrekSet.peaks(i,2)<=TrekSet.StartTime+TrekSet.size*tau;
    Ind=round((TrekSet.peaks(i,2)-TrekSet.StartTime)/tau);
    Shift=round((TrekSet.peaks(i,2)-TrekSet.StartTime)/tau)-(TrekSet.peaks(i,2)-TrekSet.StartTime)/tau;
    FitPulse=TrekSDDGetFitPulse(STP,Shift);
    PulseN=numel(FitPulse);
    
    SubtractInd=[1:PulseN]+Ind-MaxInd;
    SubtractInd=SubtractInd(SubtractInd<=TrekSet.size&SubtractInd>=1);
    SubtractIndPulse=SubtractInd-Ind+MaxInd;

    PulseSubtract=FitPulse*TrekSet.peaks(i,5)+TrekSet.peaks(i,4);

                        
    OverloadInd=SubtractInd((TrekSet.trek(SubtractInd)>TrekSet.MaxSignal-TrekSet.StdVal)|(TrekSet.trek(SubtractInd)-PulseSubtract(SubtractIndPulse)<TrekSet.MinSignal+TrekSet.StdVal));
    OverloadIndPulse=OverloadInd-Ind+MaxInd;
    PulseSubtract(OverloadIndPulse)=0;


    CollectEndInd=find(abs(TrekSet.trek(SubtractInd)-PulseSubtract(SubtractIndPulse))>=TrekSet.StdVal*TrekSet.OverSt,1,'first')-1;
    if isempty(CollectEndInd)
        CollectEndInd=numel(SubtractInd);
    end
    CollectInd=SubtractInd(1:CollectEndInd);
    CollectIndPulse=SubtractIndPulse(1:CollectEndInd);
    TrekSet.Pulses(1+STP.size*(i-stI):CollectEndInd+STP.size*(i-stI),1)=CollectIndPulse+Shift;
    TrekSet.Pulses(1+STP.size*(i-stI):CollectEndInd+STP.size*(i-stI),2)=(TrekSet.trek(CollectInd)-TrekSet.peaks(i,4))/TrekSet.peaks(i,5);    
    TrekSet.trek(SubtractInd)=TrekSet.trek(SubtractInd)-PulseSubtract(SubtractIndPulse);
    i=i+1;
end

end

