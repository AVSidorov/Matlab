function TrekSet=TrekSDDMakeTrek(TrekSet,Pulses)
% This function makes trek whith pulses from TrekSet.peaks array.
% The noise signal is taken from TrekSet.trek. If TrekSet.trek is empty
% then generates normal noise whith pararmeters taken from TrekSet.StdVal
% and TrekSet.MeanVal

if isempty(TrekSet.trek)
    if isempty(TrekSet.size)||TrekSet.size==0
        TrekSet.size=round((max(TrekSet.peaks(:,2))-TrekSet.StartTime)/TrekSet.tau)+TrekSet.STP.size;
    end;
    TrekSet.trek=TrekSet.MeanVal+TrekSet.StdVal*randn(TrekSet.size,1);
end;

% search all peaks that have parts in trek times
% so we start with peak times before TrekSet.StartTime and end with times
% after end of trek

if  isfield(TrekSet,'peaks')&&~isempty(TrekSet.peaks)&&size(TrekSet.peaks,1)>0&&size(TrekSet.peaks,2)>=5
    PeakInds=find(TrekSet.peaks(:,2)>=TrekSet.StartTime-TrekSet.STP.size/TrekSet.tau&TrekSet.peaks(:,2)<=TrekSet.StartTime+TrekSet.size*TrekSet.tau+TrekSet.STP.FrontN*TrekSet.tau); 
    MaxInd=TrekSet.STP.MaxInd;

    for ii=1:numel(PeakInds)
        i=PeakInds(ii);
        Ind=round((TrekSet.peaks(i,2)-TrekSet.StartTime)/TrekSet.tau);
        Shift=Ind-(TrekSet.peaks(i,2)-TrekSet.StartTime)/TrekSet.tau;
        if nargin<2        
            FitPulse=TrekSDDGetFitPulse(TrekSet.STP,Shift);
        else
            n=mod(i,size(Pulses,2))+1;
            FitPulse=interp1([1:size(Pulses,1)]',Pulses(:,n),[1:size(Pulses,1)]'+Shift,'PCHIP',0);
        end;

        PulseN=numel(FitPulse);

        SubtractInd=[1:PulseN]+Ind-MaxInd;
        SubtractInd=SubtractInd(SubtractInd<=TrekSet.size&SubtractInd>=1);
        SubtractIndPulse=SubtractInd-Ind+MaxInd;

    %     PulseSubtract=FitPulse*TrekSet.peaks(i,5)+TrekSet.peaks(i,4);
        PulseSubtract=FitPulse*TrekSet.peaks(i,5);


        OverloadInd=SubtractInd(TrekSet.trek(SubtractInd)+PulseSubtract(SubtractIndPulse)>=TrekSet.MaxSignal);
        UnderLoadInd=SubtractInd(TrekSet.trek(SubtractInd)+PulseSubtract(SubtractIndPulse)<=TrekSet.MinSignal);
        OverloadIndPulse=OverloadInd-Ind+MaxInd;
        PulseSubtract(OverloadIndPulse)=0;
        TrekSet.trek(SubtractInd)=TrekSet.trek(SubtractInd)+PulseSubtract(SubtractIndPulse);
        TrekSet.trek(OverloadInd)=TrekSet.MaxSignal;
        TrekSet.trek(UnderLoadInd)=TrekSet.MinSignal;
    end;
end;    
    