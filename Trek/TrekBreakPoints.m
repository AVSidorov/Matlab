function TrekSet=TrekBreakPoints(TrekSetIn)
tic;
disp('>>>>>>>>TrekBreakPoints started');
TrekSet=TrekSetIn;
if isfield(TrekSet,'STP')&&~isempty(TrekSet.STP)
    STP=TrekSet.STP;
else
    StpStruct(TrekSet.StandardPulse);
end;

SelectedPeakIndshR=circshift(TrekSet.SelectedPeakInd,1);
pointsBefore=TrekSet.SelectedPeakInd-SelectedPeakIndshR;

breakPeaksBool=pointsBefore>STP.TailInd;
breakPeaksInd=TrekSet.SelectedPeakInd;
breakPeaksInd(not(breakPeaksBool))=[];

breakPointsInd=breakPeaksInd-STP.MaxInd-STP.BckgFitN;
breakPointsInd(abs(TrekSet.trek(breakPointsInd))>TrekSet.Threshold)=[];

TrekSet.BreakPointsInd=breakPointsInd;
toc;