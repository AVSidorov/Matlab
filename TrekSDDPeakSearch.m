function TrekSet=TrekSDDPeakSearch(TrekSetIn,EndOut)

tic;
disp('>>>>>>>>TrekPeakSearch started');

TrekSet=TrekSetIn;


if nargin<2
    EndOut=true;
end;











trek=TrekSet.trek;
StdVal=TrekSet.StdVal;
trSize=TrekSet.size;
OverSt=TrekSet.OverSt;

% Threshold=StdVal*OverSt;
Threshold=TrekSet.Threshold;
if isempty(Threshold)
    Threshold=OverSt*StdVal;
end;



Threshold=Threshold*2;
% trekS=smooth(trek,SmoothPar);

FrontInd=[];
FrontHigh=zeros(trSize,1);



trR=circshift(trek,1); %circshift works on vectors (vertical arrays)
trL=circshift(trek,-1);

FrontBool=trek>=trR&trek<=trL;
TailBool=trek>=trL&trek<=trR;
MaxBool=trek>trR&trek>=trL;
MinBool=trek<=trR&trek<trL;
MaxBool(1)=false;    MaxBool(end)=false;
MaxInd=find(MaxBool);
MaxN=numel(MaxInd);

MinBool(1)=false;    MinBool(end)=false;
MinInd=find(MinBool);
MinN=numel(MinInd);

if MinInd(1)>MaxInd(1)
    MinInd=[1;MinInd];    
    MinN=MinN+1;
end;


 
%making equal quantity of maximums and minimums
 if MinN>MaxN
      MaxInd(end+1)=trSize; %earlier was removing MinInd, by this cause errors in HighPeak Search
      MaxN=MaxN+1;
 end;
 
 
 MaxBool=false(trSize,1);
 MaxBool(MaxInd)=true;
 MinBool=false(trSize,1);
 MinBool(MinInd)=true;

 FrontN=MaxInd-MinInd;
 TailN=MinInd(2:end)-MaxInd(1:end-1);
 
 
 FrontHigh=trek(MaxInd)-trek(MinInd);
 TailHigh=trek(MaxInd(1:end-1))-trek(MinInd(2:end));

%% ======= Special trek constructing
FrontsN=zeros(trSize,1);
FrontsHigh=zeros(trSize,1);

FrontNMax=max(FrontN);
%additional condition to avoid long tails for reset pulses
TailNMax=max(TailN(trek(MinInd(2:end))>-Threshold));
trekS=zeros(trSize,1);
for i=1:FrontNMax
    Ind=find(FrontN>=i);
    FrontsN(MinInd(Ind)+i)=i;
    FrontsHigh(MinInd(Ind)+i)=trek(MinInd(Ind)+i)-trek(MinInd(Ind));
end;
for i=1:TailNMax
    Ind=find(TailN>=i);
    FrontsN(MaxInd(Ind)+i)=-i;
    FrontsHigh(MaxInd(Ind)+i)=trek(MaxInd(Ind)+i)-trek(MaxInd(Ind));
end;

FrontsHighR=circshift(FrontsHigh,1);
FrontsHighL=circshift(FrontsHigh,-1);
MaxBoolFronts=FrontsHigh>FrontsHighR&FrontsHigh>=FrontsHighL;
MaxBoolFronts(1)=false;    MaxBoolFronts(end)=false;
MaxIndFronts=find(MaxBoolFronts);

HighFrontStartBool=FrontsHighL>=Threshold&FrontsHigh<Threshold;
HighFrontStartInd=find(HighFrontStartBool);
HighFrontN=MaxInd(find(FrontHigh>=Threshold))-HighFrontStartInd;
%for peaks whith good zero level this ^ condition is too strong
%This is for good zero level peaks (for LongFrontSearch)
HighPeakBool=MaxBool&trek>Threshold/2;
%Exclude PeaksOnTail and etc.
HighPeakBool(MaxInd(find(trek(MinInd)>=Threshold/2)))=false;
HighPeakInd=find(HighPeakBool);
HighPeakStartBool=trL>Threshold/2&trek<Threshold/2;
HighPeakStartBool(end)=false;
HighPeakStartInd=find(HighPeakStartBool);
HighPeakN=HighPeakInd-HighPeakStartInd; 

clear trL trR FrontsHighL FrontsHighR;



%% ============ Search Markers
%SelectedBool=ByFrontBool|PeakOnFrontBool|ByHighBool|LongFrontBool;
SelectedBool=MaxBool&MaxBoolFronts&FrontsHigh>Threshold/2&trek>Threshold/2;

% SelectedBool(trSize-OnTailN:end)=false; %not proccessing tail
SelectedInd=find(SelectedBool);
SelectedN=numel(SelectedInd);

%% ====== PeakOnFront Search
%Searching peaks on front of selected pulses
%These are points on front where are minimums of trek derivation

%Search Minimums are correspondig to SelectedInd
Difer=circshift(MinInd,-1)-MinInd;
Difer(end)=0;
DeltaMinTrek=zeros(trSize,1);
DeltaMinTrek(MinInd)=Difer;

MinSelectedInd=find(MinBool|SelectedBool);
Difer=circshift(MinSelectedInd,-1)-MinSelectedInd;
Difer(end)=0;
DeltaMinSelectedTrek=zeros(trSize,1);
DeltaMinSelectedTrek(MinSelectedInd)=Difer;
MinPreSelBool=DeltaMinTrek-DeltaMinSelectedTrek>0;
MinPreSelInd=find(MinPreSelBool);





