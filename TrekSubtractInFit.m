function [TrekSet,isGood]=TrekSubtractInFit(TrekSetIn,I,StpSet,FitStruct);
tic;
disp('>>>>>>>>TrekSubtract started');
TrekSet=TrekSetIn;
%%
STP=StpStruct(TrekSet.StandardPulse);

Plot=TrekSet.Plot;

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

SubtractIndPulse=SubtractIndPulse(SubtractIndPulse>=FitIndPulse(1));
SubtractInd=SubtractInd(SubtractInd>=FitInd(1));

trek(SubtractInd)=trek(SubtractInd)-PulseSubtract(SubtractIndPulse);

if all(abs(trek(FitStruct.FitInd))<TrekSet.Threshold)    %check fitting quality
   %check that FitPulse isn't moved right and fitted Pulse Amplitude much
   %greater than Amplitude of real signal pulse
   TrekSet.trek=trek;
   isGood=true;
%%
    TrekSet.peaks=[TrekSet.peaks;zeros(1,7)];

    TrekSet.peaks(end,1)=TrekSet.SelectedPeakInd(I);             %TrekSet.SelectedPeakInd Max initial
    TrekSet.peaks(end,2)=TrekSet.StartTime+TrekSet.SelectedPeakInd(I)*TrekSet.tau-FitStruct.Shift*TrekSet.tau;  %Peak Max Time fitted
    TrekSet.peaks(end,3)=TrekSet.peaks(end,2);     % for peak-to-peak interval
    TrekSet.peaks(end,4)=FitStruct.B;                       %Peak Zero Level
    TrekSet.peaks(end,5)=FitStruct.A;                     %Peak Amplitude
    TrekSet.peaks(end,6)=FitStruct.Khi ;%MinKhi2;% /Ampl;% KhiMin
    TrekSet.peaks(end,7)=-1;                     % means that this is not real pulse
%%    
    TrekSet=TrekPeakReSearch(TrekSet,SubtractInd);
%   Plot=true;
else
    isGood=false;
%     Plot=true;
end;
%%
toc;
%%
if Plot
    pp=figure;
        grid on; hold on;
        plot(SubtractInd,TrekSetIn.trek(SubtractInd));
        plot(TrekSetIn.SelectedPeakInd(I),TrekSetIn.trek(TrekSetIn.SelectedPeakInd(I)),'*r');
        plot(SubtractInd,PulseSubtract(SubtractIndPulse),'.r-');
        plot(FitInd,TrekSetIn.trek(FitInd),'ob');
        plot(SubtractInd,trek(SubtractInd),'k');
        plot(SubtractInd(SubtractIndPulse<=STP.TailInd),trek(SubtractInd(SubtractIndPulse<=STP.TailInd)),'ok');
    pause;
    figure(pp);
    close(gcf);
end;