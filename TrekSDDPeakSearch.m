function TrekSet=TrekSDDPeakSearch(TrekSetIn,EndOut)

tic;
disp('>>>>>>>>TrekPeakSearch started');

TrekSet=TrekSetIn;


if nargin<2
    EndOut=true;
end;





OverSt=TrekSet.OverSt;

%% working with trek
% trek=TrekSet.trek;
% It's important to correct find first marker so we will work with on
% corrected base line. For trek before first pulse or with low count rate
% it will be good (may be)
trek=TrekSet.trek-smooth(TrekSet.trek,10001);
StdVal=TrekSet.StdVal;
trSize=TrekSet.size;





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
 DoubledFrontN=MaxInd-circshift(MinInd,1);
 DoubledFrontN(1)=FrontN(1);
 
 FrontHigh=trek(MaxInd)-trek(MinInd);
 DoubledFrontHigh=trek(MaxInd)-trek(circshift(MinInd,1));
 DoubledFrontHigh(1)=FrontHigh(1);
%  TripleFrontHigh=trek(MaxInd)-trek(circshift(MinInd,2));
%  TripleFrontHigh(1:2)=DoubledFrontHigh(1:2);
%  QuadFrontHigh=trek(MaxInd)-trek(circshift(MinInd,3));
%  QuadFrontHigh(1:3)=TripleFrontHigh(1:3);
 TailHigh=trek(MaxInd(1:end-1))-trek(MinInd(2:end));
%  for i=0:5
%      tt(i+1,:)=trek(circshift(MaxInd,-i))-trek(MinInd);
%  end;
 clear trL trR;

%% working with special diferential
trLongD=TrekSet.trek-circshift(TrekSet.trek,TrekSet.STP.FrontN);

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
 
%% ========= Thresholds determenation
if isfield(TrekSet,'Threshold')
    Threshold=TrekSet.Threshold;
else
    Threshold=[];
end;

if isfield(TrekSet,'ThresholdFront')
    ThresholdFront=TrekSet.ThresholdFront;
else
    ThresholdFront=[];
end;

if isfield(TrekSet,'ThresholdN')
    ThresholdN=TrekSet.ThresholdN;
else
    ThresholdN=[];
end;

if isfield(TrekSet,'ThresholdD')
    ThresholdD=TrekSet.ThresholdD;
else
    ThresholdD=[];
end;

if isfield(TrekSet,'ThresholdFrontD')
    ThresholdFrontD=TrekSet.ThresholdFrontD;
else
    ThresholdFrontD=[];
end;


if isfield(TrekSet,'ThresholdND')
    ThresholdND=TrekSet.ThresholdND;
else
    ThresholdND=[];
end;

