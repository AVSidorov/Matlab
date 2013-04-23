function TrekSet=TrekSDDPeakSearch(TrekSetIn,EndOut)

tic;
disp('>>>>>>>>TrekPeakSearch started');

TrekSet=TrekSetIn;


if nargin<2
    EndOut=true;
end;





OverSt=TrekSet.OverSt;

%% working with trek
trek=TrekSet.trek;
StdVal=TrekSet.StdVal;
trSize=TrekSet.size;


Threshold=TrekSet.Threshold;
if isempty(Threshold)
    Threshold=OverSt*StdVal;
end;

Threshold=Threshold*2;


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
      MaxInd(end+1)=trSize; %earlier was removing MinInd, by this causes errors in HighPeak Search
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
 
 clear trL trR;


%% working with diferential
trekD=diff(TrekSet.trek);
StdValD=std(trekD(trekD<0));
trSizeD=TrekSet.size-1;



FrontHighD=zeros(trSizeD,1);



trDR=circshift(trekD,1); %circshift works on vectors (vertical arrays)
trDL=circshift(trekD,-1);

FrontBoolD=trekD>=trDR&trekD<=trDL;
TailBoolD=trekD>=trDL&trekD<=trDR;
MaxBoolD=trekD>trDR&trekD>=trDL;
MinBoolD=trekD<=trDR&trekD<trDL;
MaxBoolD(1)=false;    MaxBoolD(end)=false;
MaxIndD=find(MaxBoolD);
MaxND=numel(MaxIndD);

MinBoolD(1)=false;    MinBoolD(end)=false;
MinIndD=find(MinBoolD);
MinND=numel(MinIndD);

if MinIndD(1)>MaxIndD(1)
    MinIndD=[1;MinIndD];    
    MinND=MinND+1;
end;


 
%making equal quantity of maximums and minimums
 if MinND>MaxND
      MaxIndD(end+1)=trSizeD; %earlier was removing MinInd, by this causes errors in HighPeak Search
      MaxND=MaxND+1;
 end;
 
 
 MaxBoolD=false(trSizeD,1);
 MaxBoolD(MaxIndD)=true;
 MinBoolD=false(trSizeD,1);
 MinBoolD(MinIndD)=true;

 FrontND=MaxIndD-MinIndD;
 TailND=MinIndD(2:end)-MaxIndD(1:end-1);
 
 
 FrontHighD=trekD(MaxIndD)-trekD(MinIndD);
 TailHighD=trekD(MaxIndD(1:end-1))-trekD(MinIndD(2:end));

%% ======= Special trek constructing trek
FrontsN=zeros(trSize,1);
FrontsHigh=zeros(trSize,1);

FrontNMax=max(FrontN);
TailNMax=max(TailN(TailHigh>1));
% %additional condition to avoid long tails for reset pulses
% TailNMax=max(TailN(trek(MinInd(2:end))>-Threshold));
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
 %% ======= Special trek constructing diff
FrontsND=zeros(trSizeD,1);
FrontsHighD=zeros(trSizeD,1);

FrontNMaxD=max(FrontND);
TailNMaxD=max(TailND(TailHighD>1));
% %additional condition to avoid long tails for reset pulses
% TailNMax=max(TailN(trek(MinInd(2:end))>-Threshold));
trekSD=zeros(trSizeD,1);
for i=1:FrontNMaxD
    Ind=find(FrontND>=i);
    FrontsND(MinIndD(Ind)+i)=i;
    FrontsHighD(MinIndD(Ind)+i)=trekD(MinIndD(Ind)+i)-trekD(MinIndD(Ind));
end;
for i=1:TailNMaxD
    Ind=find(TailND>=i);
    FrontsND(MaxIndD(Ind)+i)=-i;
    FrontsHighD(MaxIndD(Ind)+i)=trekD(MaxIndD(Ind)+i)-trekD(MaxIndD(Ind));
