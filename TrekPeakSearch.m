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
OverSt=TrekSet.OverSt;

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
 
 MaxBool=false(trSize,1);
 MaxBool(MaxInd)=true;
 MinBool=false(trSize,1);
 MinBool(MinInd)=true;

 FrontN=MaxInd-MinInd;

 FrontHigh=trek(MaxInd)-trek(MinInd);
 TailHigh=trek(MaxInd(1:end-1))-trek(MinInd(2:end));

 
%====== PeakOnFront Search
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


%===============Main Search

ByFrontBool=FrontHigh>=Threshold&FrontN>=2;
ByFrontInd=MaxInd(find(ByFrontBool));
ByFrontBool=false(trSize,1);
ByFrontBool(ByFrontInd)=true;
ByFrontN=size(ByFrontInd,1);

ByHighBool=(trek>Threshold)&MaxBool; % It is necessary for small peaks, wich
ByHighBool(ByFrontBool)=false;
ByHighInd=find(ByHighBool);          % have noise maximum on front. As result
ByHighN=size(ByHighInd,1);          % both noise and signal Maximums
                                     % don't match FrontHigh Conditions                                                                      
                                   
FrontHighSh=circshift(FrontHigh,-1); % Another way to searching such pulses
FrontHighSh(end)=0;
%Searching 
ByDoubleFrontBool=(FrontHigh(1:end-1)+FrontHighSh(1:end-1)-TailHigh)>Threshold;
%pick points there first Front is higher;
IndFirst=MaxInd(find(ByDoubleFrontBool&(FrontHigh(1:end-1)>=FrontHighSh(1:end-1))));
%pick points there second Front is higher;
IndSecond=MaxInd(find(ByDoubleFrontBool&(FrontHigh(1:end-1)<FrontHighSh(1:end-1)))+1);

ByDoubleFrontBool=false(trSize,1);
ByDoubleFrontBool(IndFirst)=true;
ByDoubleFrontBool(IndSecond)=true;
ByDoubleFrontBool(ByFrontBool)=false;
ByDoubleFrontBool(ByHighBool)=false;
ByDoubleFrontInd=find(ByDoubleFrontBool);
ByDoubleFrontN=size(ByDoubleFrontInd,1);

% =========== Search PeakOnTail
% MaxIndSh=circshift(MaxInd,-1);
% IndMaxAfter=zeros(trSize,1);
% IndMaxAfter(MaxInd)=MaxIndSh;
% IndMaxAfterByFront=IndMaxAfter(ByFrontBool);
% 
% A=zeros(trSize,1);
% A(IndMaxAfterByFront)=IndMaxAfterByFront-ByFrontInd;
% IntervalAfterByFront=A;

% A=zeros(trSize,1);
% A(MaxInd)=FrontHigh;
% FrontHigh=A;
% OnTailBool=IntervalAfterByFront<OnTailN&IntervalAfterByFront>0&FrontHigh>StdVal&not(ByFrontBool);
% OnTailInd=find(OnTailBool);
% OnTailN=size(OnTailInd,1);

% SelectedBool=ByFrontBool|OnTailBool|PeakOnFrontBool;
%============ Combine All
SelectedBool=ByFrontBool|PeakOnFrontBool|ByDoubleFrontBool|ByHighBool;

SelectedBool(trSize-OnTailN:end)=false; %not proccessing tail
SelectedInd=find(SelectedBool);
SelectedN=size(SelectedInd,1);

TrekSet.SelectedPeakInd=SelectedInd;
TrekSet.Threshold=Threshold/2; %/2 because Threshold is for FrontHigh,
                               % which is generaly double noise amlitude. And in GetPeaks
                               % Amplitude of pulse is used
                                    

fprintf('=====  Search of peak tops      ==========\n');
fprintf('The number of measured points  = %7.0f during %7.0f us \n',trSize,trSize*TrekSet.tau);
fprintf('Threshold is %3.1f*%5.3f = %5.3f \n',Threshold/StdVal,StdVal,Threshold);
fprintf('OverSt is %3.1f\n',OverSt);
fprintf('The total number of maximum = %7.0f \n',MaxN);
fprintf('The number peaks selected by FrontHigh = %7.0f \n',ByFrontN);
fprintf('The number peaks selected by High = %7.0f \n',ByHighN);
fprintf('The number peaks selected by DoubleFrontHigh = %7.0f \n',ByDoubleFrontN);
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
   plot(ByHighInd,trek(ByHighInd),'mo');
   plot(ByDoubleFrontInd,trek(ByDoubleFrontInd),'ro');   
%  plot(find(OnTailBool),trek(OnTailBool),'om');
   plot(TrekSet.PeakOnFrontInd,trek(TrekSet.PeakOnFrontInd),'dg');
%     pause;
%   close(gcf);
 end;





