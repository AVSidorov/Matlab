function [TrekSet,isGood,TrekSet1]=TrekSubtract(TrekSetIn,StpSet,FitStruct);
tic;
disp('>>>>>>>>TrekSubtract started');
TrekSet=TrekSetIn;
TrekSet1=TrekSet;    

%%



if not(FitStruct.Good)
    isGood=false;
end;

PulseN=FitStruct.FitPulseN;
MaxInd=StpSet.MaxInd;
FitInd=FitStruct.FitInd;
FitIndPulse=FitStruct.FitIndPulse;
Ind=FitStruct.MaxInd;


SubtractInd=[1:PulseN]+Ind-MaxInd;
SubtractInd=SubtractInd(SubtractInd<=TrekSet.size&SubtractInd>=1);
SubtractIndPulse=SubtractInd-Ind+MaxInd;

PulseSubtract=FitStruct.FitPulse;

                        
OverloadInd=SubtractInd(TrekSet.trek(SubtractInd)>TrekSet.MaxSignal);
OverloadIndPulse=OverloadInd-Ind+MaxInd;
PulseSubtract(OverloadIndPulse)=TrekSet.trek(OverloadInd);


TrekSet.trek(SubtractInd)=TrekSet.trek(SubtractInd)-PulseSubtract(SubtractIndPulse);

TrekSet.peaks=[TrekSet1.peaks;zeros(1,7)];

TrekSet.peaks(end,1)=Ind;             %TrekSet.SelectedPeakInd Max initial
TrekSet.peaks(end,2)=TrekSet.StartTime+Ind*TrekSet.tau-FitStruct.Shift*TrekSet.tau;  %Peak Max Time fitted
TrekSet.peaks(end,3)=TrekSet.peaks(end,2);     % for peak-to-peak interval
TrekSet.peaks(end,4)=FitStruct.B;                       %Peak Zero Level
TrekSet.peaks(end,5)=FitStruct.A;                     %Peak Amplitude
TrekSet.peaks(end,6)=FitStruct.Khi ;%MinKhi2;% /Ampl;% KhiMin
TrekSet.peaks(end,7)=-1;                     % means that Standing Alone or first from Overlaped pulses

if all(abs(TrekSet.trek(FitStruct.FitInd(FitStruct.FitIndPulse>StpSet.BckgFitN)))<TrekSet.Threshold)&...    %check fitting quality
   all(TrekSet.trek(SubtractInd(SubtractIndPulse<=StpSet.TailInd))>-TrekSet.Threshold)&...
   FitStruct.A>0
   %check that FitPulse isn't moved right and fitted Pulse Amplitude much
   %greater than Amplitude of real signal pulse
    isGood=true;
    TrekSet.peaks(end,7)=0;
    TrekSet1=TrekSet;
%%
%%    
%   Plot=true;
else
    isGood=false;
    TrekSet1=TrekSet;    
    TrekSet=TrekSetIn;
%     Plot=true;
end;
%%
toc;
%%
if TrekSet.Plot
    pp=figure;
        grid on; hold on;
        plot(SubtractInd,TrekSetIn.trek(SubtractInd));
        plot(Ind,TrekSetIn.trek(Ind),'*r');
        plot(SubtractInd,PulseSubtract(SubtractIndPulse),'.r-');
        plot(FitInd,TrekSetIn.trek(FitInd),'ob');
        plot(SubtractInd,TrekSet1.trek(SubtractInd),'k');
        plot(SubtractInd(SubtractIndPulse<=StpSet.TailInd),TrekSet1.trek(SubtractInd(SubtractIndPulse<=StpSet.TailInd)),'ok');
    pause;
    figure(pp);
    close(gcf);
end;