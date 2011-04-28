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

TrekSet.PeakOnFrontInd=PeakOnFrontInd;
PeakOnFrontN=size(PeakOnFrontInd,1);


%% ===============Main Search

ByFrontBool=FrontHigh>=Threshold&abs(MaxFrontN-FrontN)<=2; %first conditon is for front high, second means that front couldn't be shorter or longer  
ByFrontInd=MaxInd(find(ByFrontBool));
ByFrontBool=false(trSize,1);
ByFrontBool(ByFrontInd)=true;
ByFrontN=size(ByFrontInd,1);

ByHighBool=(trek>Threshold)&MaxBool; % It is necessary for small peaks, wich
ByHighBool(ByFrontBool)=false;       % have noise maximum on front. As result
ByHighInd=find(ByHighBool);          % both noise and signal Maximums 
ByHighN=size(ByHighInd,1);           % don't match FrontHigh Conditions
                                     % This work only if NullLine is "zero"
                                     % This work because Threshold is for
                                     % FrontHigh. And if value of trek is
                                     % higher than "Threshold" it means trek
                                     % value is higher than double noise magnitude
                                   
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

OnTailBool=Ar>A&Al>A&TailBool&A<0.01;
OnTailBool(MinBool)=false;
OnTailBool(MaxBool)=false;
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
 OnTailInd=find(OnTailBool);
 OnTailN=size(OnTailInd,1);
 TrekSet.OnTailInd=OnTailInd;

%% ============ Combine All
SelectedBool=ByFrontBool|PeakOnFrontBool|ByDoubleFrontBool|ByHighBool|OnTailBool;

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
fprintf('The number peaks selected on tail= %7.0f \n',OnTailN);
fprintf('The number peaks selected on Front= %7.0f \n',PeakOnFrontN);
fprintf('The number of selected peaks = %7.0f \n',SelectedN);
fprintf('>>>>>>>>>>>>>>>>>>>>>>Search by Front Finished\n');
toc

%% end plot
 if Plot
   figure;
   plot(trek);
   grid on; hold on;
   plot(SelectedInd,trek(SelectedInd),'.r');
   plot(ByHighInd,trek(ByHighInd),'mo');
   plot(ByDoubleFrontInd,trek(ByDoubleFrontInd),'ro');   
   plot(find(OnTailBool),trek(OnTailBool),'sk');
   plot(TrekSet.PeakOnFrontInd,trek(TrekSet.PeakOnFrontInd),'dg');
   warning off; 
   legend('trek','Selected','ByHigh','ByFront','OnTail','OnFront');
   warning on;
%    pause;
%    close(gcf);
 end;





