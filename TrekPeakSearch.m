function TrekSet=TrekPeakSearch(TrekSetIn,StpSet,EndOut);

tic;
disp('>>>>>>>>TrekPeakSearch started');

TrekSet=TrekSetIn;

if nargin<2
    StpSet=StpStruct(TrekSet.StandardPulse);
end;

if nargin<3
    EndOut=true;
end;



MaxFrontN=StpSet.FrontN;








trek=TrekSet.trek;
StdVal=TrekSet.StdVal;
trSize=TrekSet.size;
OverSt=TrekSet.OverSt;

% Threshold=StdVal*OverSt;
Threshold=TrekSet.Threshold;

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
TailNMax=max(TailN);
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
HighFrontStartBool=FrontsHighL>=Threshold&FrontsHigh<Threshold;
HighFrontStartInd=find(HighFrontStartBool);
HighFrontN=MaxInd(find(FrontHigh>=Threshold))-HighFrontStartInd;
%for peaks whith good zero level this ^ condition is too strong
%This is for good zero level peaks (for LongFrontSearch)
HighPeakBool=MaxBool&trek>Threshold/2;
%Exclude PeaksOnTail and etc.
HighPeakBool(MaxInd(find(trek(MinInd)>=Threshold/2)))=false;
HighPeakInd=find(HighPeakBool);
HighPeakStartBool=trL>=Threshold/2&trek<Threshold/2;
HighPeakStartInd=find(HighPeakStartBool);
HighPeakN=HighPeakInd-HighPeakStartInd; 

%% ==============By High
ByHighBool=HighPeakBool&FrontsN>=MaxFrontN-1;               % It is necessary for peaks with small front
                                                            % For example, Peak haves noise maximum on front. 
ByHighBool(end)=false;
ByHighInd=find(ByHighBool);            % As result both noise and signal Maximums 
ByHighN=size(ByHighInd,1);             % don't match FrontHigh Conditions
                                       % This work only if NullLine is "zero"
                                       % ByHigh is not equal HighPeak
                                       
%% ===============By Front

ByFrontBool=FrontHigh>=Threshold&FrontN>=MaxFrontN-1; %first conditon is for front high,
                                                      %second means that front couldn't be shorter   
                                                      %mark only Maximums
ByFrontInd=MaxInd(find(ByFrontBool));
ByFrontBool=false(trSize,1);
ByFrontBool(ByFrontInd)=true;
ByFrontBool(end)=false; %
ByFrontBool(ByHighBool)=false;
ByFrontInd=find(ByFrontBool);
ByFrontN=size(ByFrontInd,1);


%% ====== PeakOnFront Search
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
%array of size gaps in points
DiferN=Ind-IndSh;
%excluding points whith small gap or size gap in points is short or long
bool=Difer<Threshold;%|abs(MaxFrontN-DiferN)>=2;

Ind(bool)=[];

PeakOnFrontBool=false(trSize,1); 
PeakOnFrontBool(Ind)=true;
% excluding minimums
PeakOnFrontBool=PeakOnFrontBool&not(MinBool);
PeakOnFrontBool(MaxInd)=false; %exclude Maximums
PeakOnFrontInd=find(PeakOnFrontBool);

%search peak on front without trD minimum 
% bool=FrontN>=2*MaxFrontN


TrekSet.PeakOnFrontInd=PeakOnFrontInd;
PeakOnFrontN=size(PeakOnFrontInd,1);
%% =========== Search LongFront

% ByLongFrontBool=FrontHigh>=2*Threshold&FrontN>=2*MaxFrontN; 
% 
% ByLongFrontInd=[MinInd(find(ByLongFrontBool)):MaxFrontN:MaxInd(find(ByLongFrontBool))]';
% ByLongFrontBool=false(trSize,1);
% ByLongFrontBool(ByLongFrontInd)=true;
% ByLongFrontN=size(ByLongFrontInd,1);
 