if isempty(Threshold)||isempty(ThresholdD)||isempty(ThresholdN)||isempty(ThresholdND)
    tabTrek=HistOnNet(trek,[-2047.5:2047.5]);
    tabFrontHigh=HistOnNet(FrontHigh,[-2047.5:2047.5]);
    tabTailHigh=HistOnNet(TailHigh,[-2047.5:2047.5]);
    tabFrontN=tabulateSid(FrontN);
    tabTailN=tabulateSid(TailN);
    
    tabTrekD=HistOnNet(trekD,[-2047.5:2047.5]);
    tabFrontHighD=HistOnNet(FrontHighD,[-2047.5:2047.5]);
    tabTailHighD=HistOnNet(TailHighD,[-2047.5:2047.5]);
    tabFrontND=tabulateSid(FrontND);
    tabTailND=tabulateSid(TailND);

    figure;
    h1=subplot(2,2,1);
        grid on; hold on;
        set(gca,'YScale','log');
        plot(tabTrek(:,1),tabTrek(:,2),'k');
        plot(tabTailHigh(:,1),tabTailHigh(:,2),'.b-');
        plot(tabFrontHigh(:,1),tabFrontHigh(:,2),'.r-');
        legend('trek','Tail High','Front High');
    h2=subplot(2,2,2);
        grid on; hold on;
        set(gca,'YScale','log');
        plot(tabFrontN(:,1),tabFrontN(:,2),'.r-');
        plot(tabTailN(:,1),tabTailN(:,2),'.b-');
        legend('FrontN','TailN');
    h3=subplot(2,2,3);
        grid on; hold on;
        set(gca,'YScale','log');
        plot(tabTrekD(:,1),tabTrekD(:,2),'k');
        plot(tabTailHighD(:,1),tabTailHighD(:,2),'.b-');
        plot(tabFrontHighD(:,1),tabFrontHighD(:,2),'.r-');
        legend('trekD','TailHighD','FrontHighD');
    h4=subplot(2,2,4);
        grid on; hold on;
        set(gca,'YScale','log');
        plot(tabFrontND(:,1),tabFrontND(:,2),'.r-');
        plot(tabTailND(:,1),tabTailND(:,2),'.b-');
        legend('FrontND','TailND');
   
    ch='a';
    while ~isempty(ch)
       
       T=input('Input Threshold (for trek Amplitude) ');
       if ~isempty(T)
           Threshold=T;
       end;
       axes(h1);
       
       h=findobj('tag','ThrLine');
       if ~isempty(h)&&ishandle(h)
           delete(h);
       end;
       h=findobj('tag','ThrLine1');
       if ~isempty(h)&&ishandle(h)
           delete(h);
       end;
       plot([Threshold,Threshold],[1,max(tabTrek(:,2))],'k','LineWidth',2,'tag','ThrLine');
       plot([-Threshold,-Threshold],[1,max(tabTrek(:,2))],'k','LineWidth',2,'tag','ThrLine1');
       
       T=input('Input Threshold (for Pulse Front High) ');
       if ~isempty(T)
           ThresholdFront=T;
       end;

       axes(h1);
       
       h=findobj('tag','ThrFLine');
       if ~isempty(h)&&ishandle(h)
           delete(h);
       end;
       plot([ThresholdFront,ThresholdFront],[1,max([max(tabFrontHigh(:,2));max(tabTailHigh(:,2))])],'m','LineWidth',2,'tag','ThrFLine');

       T=input('Input ThresholdN (for pulse front duration in N) ');
       if ~isempty(T)
           ThresholdN=T;
       end;
     
       axes(h2);
       h=findobj('tag','ThrNLine');
       if ~isempty(h)&&ishandle(h)
           delete(h);
       end;

       plot([ThresholdN,ThresholdN],[1,max([max(tabFrontN(:,2));max(tabTailN(:,2))])],'k','LineWidth',2,'tag','ThrNLine');


       
       
       T=input('Input ThresholdD (for trekD Amplitude) ');
       if ~isempty(T)
           ThresholdD=T;
       end;
       axes(h3);
       
       h=findobj('tag','ThrDLine');
       if ~isempty(h)&&ishandle(h)
           delete(h);
       end;
       h=findobj('tag','ThrDLine1');
       if ~isempty(h)&&ishandle(h)
           delete(h);
       end;
       plot([ThresholdD,ThresholdD],[1,max(tabTrekD(:,2))],'k','LineWidth',2,'tag','ThrDLine');
       plot([-ThresholdD,-ThresholdD],[1,max(tabTrekD(:,2))],'k','LineWidth',2,'tag','ThrDLine1');
       
       
       
       
       T=input('Input ThresholdFrontD (for diff Pulse Front High) ');
       if ~isempty(T)
           ThresholdFrontD=T;
       end;

       axes(h3);
              h=findobj('tag','ThrFrDLine');
       if ~isempty(h)&&ishandle(h)
           delete(h);
       end;
       plot([ThresholdFrontD,ThresholdFrontD],[1,max([max(tabFrontHighD(:,2));max(tabTailHighD(:,2))])],'m','LineWidth',2,'tag','ThrFrDLine');

       T=input('Input ThresholdND (for diff pulse front duration in N) ');
       if ~isempty(T)
           ThresholdND=T;
       end;

       axes(h4);
       h=findobj('tag','ThrNDLine');
       if ~isempty(h)&&ishandle(h)
           delete(h);
       end;
       plot([ThresholdND,ThresholdND],[1,max([max(tabFrontND(:,2));max(tabTailND(:,2))])],'k','LineWidth',2,'tag','ThrNDLine');
       ch=input('If not empty input of Thresholds will be repeated \n','s');
    end;
end
%% ======= Special trek constructing trek
FrontsN=zeros(trSize,1);
FrontsHigh=zeros(trSize,1);

%additional condition to avoid long tails/fronts for reset pulses
Ind= trek(MaxInd)<TrekSet.MaxSignal;
FrontNMax=max(FrontN(Ind));
Ind=find(trek(MinInd)>TrekSet.MinSignal);
Ind=Ind-1; %TailN corresponds to previous Maximum 
Ind=Ind(Ind>=1&Ind<MinN); %< becuase TailN contains MinN-1 elements
TailNMax=max(TailN(Ind));

% TailNMax=max(TailN(trek(MinInd(2:end))>-Threshold));
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

DoubledFrontsN=zeros(trSize,1);
DoubledFrontsHigh=zeros(trSize,1);

%additional condition to avoid long tails/fronts for reset pulses
Ind= trek(MaxInd)<TrekSet.MaxSignal;
DoubledFrontNMax=max(DoubledFrontN(Ind));

for i=1:DoubledFrontNMax
    Ind=find(DoubledFrontN>=i);
    Ind(MinInd(Ind)+i>trSize)=[];
    DoubledFrontsN(MinInd(Ind)+i)=i;
    DoubledFrontsHigh(MinInd(Ind)+i)=trek(MinInd(Ind)+i)-trek(MinInd(Ind));
end;

%% ======= Special trek constructing diff
FrontsND=zeros(trSizeD,1);
FrontsHighD=zeros(trSizeD,1);

