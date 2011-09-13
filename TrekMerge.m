function TrekSet=TrekMerge(TrekSetIn);
TrekSet=TrekSetIn;
if TrekSet.Merged return; end;
%This function merges two treks written in differen ADC channels with
%different ranges. MainTrek must be in wider ADC range written
%Also calculates Min/MaxSignal
%TrekMerge must be called after making Positive Pulses and firs zero
%subtraction in main trek.
MaxAmpV=2;    %Maximum amplifier signal
MaxAmpK=0.85; %This Koeff is necessary because MaxAmpV is saturation voltage. Deviations start earlier
ADC1ampV=2.5; 
ADC2ampV=2.5;

TrekSet2=TrekSet;
FileName=[TrekSet.name,'2.dat'];
TrekSet2=TrekRecognize(FileName,TrekSet2);

if TrekSet2.type==0 
    disp('Second file is not found');
    TrekSet.MaxSignal=min([MaxAmpK*MaxAmpV*TrekSet.MaxSignal/ADC1ampV,TrekSet.MaxSignal]);
    return;
end;

MaxAmpV=1; %because signal is devided and we measure at every channel only signal half
ADC1ampV=1.25;
ADC2ampV=0.3125;    

TrekSet.MaxSignal=min([MaxAmpK*MaxAmpV*4095/ADC1ampV,TrekSet.MaxSignal]);


TrekSet2.Threshold=TrekSet.Threshold*ADC1ampV/ADC2ampV;
TrekSet2.PeakPolarity=-1;
TrekSet2.MaxSignal=4095;
TrekSet2.MinSignal=0;
TrekSet2.StdVal=0;
TrekSet2.MeanVal=[];
TrekSet2.size=TrekSet.size;

TrekSet2=TrekLoad(FileName,TrekSet2);
TrekSet2=TrekStdVal(TrekSet2);

TrekSet2.MaxSignal=min([MaxAmpK*MaxAmpV*4095/ADC2ampV,TrekSet2.MaxSignal]);


%% second channel zero correction
%second Signal is base - x xo=0. So x*ADC2ampV=(y-yo)*ADC1ampV
%second because range is smaller, accuracy higher
%yo=y-x*ADC2ampV/ADC1ampV 

%bool=TrekSet.trek*ADC1ampV/ADC1ampV<TrekSet2.MaxSignal;
Z=inf;
dZ=inf;
while abs(dZ)>1e-3
    bool=TrekSet2.trek<TrekSet2.MaxSignal&TrekSet.trek*ADC1ampV/ADC2ampV<TrekSet2.MaxSignal;
    zero=(TrekSet.trek(bool)-TrekSet2.trek(bool)*ADC2ampV/ADC1ampV);
    dZ=mean(zero)-Z;
    Z=mean(zero);
    TrekSet.trek=TrekSet.trek-Z;
%     TrekSet.MeanVal=TrekSet.MeanVal-Z;
%     TrekSet.MaxSignal=TrekSet.MaxSignal-Z;
%     TrekSet.MinSignal=TrekSet.MinSignal-Z
end;
%% merge treks
bool=TrekSet2.trek<TrekSet2.MaxSignal&TrekSet2.trek>TrekSet2.MinSignal;
TrekSet.trek(bool)=TrekSet2.trek(bool)*ADC2ampV/ADC1ampV;
TrekSet.Merged=true;