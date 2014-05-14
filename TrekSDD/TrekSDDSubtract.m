function [TrekSet,TrekSet1]=TrekSDDSubtract(TrekSetIn,FitStruct)
TrekSet=TrekSetIn;
TrekSet1=TrekSet;    

%%







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
BGLine=polyval(FitStruct.BGLineFit,SubtractInd)';
                        
OverloadInd=SubtractInd((TrekSet.trek(SubtractInd)>=TrekSet.MaxSignal)|(TrekSet.trek(SubtractInd)-PulseSubtract(SubtractIndPulse)<=TrekSet.MinSignal));
OverloadIndPulse=OverloadInd-Ind+MaxInd;
PulseSubtract(OverloadIndPulse)=0;


TrekSet1.trek(SubtractInd)=TrekSet.trek(SubtractInd)-PulseSubtract(SubtractIndPulse);

TrekSet1.peaks=[TrekSet1.peaks;zeros(1,7)];

TrekSet1.peaks(end,1)=Ind;             %TrekSet.SelectedPeakInd Max initial
TrekSet1.peaks(end,2)=TrekSet1.StartTime+Ind*TrekSet1.tau-FitStruct.Shift*TrekSet1.tau;  %Peak Max Time fitted
TrekSet1.peaks(end,3)=TrekSet1.peaks(end,2);     % for peak-to-peak interval
TrekSet1.peaks(end,4)=FitStruct.B;                       %Peak Zero Level
TrekSet1.peaks(end,5)=FitStruct.A;                     %Peak Amplitude
TrekSet1.peaks(end,6)=FitStruct.Khi ;%MinKhi2;% /Ampl;% KhiMin
TrekSet1.peaks(end,7)=-1;                     % means that Standing Alone or first from Overlaped pulses



return;
%%
if TrekSet.Plot
    pp=figure;
        %set(gcf, 'Position', get(0,'Screensize')); % Maximize figure        
        grid on; hold on;
        plot(SubtractInd,TrekSetIn.trek(SubtractInd));
        plot(Ind,TrekSetIn.trek(Ind),'*r');
        plot(SubtractInd,PulseSubtract(SubtractIndPulse)+FitStruct.B+BGLine,'.r-');
        plot(FitInd,TrekSetIn.trek(FitInd),'ob');
        plot(SubtractInd,TrekSet1.trek(SubtractInd),'k');
        plot(SubtractInd,BGLine,'m');        
        plot(SubtractInd,BGLine+TrekSet.OverSt*TrekSet.StdVal+FitStruct.B,'g');
        plot(SubtractInd,BGLine-TrekSet.OverSt*TrekSet.StdVal+FitStruct.B,'g');
        set(gcf, 'Units', 'normalized', 'Position', [0.01, 0.01, 0.8, 0.8]);
    pause;
    figure(pp);
    close(gcf);
end;