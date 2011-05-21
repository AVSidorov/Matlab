function TrekSet=TrekPeakSearch(TrekSetIn);

TrekSet=TrekSetIn;
tic;
disp('>>>>>>>>Search by Front started');


BckgFitN=2;
OnTailBorder=0.1;
DoubleFrontK=1.5;
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
TailBool=trek>=trL&trek<=trR;
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
NCombined=fix(FrontN/MaxFrontN); %approximate number of combined pulses for each peak
NCombinedMax=max(NCombined);
LongFrontInd=[];
for i=1:NCombinedMax %this cycle is allowed because have small number of repeatitions
    LFrontInd=MinInd+i*MaxFrontN;
    
    LFrontInd=LFrontInd(LFrontInd<MaxInd...                                         %first condition means that front more than i*MaxFrontN, 
                        &(MaxInd-LFrontInd)>=(MaxFrontN-1));                         %second that after found Ind are not only several(one/two) points in other words front is more than i*MaxFrontN+MaxFrontN-1, i.e. more than 2/3/4*MaxFrontN
    LFrontInd=LFrontInd((trek(LFrontInd)-trek(LFrontInd-MaxFrontN))>Threshold);     %Means that gap between previous minimum(i=1)/marker(i>1) is more than Threshold
                   

    LongFrontInd=[LongFrontInd;LFrontInd];
end;
LongFrontBool=false(trSize,1);
LongFrontBool(LongFrontInd)=true;

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

LongFrontN=size(LongFrontInd,1);
TrekSet.LongFrontInd=LongFrontInd;

%% ===============Main Search

ByFrontBool=FrontHigh>=Threshold&abs(MaxFrontN-FrontN)<=2; %first conditon is for front high, second means that front couldn't be shorter or longer  
ByFrontInd=MaxInd(find(ByFrontBool));
ByFrontBool=false(trSize,1);
ByFrontBool(ByFrontInd)=true;
ByFrontN=size(ByFrontInd,1);

%% ==============By High
ByHighBool=(trek>Threshold)&MaxBool; % It is necessary for small peaks, wich
ByHighBool(ByFrontBool)=false;       % have noise maximum on front. As result
ByHighInd=find(ByHighBool);          % both noise and signal Maximums 
ByHighN=size(ByHighInd,1);           % don't match FrontHigh Conditions
                                     % This work only if NullLine is "zero"
                                     % This work because Threshold is for
                                     % FrontHigh. And if value of trek is
                                     % higher than "Threshold" it means trek
                                     % value is higher than double noise magnitude
                                   
%% =============Double Front
FrontHighSh=circshift(FrontHigh,-1); % Another way to searching such pulses
FrontHighSh(end)=0;
%Searching 
ByDoubleFrontBool=(FrontHigh(1:end-1)+FrontHighSh(1:end-1)-TailHigh)>Threshold*DoubleFrontK;
%"DoubleFrontK" is neccesary because It is most probable two noise fronts
% have magnitude close to threshold and if tail between is small the
% condition can be satisfied. In case of noise maximum on Front of pulse both
% Fronts must have almost Threshold "FrontHigh" value and small Tail high
% between. So sum must have almost double Threshold magnitude

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



%% =========== Search PeakOnTail
bool=trek~=0;
A=trek;
A(bool)=abs(trD(bool))./trek(bool);
A(trek<Threshold)=0;
Ar=circshift(A,1);
Al=circshift(A,-1);

PeakOnTailBool=Ar>A&Al>A&TailBool&A<0.01;
PeakOnTailBool(MinBool)=false;
PeakOnTailBool(MaxBool)=false;
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
 PeakOnTailInd=find(PeakOnTailBool);
 PeakOnTailN=size(PeakOnTailInd,1);
 TrekSet.PeakOnTailInd=PeakOnTailInd;



%% ============ Combine All
SelectedBool=ByFrontBool|PeakOnFrontBool|ByDoubleFrontBool|ByHighBool|PeakOnTailBool|LongFrontBool;

SelectedBool(trSize-OnTailN:end)=false; %not proccessing tail
SelectedInd=find(SelectedBool);
SelectedN=size(SelectedInd,1);

TrekSet.SelectedPeakInd=SelectedInd;
TrekSet.Threshold=Threshold/2; %/2 because Threshold is for FrontHigh,
                               % which is generaly double noise amlitude. And in GetPeaks
                               % Amplitude of pulse is used



%% end information
fprintf('=====  Search of peak tops      ==========\n');
fprintf('The number of measured points  = %7.0f during %7.0f us \n',trSize,trSize*TrekSet.tau);
fprintf('Threshold is %3.1f*%5.3f = %5.3f \n',Threshold/StdVal,StdVal,Threshold);
fprintf('OverSt is %3.1f\n',OverSt);
fprintf('The total number of maximum = %7.0f \n',MaxN);
fprintf('The number peaks selected by FrontHigh = %7.0f \n',ByFrontN);
fprintf('The number peaks selected by High = %7.0f \n',ByHighN);
fprintf('The number peaks selected by DoubleFrontHigh = %7.0f \n',ByDoubleFrontN);
% fprintf('The number peaks selected by LongFront = %7.0f \n',ByLongFrontN);
fprintf('The number peaks selected by LongFront = %7.0f \n',LongFrontN);
fprintf('The number peaks selected on tail= %7.0f \n',PeakOnTailN);
fprintf('The number peaks selected on Front= %7.0f \n',PeakOnFrontN);
fprintf('The number of selected peaks = %7.0f \n',SelectedN);
fprintf('>>>>>>>>>>>>>>>>>>>>>>Search by Front Finished\n');
toc

%% end plot
 if Plot
   figure;
   plot(trek);
   s='trek';
   grid on; hold on;
   if not(isempty(SelectedInd))
       plot(SelectedInd,trek(SelectedInd),'.r');
       s=strvcat(s,'SelectedInd');
   end;
   if not(isempty(ByHighInd))
       plot(ByHighInd,trek(ByHighInd),'mo');
       s=strvcat(s,'ByHigh');
   end;
   if not(isempty(PeakOnTailInd))
       plot(PeakOnTailInd,trek(PeakOnTailInd),'sk');
      s=strvcat(s,'OnTail');
   end;
   if not(isempty(PeakOnFrontInd))
       plot(TrekSet.PeakOnFrontInd,trek(TrekSet.PeakOnFrontInd),'dg');
       s=strvcat(s,'OnFront');
   end;
   
%    plot(ByLongFrontInd,trek(ByLongFrontInd),'+g');  
   if not(isempty(SelectedInd))
       plot(LongFrontInd,trek(LongFrontInd),'+r');  
       s=strvcat(s,'LongFrontInd');
   end;
   if not(isempty(ByDoubleFrontInd))
       plot(ByDoubleFrontInd,trek(ByDoubleFrontInd),'ro');   
       s=strvcat(s,'DoubleFront');
   end;
   warning off; 
   legend(s);
   warning on;
%      pause;
%      close(gcf);
 end;





