function TrekSet=TrekSDDPeakReSearch(TrekSetIn,FIT)
tic;
disp('>>>>>>>>TrekPeakReSearch started');

TrekSet=TrekSetIn;

StpSet=TrekSet.STP;

if nargin<2
    SubtractInd=[1:TrekSet.size]';
else
    SubtractInd=[1:FIT.FitPulseN]+FIT.MaxInd-StpSet.MaxInd;
    SubtractInd=[SubtractInd(1)-StpSet.MaxInd:SubtractInd(end)]';
    SubtractInd=SubtractInd(SubtractInd<=TrekSet.size&SubtractInd>=1);
end;
if numel(SubtractInd)<StpSet.MaxInd||...
    range(TrekSet.trek(SubtractInd))<TrekSet.Threshold
    return;
end;


 TrekSetIn.SelectedPeakInd(TrekSet.SelectedPeakInd>=SubtractInd(1)&TrekSet.SelectedPeakInd<=SubtractInd(end))=[];
  
 TrekSet.Plot=false;
 TrekSet.trek=[TrekSet.trek(SubtractInd)];
 TrekSet.size=numel(TrekSet.trek);
 TrekSet.SelectedPeakInd=[];
 TrekSet=TrekSDDPeakSearch(TrekSet,false);

 TrekSet.SelectedPeakInd=TrekSet.SelectedPeakInd-1+SubtractInd(1);
 TrekSetIn.SelectedPeakInd=[TrekSetIn.SelectedPeakInd;TrekSet.SelectedPeakInd];
 TrekSetIn.SelectedPeakInd=sortrows(TrekSetIn.SelectedPeakInd);
 
TrekSet=TrekSetIn;

fprintf('TrekSDDPeakReSearch time %3.2f\n',toc);
