function [TrekSet,Subtracted]=TrekSubtractManual(TrekSet,TrekSet1,FIT)

if isfield(TrekSet,'STP')&&~isempty(TrekSet.STP)
    STP=TrekSet.STP;
else
    STP=StpStruct;
end;
Subtracted=false;
bool=TrekSet.trek~=TrekSet1.trek;

SubtractInd=find(bool);
SubtractInd=[SubtractInd(1):SubtractInd(end)];

if isempty(SubtractInd)
    Subtracted=true;
    return;
end;
SubtractIndPulse=SubtractInd-FIT.MaxInd+STP.MaxInd;

x=SubtractInd(1)-STP.size:SubtractInd(end)+STP.size;
x(x<1|x>TrekSet.size)=[];
% Xbool=false(size(TrekSet.trek));
% Xbool(x)=true;
% SelectedBool=false(size(TrekSet.trek));
% SelectedBool(TrekSet.SelectedPeakInd)=true;
% SelectedInds=find(SelectedBool&Xbool);



BadInd1=FIT.FitInd(abs(TrekSet1.trek(FIT.FitInd(FIT.FitIndPulse>STP.BckgFitN))-FIT.B)>=TrekSet.Threshold);
Ind=SubtractInd(SubtractIndPulse<=STP.TailInd);
BadInd2=Ind(TrekSet1.trek(Ind)-FIT.B<=-TrekSet.Threshold);




ts=figure;
grid on; hold on;
plot(x,TrekSet.trek(x));
plot(x,TrekSet1.trek(x),'k');
plot([1:FIT.FitPulseN]+FIT.MaxInd-STP.MaxInd,FIT.FitPulse*FIT.A+FIT.B,'r');
% axis([FIT.FitInd(1),STP.TailInd(end)+FIT.MaxInd-STP.MaxInd,...
%     min([min(TrekSet.trek(bool)),min(TrekSet1.trek(bool)),-TrekSet.Threshold]),...
%     max([max(TrekSet.trek(bool)),max(TrekSet1.trek(bool))])]);
plot(BadInd1,TrekSet1.trek(BadInd1),'.r');
plot(BadInd2,TrekSet1.trek(BadInd2),'+r');
plot([x(1),x(end)],FIT.B+[TrekSet.Threshold,TrekSet.Threshold],'g');
plot([x(1),x(end)],FIT.B+[-TrekSet.Threshold,-TrekSet.Threshold],'g');
s=input('Subtract? If input is not empty, then black trek,else Default blue line\n If leter is ''d/D'' then this pulse will be marked as good fitted\n','s');
if not(isempty(s))
    Subtracted=true;
    TrekSet=TrekSet1;
    if lower(s)=='d'
      TrekSet.peaks(end,7)=0;
    end;
end;
if not(isempty(ts))&&ishandle(ts)
    close(ts);
end;
