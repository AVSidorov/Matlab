function TrekSet=TrekSDDPeakReSearch(TrekSetIn,FIT)
tic;
disp('>>>>>>>>TrekPeakReSearch started');


StpSet=TrekSetIn.STP;

if nargin<2
    SubtractInd=[1:TrekSetIn.size]';
else
    SubtractInd=[1:FIT.FitPulseN]+FIT.MaxInd-StpSet.MaxInd;
    SubtractInd=[SubtractInd(1)-StpSet.MaxInd:SubtractInd(end)]';
    SubtractInd=SubtractInd(SubtractInd<=TrekSetIn.size&SubtractInd>=1);
end;
TrekSetIn.SelectedPeakInd(TrekSetIn.SelectedPeakInd>=SubtractInd(1)&TrekSetIn.SelectedPeakInd<=SubtractInd(end))=[];
TrekSet=TrekSetIn;

if numel(SubtractInd)<StpSet.MaxInd||...
    range(TrekSet.trek(SubtractInd))<TrekSet.Threshold
    return;
end;


 
  
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
