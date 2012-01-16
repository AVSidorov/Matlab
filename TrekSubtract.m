function [TrekSet,isGood]=TrekSubtract(TrekSetIn,I,StpSet,FitStruct);

TrekSet=TrekSetIn;
STP=StpStruct(TrekSet.StandardPulse);

Plot=true;

if nargin<3
    StpSet=STP;
end;
if nargin<4
    FitStruct=TrekFitFast(TrekSet,I,StpSet);
end;


PulseN=FitStruct.FitPulseN;
MaxInd=StpSet.MaxInd;
FitInd=FitStruct.FitInd;
FitIndPulse=FitStruct.FitIndPulse;

trek=TrekSet.trek;

SubtractInd=[1:PulseN]+TrekSet.SelectedPeakInd(I)-MaxInd;
SubtractInd=SubtractInd(SubtractInd<=TrekSet.size&SubtractInd>=1);
SubtractIndPulse=SubtractInd-TrekSet.SelectedPeakInd(I)+MaxInd;

PulseSubtract=FitStruct.FitPulse;

                        
OverloadInd=SubtractInd(trek(SubtractInd)>TrekSet.MaxSignal);
OverloadIndPulse=OverloadInd-TrekSet.SelectedPeakInd(I)+MaxInd;
PulseSubtract(OverloadIndPulse)=trek(OverloadInd);


trek(SubtractInd)=trek(SubtractInd)-PulseSubtract(SubtractIndPulse);

if all(abs(trek(FitStruct.FitInd))<TrekSet.Threshold)&...    %check fitting quality
   all(trek(SubtractInd(SubtractIndPulse<=STP.TailInd))>-TrekSet.Threshold)
   %check that FitPulse isn't moved right and fitted Pulse Amplitude much
   %greater than Amplitude of real signal pulse
    isGood=true;
    TrekSet.trek=trek;
    Plot=true;

else
    isGood=false;
    Plot=true;
end;

if Plot
    pp=figure;
        grid on; hold on;
        plot(SubtractInd,TrekSetIn.trek(SubtractInd));
        plot(TrekSet.SelectedPeakInd(I),TrekSetIn.trek(TrekSet.SelectedPeakInd(I)),'*r');
        plot(SubtractInd,PulseSubtract(SubtractIndPulse),'.r-');
        plot(FitInd,TrekSetIn.trek(FitInd),'ob');
        plot(SubtractInd,trek(SubtractInd),'k');
        plot(SubtractInd(SubtractIndPulse<=STP.TailInd),trek(SubtractInd(SubtractIndPulse<=STP.TailInd)),'ok');
    pause;
    figure(pp);
    close(gcf);
end;