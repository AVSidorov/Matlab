function TrekSet=TrekSDDPeakReSearch(TrekSetIn,FIT)
tic;
disp('>>>>>>>>TrekPeakReSearch started');

TrekSet=TrekSetIn;

StpSet=TrekSet.STP;

if nargin<2
    SubtractInd=[1:TrekSet.size]';
else
    SubtractInd=[1:FIT.FitPulseN]+FIT.MaxInd-StpSet.MaxInd;
    SubtractInd=SubtractInd(SubtractInd<=TrekSet.size&SubtractInd>=1);
end;
if numel(SubtractInd)<StpSet.MaxInd||...
    range(TrekSet.trek(SubtractInd))<TrekSet.Threshold
    return;
end;


  TrekSetIn.SelectedPeakFrontN(TrekSet.SelectedPeakInd>=SubtractInd(1)&TrekSet.SelectedPeakInd<=SubtractInd(end))=[];
  TrekSetIn.SelectedPeakInd(TrekSet.SelectedPeakInd>=SubtractInd(1)&TrekSet.SelectedPeakInd<=SubtractInd(end))=[];
  TrekSetIn.PeakOnFrontInd(TrekSet.PeakOnFrontInd>=SubtractInd(1)&TrekSet.PeakOnFrontInd<=SubtractInd(end))=[];
  TrekSetIn.LongFrontInd(TrekSet.LongFrontInd>=SubtractInd(1)&TrekSet.LongFrontInd<=SubtractInd(end))=[]; 

 TrekSet.Plot=false;
 TrekSet.trek=[TrekSet.StdVal;-TrekSet.StdVal;0;TrekSet.trek(SubtractInd)];
 %first 3 points is necessary for making
 %minimum before pulse 
 TrekSet.size=numel(TrekSet.trek);
 TrekSet.SelectedPeakInd=[];
 TrekSet.SelectedPeakFrontN=[];
 TrekSet.PeakOnFrontInd=[];
 TrekSet.LongFrontInd=[];
 TrekSet=TrekSDDPeakSearch(TrekSet,false);

 TrekSet.SelectedPeakInd=TrekSet.SelectedPeakInd-1+SubtractInd(1)-3; %3 because 3 points was added
 TrekSet.PeakOnFrontInd=TrekSet.PeakOnFrontInd-1+SubtractInd(1)-3;
 TrekSet.LongFrontInd=TrekSet.LongFrontInd-1+SubtractInd(1)-3;

 for IndI=1:numel(TrekSet.SelectedPeakInd)
     if isempty(find(TrekSet.SelectedPeakInd(IndI)==TrekSetIn.SelectedPeakInd(:)))
         TrekSetIn.SelectedPeakInd(end+1)=TrekSet.SelectedPeakInd(IndI);
         TrekSetIn.SelectedPeakFrontN(end+1)=TrekSet.SelectedPeakFrontN(IndI);                                    
         [TrekSetIn.SelectedPeakInd,index]=sortrows(TrekSetIn.SelectedPeakInd);
         TrekSetIn.SelectedPeakFrontN=TrekSetIn.SelectedPeakFrontN(index,:);
     end;
 end;

 for IndI=1:numel(TrekSet.PeakOnFrontInd)
     if isempty(find(TrekSet.PeakOnFrontInd(IndI)==TrekSetIn.PeakOnFrontInd(:)))
         TrekSetIn.PeakOnFrontInd(end+1)=TrekSet.PeakOnFrontInd(IndI);
         TrekSetIn.PeakOnFrontInd=sortrows(TrekSetIn.PeakOnFrontInd);
     end;
 end;


 for IndI=1:numel(TrekSet.LongFrontInd)
   if isempty(find(TrekSet.LongFrontInd(IndI)==TrekSetIn.LongFrontInd(:)))
         TrekSetIn.LongFrontInd(end+1)=TrekSet.LongFrontInd(IndI);
         TrekSetIn.LongFrontInd=sortrows(TrekSetIn.LongFrontInd);
     end;
 end;


TrekSet=TrekSetIn;

toc;
