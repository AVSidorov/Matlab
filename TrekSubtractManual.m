function [TrekSet,Subtracted]=TrekSubtractManual(TrekSet,TrekSet1,FIT)

if isfield(TrekSet,'STP')&&~isempty(TrekSet.STP)
    STP=TrekSet.STP;
else
    STP=StpStruct;
end;
Subtracted=false;
bool=TrekSet.trek~=TrekSet1.trek;
SubtractInd=find(bool);
if isempty(SubtractInd)
    Subtracted=true;
    return;
end;
SubtractIndPulse=SubtractInd-FIT.MaxInd+STP.MaxInd;
BadInd1=FIT.FitInd(abs(TrekSet1.trek(FIT.FitInd))>=TrekSet.Threshold);
Ind=SubtractInd(SubtractIndPulse<=STP.TailInd);
BadInd2=Ind(TrekSet1.trek(Ind)<=-TrekSet.Threshold);
ts=figure;
grid on; hold on;
plot(SubtractInd,TrekSet.trek(SubtractInd));
plot(SubtractInd,TrekSet1.trek(SubtractInd)),'k');
plot([1:FIT.FitPulseN]+FIT.MaxInd-STP.MaxInd,FIT.FitPulse*FIT.A+FIT.B,'r');
% axis([FIT.FitInd(1),STP.TailInd(end)+FIT.MaxInd-STP.MaxInd,...
%     min([min(TrekSet.trek(bool)),min(TrekSet1.trek(bool)),-TrekSet.Threshold]),...
%     max([max(TrekSet.trek(bool)),max(TrekSet1.trek(bool))])]);
plot(BadInd1,TrekSet1.trek(BadInd1),'.r');
plot(BadInd2,TrekSet1.trek(BadInd2),'+r');
plot([FIT.FitInd(1),SubtractInd(end)],[TrekSet.Threshold,TrekSet.Threshold],'g');
plot([FIT.FitInd(1),SubtractInd(end)],[-TrekSet.Threshold,-TrekSet.Threshold],'g');
s=input('Subtract? If input is not empty, then black trek,else Default blue line \n','s');
if not(isempty(s))
    Subtracted=true;
    TrekSet=TrekSet1;
    TrekSet.peaks(end,7)=0;
end;
if not(isempty(ts))
    close(ts);
end;