% search trek derivation minimums
trD=diff(trek,1);
trD(end+1)=0;
trD(MaxInd)=0;
trD(MinInd)=0;
trDR=circshift(trD,1);
trDL=circshift(trD,-1);
trDMinBool=trD<trDL&trD<trDR;
trDMinInd=find(trDMinBool);

%Select from trDMinInd points whith large enough front length and high
PeakOnFrontInd=trDMinInd;
PeakOnFrontInd=PeakOnFrontInd(FrontsHigh(PeakOnFrontInd)>Threshold);
PeakOnFrontInd=PeakOnFrontInd(trek(PeakOnFrontInd)>Threshold);
PeakOnFrontBool=false(trSize,1);
PeakOnFrontBool(PeakOnFrontInd)=true;
PeakOnFrontBool(SelectedInd)=false;
PeakOnFrontInd=find(PeakOnFrontBool);

PeakOnFrontBool=PeakOnFrontBool|MinPreSelBool|SelectedBool;
PeakOnFrontInd=find(PeakOnFrontBool);
Difer=PeakOnFrontInd-circshift(PeakOnFrontInd,1);
if ~isempty(Difer)
    Difer(1)=0;
end;
PeakOnFrontInd=PeakOnFrontInd(Difer>TrekSet.STP.FrontN/3);
PeakOnFrontBool=false(trSize,1);
PeakOnFrontBool(PeakOnFrontInd)=true;
PeakOnFrontBool(MinInd)=false;
PeakOnFrontBool(SelectedInd)=false;
PeakOnFrontInd=find(PeakOnFrontBool);

PeakOnFrontBool=PeakOnFrontBool|SelectedBool;
PeakOnFrontInd=find(PeakOnFrontBool);
Difer=circshift(PeakOnFrontInd,-1)-PeakOnFrontInd;
if ~isempty(Difer)
    Difer(end)=0;
end;
PeakOnFrontInd=PeakOnFrontInd(Difer>TrekSet.STP.FrontN/3);
PeakOnFrontBool=false(trSize,1);
PeakOnFrontBool(PeakOnFrontInd)=true;
PeakOnFrontBool(SelectedInd)=false;
PeakOnFrontInd=find(PeakOnFrontBool);
PeakOnFrontN=numel(PeakOnFrontInd);

SelectedBool=SelectedBool|PeakOnFrontBool;
SelectedInd=find(SelectedBool);
SelectedN=numel(SelectedInd);

% % Calculating Gaps from this points from minimum of trek
% % and to SelectedPulseInd
% 
% %Gaps from Minimum
% %At first choose such ^ points and minimums befor SelectedInd of trek
% Bool=(trDMinBool&FrontBool)|MinPreSelBool;
% %Finding indexes of points ^
% Ind=find(Bool);
% IndSh=circshift(Ind,1);
% IndSh(1)=Ind(1);
% %array of gaps
% Difer=trek(Ind)-trek(IndSh);
% %array of size gaps in points
% DiferN=Ind-IndSh;
% %excluding points whith small gap or size gap in points is short or long
% bool=Difer<Threshold;%|abs(MaxFrontN-DiferN)>=2;
% 
% Ind(bool)=[];
% 
% PeakOnFrontBool=false(trSize,1); 
% PeakOnFrontBool(Ind)=true;
% % excluding minimums
% PeakOnFrontBool=PeakOnFrontBool&not(MinBool);
% PeakOnFrontBool(MaxInd)=false; %exclude Maximums
% PeakOnFrontInd=find(PeakOnFrontBool);
% 
% %search peak on front without trD minimum 
% % bool=FrontN>=2*MaxFrontN
% 
% 
% TrekSet.PeakOnFrontInd=PeakOnFrontInd;
% PeakOnFrontN=size(PeakOnFrontInd,1);



%% =====  End                                  


TrekSet.SelectedPeakInd=SelectedInd;
TrekSet.SelectedPeakFrontN=FrontsN(SelectedInd);

% ZeroFrontInd=find(TrekSet.SelectedPeakFrontN==0);
% TrekSet.SelectedPeakInd(ZeroFrontInd)=[];
% TrekSet.SelectedPeakFrontN(ZeroFrontInd)=[];


%% ===== End information
if EndOut %to avoid statistic typing in short calls
    fprintf('=====  Search of peak tops      ==========\n');
    fprintf('The number of measured points  = %7.0f during %7.0f us \n',trSize,trSize*TrekSet.tau);
    fprintf('Threshold is %3.1f*%5.3f = %5.3f \n',Threshold/StdVal,StdVal,Threshold);
    fprintf('OverSt is %3.1f\n',OverSt);
    fprintf('The total number of maximum = %7.0f \n',MaxN);
    fprintf('The number of selected peaks = %7.0f \n',SelectedN);
    fprintf('The number peaks selected on Front= %7.0f \n',PeakOnFrontN);
    fprintf('>>>>>>>>>>>>>>>>>>>>>>Search by Front Finished\n');
end;
%%
toc;
%% end plot
 if TrekSet.Plot&&EndOut
   figure;
   plot(trek);
   s='trek';
   grid on; hold on;
   if not(isempty(SelectedInd))
       plot(SelectedInd,trek(SelectedInd),'.r');
       s=char(s,'SelectedInd');
   end;
   if not(isempty(PeakOnFrontInd))
       plot(PeakOnFrontInd,trek(PeakOnFrontInd),'db');
       s=char(s,'OnFront');
   end;
   warning off; 
   legend(s);
   warning on;
      pause;
%        close(gcf);
 end;




