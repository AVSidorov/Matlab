function TrekSet=TrekPeakSearch(TrekSetIn);

TrekSet=TrekSetIn;
tic;
disp('>>>>>>>>Search by Front started');


BckgFitN=2;
OnTailBorder=0.1;
Plot=TrekSet.Plot;
% SmoothPar=5;


[StPMax,StPMaxInd]=max(TrekSet.StandardPulse);
FirstNonZero=find(TrekSet.StandardPulse,1,'first');
LastNonZero=find(TrekSet.StandardPulse,1,'last');
MaxFrontN=StPMaxInd-FirstNonZero+1;
MaxTailN=LastNonZero-StPMaxInd+1;
%Determination of length in points where peak may be hiden by previous pulse tail
OnTailN=StPMaxInd+find(TrekSet.StandardPulse(StPMaxInd+1:end)<OnTailBorder,1,'first');






trek=TrekSet.trek;
StdVal=TrekSet.StdVal;
trSize=TrekSet.size;
OverSt=TrekSet.OverStThr;

% Threshold=StdVal*OverSt;
Threshold=TrekSet.Threshold;

% trekS=smooth(trek,SmoothPar);

FrontInd=[];
FrontHigh=zeros(trSize,1);



trR=circshift(trek,1);
trL=circshift(trek,-1);

FrontBool=trek>=trR&trek<=trL;
TailBool=trek>=trL&trek<=trL;
MaxBool=trek>trR&trek>=trL;
MinBool=trek<=trR&trek<trL;
MaxBool(1)=false;    MaxBool(end)=false;
MaxInd=find(MaxBool);
MaxN=size(MaxInd,1);

MinBool(1)=false;    MinBool(end)=false;
MinInd=find(MinBool);
MinN=size(MinInd,1);

 %making first minimum earlier then thirst maximum
 while MaxInd(1)<MinInd(1)
     MaxInd(1)=[];
     MaxN=MaxN-1;
 end;
 
%making equal quantity of maximums and minimums
 while MinN>MaxN
      MinInd(end)=[];
      MinN=MinN-1;
 end;

 FrontN=MaxInd-MinInd;

 FrontHigh=trek(MaxInd)-trek(MinInd);
 

trD=diff(trek,1);
trD(end+1)=0;
trD(MaxInd)=0;
trD(MinInd)=0;
trDR=circshift(trD,1);
trDL=circshift(trD,-1);
trDMinBool=trD<trDL&trD<=trDR;
trDMinInd=find(trDMinBool);

%Searching peaks on front
%These are points on front where are minimums of trek derivation
%At first choose such ^ points and minimums of trek
%It's necceseary for calculating gap
Bool=(trDMinBool&FrontBool)|MinBool;
%Finding indexes of points ^
Ind=find(Bool);
IndSh=circshift(Ind,1);
IndSh(1)=Ind(1);
%array of gaps
Difer=trek(Ind)-trek(IndSh);
%excluding points whith small gap
bool=Difer<Threshold;
Ind(bool)=[];
PeakOnFrontBool=false(trSize,1); 
PeakOnFrontBool(Ind)=true;
% excluding minimums
PeakOnFrontBool=PeakOnFrontBool&not(MinBool);
PeakOnFrontInd=find(PeakOnFrontBool);

TrekSet.PeakOnFrontInd=PeakOnFrontInd;
PeakOnFrontN=size(PeakOnFrontInd,1);



ByFrontBool=FrontHigh>=Threshold&FrontN>=2;
ByFrontInd=MaxInd(find(ByFrontBool));
ByFrontBool=false(trSize,1);
ByFrontBool(ByFrontInd)=true;
ByFrontN=size(ByFrontInd,1);

MaxIndSh=circshift(MaxInd,-1);
IndMaxAfter=zeros(trSize,1);
IndMaxAfter(MaxInd)=MaxIndSh;
IndMaxAfterByFront=IndMaxAfter(ByFrontBool);

A=zeros(trSize,1);
A(IndMaxAfterByFront)=IndMaxAfterByFront-ByFrontInd;
IntervalAfterByFront=A;

% A=zeros(trSize,1);
% A(MaxInd)=FrontHigh;
% FrontHigh=A;
% OnTailBool=IntervalAfterByFront<OnTailN&IntervalAfterByFront>0&FrontHigh>StdVal&not(ByFrontBool);
% OnTailInd=find(OnTailBool);
% OnTailN=size(OnTailInd,1);

% SelectedBool=ByFrontBool|OnTailBool|PeakOnFrontBool;
SelectedBool=ByFrontBool|PeakOnFrontBool;

SelectedBool(trSize-OnTailN:end)=false; %not proccessing tail
SelectedInd=find(SelectedBool);
SelectedN=size(SelectedInd,1);

TrekSet.SelectedPeakInd=SelectedInd;
TrekSet.Threshold=Threshold/2; %/2 because Threshold is for FrontHigh, which is double amlitude

fprintf('=====  Search of peak tops      ==========\n');
fprintf('The number of measured points  = %7.0f during %7.0f us \n',trSize,trSize*TrekSet.tau);
fprintf('Threshold is %3.1f*%5.3f = %5.3f \n',OverSt,StdVal,Threshold);
fprintf('The total number of maximum = %7.0f \n',MaxN);
fprintf('The number peaks selected by FrontHigh = %7.0f \n',ByFrontN);
% fprintf('The number peaks selected on tail= %7.0f \n',OnTailN);
fprintf('The number peaks selected on Front= %7.0f \n',PeakOnFrontN);
fprintf('The number of selected peaks = %7.0f \n',SelectedN);
fprintf('>>>>>>>>>>>>>>>>>>>>>>Search by Front Finished\n');
toc

 if Plot
   figure;
   plot(trek);
   grid on; hold on;
   plot(SelectedInd,trek(SelectedInd),'.r');
%  plot(find(OnTailBool),trek(OnTailBool),'om');
   plot(TrekSet.PeakOnFrontInd,trek(TrekSet.PeakOnFrontInd),'dg');
%     pause;
%   close(gcf);
 end;





