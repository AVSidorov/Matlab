function TrekSet=TrekBreakPoints(TrekSetIn);
TrekSet=TrekSetIn;

MaxInd=find(TrekSet.StandardPulse==1); %Standard Pusle must be normalized by Amp
%[Max,MaxInd]=max(TrekSet.StandardPulse); other way
BckgFitInd=find(TrekSet.StandardPulse==0);%Standard Pulse must have several zero point at front end and las zero point
BckgFitInd(end)=[];
BckgFitN=size(BckgFitInd,1); 
FrontN=MaxInd-BckgFitN;
TailInd=find(TrekSet.StandardPulse<=0);
TailInd(TailInd<MaxInd)=[];
TailInd=TailInd(1);

SelectedPeakIndshR=circshift(TrekSet.SelectedPeakInd,1);
pointsBefore=TrekSet.SelectedPeakInd-SelectedPeakIndshR;

breakPeaksBool=pointsBefore>TailInd;
breakPeaksInd=TrekSet.SelectedPeakInd;
breakPeaksInd(not(breakPeaksBool))=[];

breakPointsInd=breakPeaksInd-MaxInd;
breakPointsInd(abs(TrekSet.trek(breakPointsInd))>TrekSet.StdVal)=[];

TrekSet.BreakPointsInd=breakPointsInd;