end;
ThresholdD=mean(FrontsHighD(FrontsHighD>0))*OverSt;

%% search markers by trek
SelectedBool=MaxBool&FrontsHigh>Threshold/2&trek>Threshold/2&FrontsN>TrekSet.STP.FrontN/2;
SelectedInd=find(SelectedBool);
SelectedN=numel(SelectedInd);

%% ============ STP for diff trek
STPD=StpStruct([TrekSet.STP.TimeInd(1:end-1)+0.5,diff(TrekSet.STP.FinePulse)]);

%% ============ Search Markers by diff
%SelectedBool=ByFrontBool|PeakOnFrontBool|ByHighBool|LongFrontBool;
% Fixed FrontN because diff of STP has flat part on front
SelectedBoolD=MaxBoolD&trekD>ThresholdD&FrontsHighD>ThresholdD&FrontsND>=3;


% SelectedBool(trSize-OnTailN:end)=false; %not proccessing tail
SelectedIndD=find(SelectedBoolD);

SelectedIndD=SelectedIndD((SelectedIndD-STPD.MaxInd+TrekSet.STP.MaxInd)>=1&(SelectedIndD-STPD.MaxInd+TrekSet.STP.MaxInd)<=TrekSet.size);
SelectedIndD=SelectedIndD(TrekSet.trek(SelectedIndD-STPD.MaxInd+TrekSet.STP.MaxInd)>TrekSet.Threshold);
SelectedBoolD=false(trSizeD,1);
SelectedBoolD(SelectedIndD)=true;
SelectedND=numel(SelectedIndD);

%% search strictStInd and strictEndInd
%Search Minimums are correspondig to SelectedInd
%first way using FrontsN
strictStInd=SelectedIndD-FrontsND(SelectedIndD);

%other way more universal
 DiferToNextMin=circshift(MinIndD,-1)-MinIndD;
 DiferToNextMin(end)=0;
 DeltaMinTrek=zeros(trSizeD,1);
 DeltaMinTrek(MinIndD)=DiferToNextMin;
 
 MinSelectedInd=find(MinBoolD|SelectedBoolD);
 Difer=circshift(MinSelectedInd,-1)-MinSelectedInd;
 Difer(end)=0;
 DeltaMinSelectedTrek=zeros(trSizeD,1);
 DeltaMinSelectedTrek(MinSelectedInd)=Difer;
 MinPreSelBool=DeltaMinTrek-DeltaMinSelectedTrek>0;
 MinPreSelInd=find(MinPreSelBool);
 
 %searach Minimums after SelectedInd
 DeltaMinTrek(not(MinPreSelBool))=0;
 MinAfterSelInd=MinPreSelInd+DeltaMinTrek(find(DeltaMinTrek));
 %other way
 strictEndInd=SelectedIndD+DeltaMinSelectedTrek(SelectedIndD); % in difer/DeltaMinSelectedTrek contains distances in points to next minimum/SelectedInd
 


%strictEndInd=SelectedInd+Tail
%% ====== PeakOnFront Search
%Searching peaks on front of selected pulses
%These are points on front where are minimums of trek derivation