% %common way for PeakOnFront and LongFront search
% use only for HighPeaks (later was by front Determenation)
NCombined=fix(HighPeakN/MaxFrontN); %approximate number of combined pulses for each peak
NCombinedMax=max(NCombined);
LongFrontInd=[];
for i=1:NCombinedMax %this cycle is allowed because have small number of repeatitions
    LFrontInd=(HighPeakStartInd-1)+i*MaxFrontN;     %usualy first point before Threshold is next after last zero point of Standard Pulse
    
    LFrontInd=LFrontInd(LFrontInd<HighPeakInd...                                     %first condition means that front more than i*MaxFrontN, 
                        &(HighPeakInd-LFrontInd)>=(MaxFrontN-1));                         %second that after found Ind are not only several(one/two) points in other words front is more than i*MaxFrontN+MaxFrontN-1, i.e. more than 2/3/4*MaxFrontN
    LFrontInd=LFrontInd((trek(LFrontInd)-trek(LFrontInd-MaxFrontN))>Threshold);     %Means that gap between previous minimum(i=1)/marker(i>1) is more than Threshold
                   

    LongFrontInd=[LongFrontInd;LFrontInd];
end;
LongFrontBool=false(trSize,1);
LongFrontBool(LongFrontInd)=true;
LongFrontBool(MaxInd)=false; %exclude maximums


%sorting peaks if there are near PeakOnFront and LongFront remove LongFront
%Marker
Bool=PeakOnFrontBool|LongFrontBool;
Ind=find(Bool);
if not(isempty(Ind))
    DifAfter=circshift(Ind,-1)-Ind;
    DifAfter(end)=inf;
    DifBefore=Ind-circshift(Ind,1);
    DifBefore(1)=inf;
    %leaves all peaks that have small space to next or previous
    %so both neighbour Indexes will remain
    Ind=Ind(DifAfter<(MaxFrontN-1)|DifBefore<(MaxFrontN-1));

    ClearBool=false(trSize,1);
    ClearBool(Ind)=true;
    ClearBool=ClearBool&LongFrontBool;

    LongFrontBool=LongFrontBool&not(ClearBool);
    LongFrontInd=find(LongFrontBool);
end;
TrekSet.LongFrontInd=LongFrontInd;
LongFrontN=size(LongFrontInd,1);

%% ============ Combine 
SelectedBool=ByFrontBool|PeakOnFrontBool|ByHighBool|LongFrontBool;

% SelectedBool(trSize-OnTailN:end)=false; %not proccessing tail
SelectedInd=find(SelectedBool);
SelectedN=numel(SelectedInd);




%% =====  End                                  


TrekSet.SelectedPeakInd=SelectedInd;
TrekSet.SelectedPeakFrontN=FrontsN(SelectedInd);
TrekSet.Threshold=Threshold/2; %/2 because Threshold is for FrontHigh,
                               % which is generaly double noise amlitude. And in GetPeaks
                               % Amplitude of pulse is used
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
    fprintf('The number peaks selected by FrontHigh = %7.0f \n',ByFrontN);
    fprintf('The number peaks selected by High = %7.0f \n',ByHighN);
    %fprintf('The number peaks selected by DoubleFrontHigh = %7.0f \n',ByDoubleFrontN);
    %fprintf('The number peaks selected by LongFront = %7.0f \n',ByLongFrontN);
    fprintf('The number peaks selected by LongFront = %7.0f \n',LongFrontN);
    %fprintf('The number peaks selected on tail= %7.0f \n',PeakOnTailN);
    fprintf('The number peaks selected on Front= %7.0f \n',PeakOnFrontN);
    fprintf('The number of selected peaks = %7.0f \n',SelectedN);
    fprintf('>>>>>>>>>>>>>>>>>>>>>>Search by Front Finished\n');
end;
%%
toc;
%% end plot
 if TrekSet.Plot%&EndOut
   figure;
   plot(trek);
   s='trek';
   grid on; hold on;
   if not(isempty(SelectedInd))
       plot(SelectedInd,trek(SelectedInd),'.r');
       s=strvcat(s,'SelectedInd');
   end;
   if not(isempty(ByFrontInd))
       plot(ByFrontInd,trek(ByFrontInd),'or');
       s=strvcat(s,'ByFront');
   end;
   if not(isempty(ByHighInd))
       plot(ByHighInd,trek(ByHighInd),'sm');
       s=strvcat(s,'ByHigh');
   end;
   if not(isempty(PeakOnFrontInd))
       plot(TrekSet.PeakOnFrontInd,trek(TrekSet.PeakOnFrontInd),'db');
       s=strvcat(s,'OnFront');
   end;
   if not(isempty(LongFrontInd))
       plot(TrekSet.LongFrontInd,trek(TrekSet.LongFrontInd),'hk');
       s=strvcat(s,'LongFront');
   end;  
   warning off; 
   legend(s);
   warning on;
      pause;
%        close(gcf);
 end;





