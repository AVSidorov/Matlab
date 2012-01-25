function TrekSet=TrekBreakPoints(TrekSetIn,STP);
tic;
disp('>>>>>>>>TrekBreakPoints started');
TrekSet=TrekSetIn;
if nargin<2
    STP=StpStruct(TrekSet.StandardPulse);
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