% 
% 
% 
% 
% 
% % search trek derivation minimums
% trD=diff(trek,1);
% trD(end+1)=0;
% trD(MaxInd)=0;
% trD(MinInd)=0;
% trDR=circshift(trD,1);
% trDL=circshift(trD,-1);
% trDMinBool=trD<trDL&trD<trDR;
% trDMinInd=find(trDMinBool);
% 
% %Select from trDMinInd points whith large enough front length and high
% PeakOnFrontInd=trDMinInd;
% PeakOnFrontInd=PeakOnFrontInd(FrontsHigh(PeakOnFrontInd)>Threshold);
% PeakOnFrontInd=PeakOnFrontInd(trek(PeakOnFrontInd)>Threshold);
% PeakOnFrontBool=false(trSize,1);
% PeakOnFrontBool(PeakOnFrontInd)=true;
% PeakOnFrontBool(SelectedInd)=false;
% PeakOnFrontInd=find(PeakOnFrontBool);
% 
% PeakOnFrontBool=PeakOnFrontBool|MinPreSelBool|SelectedBool;
% PeakOnFrontInd=find(PeakOnFrontBool);
% Difer=PeakOnFrontInd-circshift(PeakOnFrontInd,1);
% if ~isempty(Difer)
%     Difer(1)=0;
% end;
% PeakOnFrontInd=PeakOnFrontInd(Difer>TrekSet.STP.FrontN/3);
% PeakOnFrontBool=false(trSize,1);
% PeakOnFrontBool(PeakOnFrontInd)=true;
% PeakOnFrontBool(MinInd)=false;
% PeakOnFrontBool(SelectedInd)=false;
% PeakOnFrontInd=find(PeakOnFrontBool);
% 
% PeakOnFrontBool=PeakOnFrontBool|SelectedBool;
% PeakOnFrontInd=find(PeakOnFrontBool);
% Difer=circshift(PeakOnFrontInd,-1)-PeakOnFrontInd;
% if ~isempty(Difer)
%     Difer(end)=0;
% end;
% PeakOnFrontInd=PeakOnFrontInd(Difer>TrekSet.STP.FrontN/3);
% PeakOnFrontBool=false(trSize,1);
% PeakOnFrontBool(PeakOnFrontInd)=true;
% PeakOnFrontBool(SelectedInd)=false;
% PeakOnFrontInd=find(PeakOnFrontBool);
% PeakOnFrontN=numel(PeakOnFrontInd);
% 
% SelectedBool=SelectedBool|PeakOnFrontBool;
% SelectedInd=find(SelectedBool);
% SelectedN=numel(SelectedInd);

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

SelectedIndD=SelectedIndD-STPD.MaxInd+TrekSet.STP.MaxInd;
TrekSet.SelectedPeakInd=SelectedIndD;
TrekSet.SelectedPeakFrontN=FrontsND(SelectedIndD);
TrekSet.PeakOnFrontInd=[];
TrekSet.LongFrontInd=[];
TrekSet.strictStInd=strictStInd;
TrekSet.strictEndInd=strictEndInd;

% ZeroFrontInd=find(TrekSet.SelectedPeakFrontN==0);
% TrekSet.SelectedPeakInd(ZeroFrontInd)=[];
% TrekSet.SelectedPeakFrontN(ZeroFrontInd)=[];


%% ===== End information
if EndOut %to avoid statistic typing in short calls
    fprintf('=====  Search of peak tops      ==========\n');
    fprintf('The number of measured points  = %7.0f during %7.0f us \n',trSize,trSize*TrekSet.tau);
    fprintf('Threshold is %3.1f*%5.3f = %5.3f \n',ThresholdD/StdValD,StdValD,ThresholdD);
    fprintf('OverSt is %3.1f\n',OverSt);
    fprintf('The total number of maximum = %7.0f \n',MaxND);
    fprintf('The number of selected peaks = %7.0f \n',SelectedN);
%    fprintf('The number peaks selected on Front= %7.0f \n',PeakOnFrontN);
    fprintf('>>>>>>>>>>>>>>>>>>>>>>Search by Front Finished\n');
end;
%%
toc;
%% end plot
 if TrekSet.Plot&&EndOut
   figure;
   plot(TrekSet.trek);
   s='trek';
   grid on; hold on;
   if not(isempty(SelectedIndD))
       plot(SelectedIndD,TrekSet.trek(SelectedIndD),'.r');
       s=char(s,'SelectedInd');
   end;
%    if not(isempty(PeakOnFrontInd))
%        plot(PeakOnFrontInd,trek(PeakOnFrontInd),'db');
%        s=char(s,'OnFront');
%    end;
   warning off; 
   legend(s);
   warning on;
      pause;
%        close(gcf);
 end;