FrontNMaxD=max(FrontND(FrontHighD>1));
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
% ThresholdD=mean(FrontsHighD(FrontsHighD>0))*OverSt;

%% search markers by trek
SelectedBool=MaxBool&trLongD>Threshold&(FrontsHigh>ThresholdFront|DoubledFrontsHigh>ThresholdFront);
SelectedInd=find(SelectedBool);
SelectedN=numel(SelectedInd);

%% ============ STP for diff trek
STPD=StpStruct([TrekSet.STP.TimeInd(1:end-1)+0.5,diff(TrekSet.STP.FinePulse)]);

%% ============ Search Markers by diff
%SelectedBool=ByFrontBool|PeakOnFrontBool|ByHighBool|LongFrontBool;
% Fixed FrontN because diff of STP has flat part on front
SelectedBoolD=MaxBoolD&trekD>ThresholdD&FrontsHighD>ThresholdFrontD&FrontsND>ThresholdND;


% SelectedBool(trSize-OnTailN:end)=false; %not proccessing tail
SelectedIndD=find(SelectedBoolD);

SelectedIndD=SelectedIndD((SelectedIndD-STPD.MaxInd+TrekSet.STP.MaxInd)>=1&(SelectedIndD-STPD.MaxInd+TrekSet.STP.MaxInd)<=TrekSet.size);
SelectedIndD=SelectedIndD(TrekSet.trek(SelectedIndD-STPD.MaxInd+TrekSet.STP.MaxInd)>Threshold);
SelectedBoolD=false(trSizeD,1);
SelectedBoolD(SelectedIndD)=true;
SelectedND=numel(SelectedIndD);
%% ============= Merging SelectedInd and SelectedIndD
CombineBool=SelectedBool|[SelectedBoolD;false];
CombineInd=find(CombineBool);
DiferCombine=CombineInd-circshift(CombineInd,1); %array with distanse to previous marker
DiferCombine(1)=0;
DiferSelected=SelectedInd-circshift(SelectedInd,1);
DiferSelected(1)=0;


trekCombine=zeros(trSize,1);
trekSelected=trekCombine;
trekCombine(CombineInd)=DiferCombine;
trekSelected(SelectedInd)=DiferSelected;

Ind=find((trekCombine(SelectedInd)-trekSelected(SelectedInd))==0); % SelectedInd are markers on ends of fronts. Every front (which satisfy conditions) must have SelectedIndD
Ind=SelectedInd(Ind);                    % so distance to previous SelectedInd (end of front ) must be greater then distance to previous SelectedIndD (marker on front)
                                         % and difference must be negative
                                         % if difference is equale zero,
                                         % this means SelectedIndD is
                                         % skipped

% This method gives bad result. Marker may not to be in right position
% Dist=mean(trekCombine(SelectedInd)); %mean distance between trek marker and correspond (previous) diff marker
% SelectedBoolD(Ind-round(Dist))=true;

Ind=Ind(Ind<trSize); %to avoid bad index for trekD (trSizeD=trSize-1)
for i=1:numel(Ind) %must be not many such points
    [m,IndD]=max(trekD(Ind(i)-FrontsN(Ind(i)):Ind(i)));
    SelectedBoolD(Ind(i)-FrontsN(Ind(i))+IndD-1)=true;
end;
SelectedIndD=find(SelectedBoolD);
SelectedND=numel(SelectedIndD);

%% search strictStInd and strictEndInd
%Search Minimums are correspondig to SelectedInd
%first way using FrontsN
% strictStInd=SelectedIndD-FrontsND(SelectedIndD);
strictStInd=SelectedIndD-abs(FrontsN(SelectedIndD)); %now take not Minimum in trekD, but Minimum in trek 
%For plasma trek SelectedIndD can be in Minimum point of trek (after trek
%merging and combining). So (abs) start Strict point will be in good
%position

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
 
DiferStrict=strictEndInd-strictStInd;
Ind=DiferStrict<10;
strictEndInd(Ind)=strictStInd(Ind)+10;
Ind=DiferStrict>TrekSet.STP.FrontN;
strictEndInd(Ind)=strictStInd(Ind)+TrekSet.STP.FrontN;

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

TrekSet.Threshold=Threshold;
TrekSet.ThresholdFront=ThresholdFront;
TrekSet.ThresholdN=ThresholdN;
TrekSet.ThresholdD=ThresholdD;
TrekSet.ThresholdFrontD=ThresholdFrontD;
TrekSet.ThresholdND=ThresholdND;
SelectedPeakFrontN=FrontsN(SelectedIndD)-STPD.MaxInd+TrekSet.STP.MaxInd;
SelectedIndD=SelectedIndD-STPD.MaxInd+TrekSet.STP.MaxInd;
TrekSet.SelectedPeakInd=SelectedIndD;
TrekSet.SelectedPeakFrontN=SelectedPeakFrontN;
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





