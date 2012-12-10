function [TrekSet,isGood,TrekSet1]=TrekSubtract(TrekSetIn,FitStruct)
tic;
disp('>>>>>>>>TrekSubtract started');
TrekSet=TrekSetIn;
TrekSet1=TrekSet;    

%%



if not(FitStruct.Good)
    isGood=false;
end;

if ~isempty(TrekSet.STP)
   StpSet=TrekSet.STP;
else
   StpSet=StpStruct;
end;

PulseN=FitStruct.FitPulseN;
MaxInd=StpSet.MaxInd;
FitInd=FitStruct.FitInd;
FitIndPulse=FitStruct.FitIndPulse;
Ind=FitStruct.MaxInd;



SubtractInd=[1:PulseN]+Ind-MaxInd;
SubtractInd=SubtractInd(SubtractInd<=TrekSet.size&SubtractInd>=1);
SubtractIndPulse=SubtractInd-Ind+MaxInd;

PulseSubtract=FitStruct.FitPulse*FitStruct.A;

                        
OverloadInd=SubtractInd((TrekSet.trek(SubtractInd)>TrekSet.MaxSignal-TrekSet.StdVal)|(TrekSet.trek(SubtractInd)-PulseSubtract(SubtractIndPulse)<TrekSet.MinSignal+TrekSet.StdVal));
OverloadIndPulse=OverloadInd-Ind+MaxInd;
PulseSubtract(OverloadIndPulse)=0;


TrekSet.trek(SubtractInd)=TrekSet.trek(SubtractInd)-PulseSubtract(SubtractIndPulse);

TrekSet.peaks=[TrekSet1.peaks;zeros(1,7)];

TrekSet.peaks(end,1)=Ind;             %TrekSet.SelectedPeakInd Max initial
TrekSet.peaks(end,2)=TrekSet.StartTime+Ind*TrekSet.tau-FitStruct.Shift*TrekSet.tau;  %Peak Max Time fitted
TrekSet.peaks(end,3)=TrekSet.peaks(end,2);     % for peak-to-peak interval
TrekSet.peaks(end,4)=FitStruct.B;                       %Peak Zero Level
TrekSet.peaks(end,5)=FitStruct.A;                     %Peak Amplitude
TrekSet.peaks(end,6)=FitStruct.Khi ;%MinKhi2;% /Ampl;% KhiMin
TrekSet.peaks(end,7)=-1;                     % means that Standing Alone or first from Overlaped pulses

if all(abs(TrekSet.trek(FitInd(FitIndPulse>StpSet.BckgFitN))-FitStruct.B)<TrekSet.Threshold)&...    %check fitting quality
   all(TrekSet.trek(SubtractInd(SubtractIndPulse<=StpSet.TailInd))-FitStruct.B>-TrekSet.Threshold)&...
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
        %set(gcf, 'Position', get(0,'Screensize')); % Maximize figure        
         if isGood 
            title('Good');
        else
            title('bad');
        end;
        grid on; hold on;
        plot(SubtractInd,TrekSetIn.trek(SubtractInd));
        plot(Ind,TrekSetIn.trek(Ind),'*r');
        plot(SubtractInd,PulseSubtract(SubtractIndPulse)+FitStruct.B,'.r-');
        plot(FitInd,TrekSetIn.trek(FitInd),'ob');
        plot(SubtractInd,TrekSet1.trek(SubtractInd),'k');
        plot(SubtractInd(SubtractIndPulse<=StpSet.TailInd),TrekSet1.trek(SubtractInd(SubtractIndPulse<=StpSet.TailInd)),'ok');
        plot([SubtractInd(1),SubtractInd(end)],[TrekSet.Threshold,TrekSet.Threshold],'g');
        plot([SubtractInd(1),SubtractInd(end)],[-TrekSet.Threshold,-TrekSet.Threshold],'g');
        set(gcf, 'Units', 'normalized', 'Position', [0.01, 0.01, 0.8, 0.8]);
    pause;
    figure(pp);
    close(gcf);
end;