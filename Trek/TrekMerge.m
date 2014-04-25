function TrekSet=TrekMerge(TrekSetIn);
%This function merges two treks written in differen ADC channels with
%different ranges. MainTrek must be in wider ADC range written
%Also calculates Min/MaxSignal
%TrekMerge must be called after making Positive Pulses and first zero
%subtraction in main trek.
TrekSet=TrekSetIn;
if TrekSet.Merged return; end;

MaxAmpV=2;    %Maximum amplifier signal
MaxAmpK=1; %This Koeff is necessary because MaxAmpV is saturation voltage. Deviations start earlier
ADC1ampV=2.5; 
ADC2ampV=2.5;

FileName=[TrekSet.name,'2.dat'];
TrekSet2=TrekRecognize(FileName,'StartOffset',TrekSet.StartOffset,'Date',TrekSet.Date,...
                       'Amp',TrekSet.Amp,'HV',TrekSet.HV,'P',TrekSet.P,'Plot',TrekSet.Plot);

if TrekSet2.type==0 
    disp('Second file is not found');
    TrekSet.MaxSignal=min([MaxAmpK*MaxAmpV*TrekSet.MaxSignal/ADC1ampV,TrekSet.MaxSignal]);
    TrekSet.Merged = true;
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
TrekSet2.StartTime=TrekSet.StartTime;
TrekSet2.size=TrekSet.size;

TrekSet2=TrekLoad(TrekSet2);
TrekSet2=TrekStdVal(TrekSet2);

TrekSet2.MaxSignal=min([MaxAmpK*MaxAmpV*4095/ADC2ampV,TrekSet2.MaxSignal]);


%% second channel zero correction
%second Signal is base - x xo=0. So x*ADC2ampV=(y-yo)*ADC1ampV
%second because range is smaller, accuracy higher
%yo=y-x*ADC2ampV/ADC1ampV 

%bool=TrekSet.trek*ADC1ampV/ADC1ampV<TrekSet2.MaxSignal;
Z=inf;
dZ=inf;
i=1;
while abs(dZ)>1e-3
    bool=TrekSet2.trek>TrekSet2.MinSignal&TrekSet2.trek<TrekSet2.MaxSignal&TrekSet.trek<TrekSet2.MaxSignal&TrekSet.trek>TrekSet.MinSignal;
    fit(i,:)=polyfit(TrekSet.trek(bool),TrekSet2.trek(bool),1);
    zero=fit(i,2);
    dZ=mean(zero)-Z;
    Z=mean(zero);
    TrekSet2.trek=TrekSet2.trek-Z;
     TrekSet2.MeanVal=TrekSet2.MeanVal-Z;
     TrekSet2.MaxSignal=TrekSet2.MaxSignal-Z;
     TrekSet2.MinSignal=TrekSet2.MinSignal-Z;
     i=i+1;
end;
%% merge treks
bool=TrekSet2.trek<TrekSet2.MaxSignal&TrekSet2.trek>TrekSet2.MinSignal;
%TrekSet.trek(bool)=TrekSet2.trek(bool)*ADC2ampV/ADC1ampV;
TrekSet.trek(bool)=TrekSet2.trek(bool)/fit(end,1);
fprintf('Treks is merged. Amp ratio is %4.2f\n',fit(end,1));
TrekSet.Merged=true;
TrekSet=TrekStdVal(TrekSet);