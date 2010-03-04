function PeakSet=SearchByFront(TrekSet);

tic;
disp('>>>>>>>>Search by Front started');

OverSt=6.5;
BckgFitN=2;
OnTailBorder=0.1;

% SmoothPar=5;

StandardPulseFile='D:\!SCN\EField\StandPeakAnalys\StPeak20ns_2.dat';

if exist(StandardPulseFile,'file');
     StandardPulse=load(StandardPulseFile);
end;

[StPMax,StPMaxInd]=max(StandardPulse);
FirstNonZero=find(StandardPulse,1,'first');
LastNonZero=find(StandardPulse,1,'last');
MaxFrontN=StPMaxInd-FirstNonZero+1;
MaxTailN=LastNonZero-StPMaxInd+1;
OnTailN=StPMaxInd+find(StandardPulse(StPMaxInd+1:end)<OnTailBorder,1,'first');






trek=TrekSet.trek;
StdVal=TrekSet.StdVal;
trSize=TrekSet.Size;

Threshold=StdVal*OverSt;

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

 while MaxInd(1)<MinInd(1)
     MaxInd(1)=[];
     MaxN=MaxN-1;
 end;
 
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


Bool=(trDMinBool&FrontBool)|MinBool;
Ind=find(Bool);
IndSh=circshift(Ind,1);
IndSh(1)=Ind(1);
Difer=trek(Ind)-trek(IndSh);
bool=Difer<Threshold;
Ind(bool)=[];
PeakOnFrontBool=false(trSize,1);
PeakOnFrontBool(Ind)=true;
PeakOnFrontBool=PeakOnFrontBool&not(MinBool);
PeakOnFrontInd=find(PeakOnFrontBool);

PeakSet.PeakOnFrontInd=PeakOnFrontInd;
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

A=zeros(trSize,1);
A(MaxInd)=FrontHigh;
FrontHigh=A;
OnTailBool=IntervalAfterByFront<OnTailN&IntervalAfterByFront>0&FrontHigh>StdVal&not(ByFrontBool);
OnTailInd=find(OnTailBool);
OnTailN=size(OnTailInd,1);

SelectedBool=ByFrontBool|OnTailBool|PeakOnFrontBool;
SelectedInd=find(SelectedBool);
SelectedN=size(SelectedInd,1);

PeakSet.SelectedPeakInd=SelectedInd;
PeakSet.Threshold=Threshold;
%search of PeakOnFront

% if not(isempty(PeakSet.SelectedPeakInd))
% %     IntervalBefore=SelectedInd-circshift(SelectedInd,1);
% %     IntervalBefore(1)=SelectedInd(1);
%     IntervalAfter=circshift(SelectedInd,-1)-SelectedInd;
%     IntervalAfter(end)=trSize-SelectedInd(end);
%     PeakOnFrontBool=PeakOnFrontBool(SelectedInd);
%     PeakOnFrontBool=(IntervalAfter<MaxFrontN)|PeakOnFrontBool;
%     PeakOnFrontN=size(find(PeakOnFrontBool),1);
%     PeakSet.PeakOnFrontInd=SelectedInd(PeakOnFrontBool);
% end;

toc
fprintf('=====  Search of peak tops      ==========\n');
fprintf('The number of measured points  = %7.0f during %7.0f us \n',trSize,trSize*TrekSet.tau);
fprintf('Threshold is %3.1f*%5.3f = %5.3f \n',OverSt,StdVal,Threshold);
fprintf('The total number of maximum = %7.0f \n',MaxN);
fprintf('The number peaks selected by FrontHigh = %7.0f \n',ByFrontN);
fprintf('The number peaks selected on tail= %7.0f \n',OnTailN);
fprintf('The number peaks selected on Front= %7.0f \n',PeakOnFrontN);
fprintf('The number of selected peaks = %7.0f \n',SelectedN);
fprintf('>>>>>>>>>>>>>>>>>>>>>>Search by Front Finished\n');


%  figure;
%  plot(trek);
%  grid on; hold on;
%  plot(SelectedInd,trek(SelectedInd),'.r');
%  plot(find(OnTailBool),trek(OnTailBool),'om');
%  plot(PeakSet.PeakOnFrontInd,trek(PeakSet.PeakOnFrontInd),'dg');






