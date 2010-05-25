function TrekSet=TrekTops(TrekSetIn,Plot,trProcessBool)
%Description see Tops.m
%All differences are in input part and at the end of procces
%TrekSet.**Ind=PeakSetInd
TrekSet=TrekSetIn;


Time=[];
tic;

Text  = false;    % switch between text and bin files
HistCalc =true;  % switch histogram analysis for threshold determination
tau=0.020;        % us digitizing time
MinFront=0.05;    % minimal peak front, us
MaxFront=0.125;   % maximal peak front, us
MinTail=0.05;     % minimal peak tail, us
MaxTail=0.8;      % maximal peak tail, us
OverSt=4;       % noise regection threshold, in standard deviations

MaxSignal= 3700;  % maximal signal whithout distortion
notProcessTail=8; % number of points after exceeding of Maxsignal, which will'nt be processed

StandardPulseFile='D:\!SCN\EField\StandPeakAnalys\StPeak20ns_2.dat';


disp('>>>>>>>>TrekTops.m started'); 

tr=TrekSet.trek;

if nargin<2; Plot=true; end;


if nargin<3|isempty(trProcessBool);
    trProcessBool=logical(ones(size(tr)));
    
    trProcessBool=tr<MaxSignal;
    for i=1:notProcessTail
        trProcessBoolSh=circshift(trProcessBool,1);
        trProcessBoolSh(1)=true;
        trProcessBool=trProcessBool&trProcessBoolSh;
    end;
    clear trProcessBoolSh;
end;

MaxFrontN=round(MaxFront/tau); MaxTailN=round(MaxTail/tau);
MinFrontN=round(MinFront/tau); MinTailN=round(MinTail/tau);


trSize=size(tr,1);
%================ section 1 ==============
% catch signal fronts:
Time(end+1)=toc;
tic;
trD=diff(tr);     trD(end+1)=trD(end);

% BaseD=(circshift(trD,-2)+circshift(trD,-1)+circshift(trD,+1)+circshift(trD,+2))/4;
% trD=trD-BaseD;

trDD=diff(tr,2);  trDD(end+1:end+2)=trDD(end);
trF=-trD.^2.*trDD/100000;  % tops of trF are very sensitive to peak front !!!
% BaseF=(circshift(trF,-2)+circshift(trF,-1)+circshift(trF,+1)+circshift(trF,+2))/4;
% trF=trF-BaseF;

%catch signal tails: 
trL1=circshift(tr,-1); trL2=circshift(tr,-2); 
trL3=circshift(tr,-3); trL4=circshift(tr,-4);
trR1=circshift(tr,1);
TailBool=tr>trR1&tr>trL1&trL1>trL2&trL2>trL3&trL3>trL4;
TailBool(1)=false;  TailBool(end-4:end)=false;
clear trL1 trL2 trL3 trL4 trR1;


% Mark all trF tops which correspond to peak fronts:
PosFBool=(trF>0)&(trF>circshift(trF,1))&(trF>circshift(trF,2))&(trF>circshift(trF,-2))&(trF>circshift(trF,-1));
PosFBool(1:2)=false;  PosFBool(end-1:end)=false;

NegFBool=(trF<circshift(trF,1))&(trF<circshift(trF,2))&(trF<circshift(trF,-2))&(trF<circshift(trF,-1));
NegFBool(1:2)=false;  NegFBool(end-1:end)=false;
% 
% % additional criterion for the fronts of real peaks:
% trFA=abs(trF);
% AbsFBool=(trFA>circshift(trFA,1))&(trFA>circshift(trFA,2))&(trFA>circshift(trFA,-2))&(trFA>circshift(trFA,-1));
% AbsFBool(1:2)=false;  AbsFBool(end-1:end)=false;
% 
% % separation signal and noises: 
% PeakFBool=PosFBool&AbsFBool;            %Signals
% NoiseFBool=not(AbsFBool)&PosFBool;   %Noise

[MeanVal,StdVal,PeakPolarity,Noise]=MeanSearchF(trF,3,0);
% PeakPolarity must be ==1; %
    PeakFBool=(PosFBool&not(Noise)&(trF>0));
    NoiseFBool=(PosFBool&Noise)|(NegFBool&Noise&trF>-StdVal);

%PeakFBool=PeakFBool&not(Noise); 


% Searching the threshould for extraction real signals from PeakFBool
% Signal and noise distributions of trF:
LogFNoise=log10(0.0001*StdVal+abs(trF(NoiseFBool))); 
LogFPeak=log10(trF(PeakFBool));
LogNegFBool=log10(0.0001*StdVal-trF(NegFBool));

[HistLogFNoise,HistLogFNoiseI,HistLogFNoiseS]=sid_hist(LogFNoise);
[HistLogFPeak,HistLogFPeakI,HistLogFPeakS]=sid_hist(LogFPeak);
[HistLogNegFBool,HistLogNegFBoolI,HistLogNegFBoolS]=sid_hist(LogNegFBool);
MaxHistLogFI=max(HistLogFNoiseI, HistLogFPeakI);
HistLogFNoise(:,2)=MaxHistLogFI.*HistLogFNoise(:,2)./HistLogFNoiseI;
HistLogFPeak(:,2)=MaxHistLogFI.*HistLogFPeak(:,2)./HistLogFPeakI;

HistFInterpStart=min(HistLogFNoise(1,1),HistLogFPeak(1,1));
HistFInterpEnd=max(HistLogFNoise(end,1),HistLogFPeak(end,1));
HistFInterpStep=min(HistLogFNoiseS,HistLogFPeakS);
HistFInterp(:,1)=HistFInterpStart:HistFInterpStep:HistFInterpEnd;
HistFInterp(:,2)=interp1(HistLogFNoise(:,1),HistLogFNoise(:,2),HistFInterp(:,1),'linear',1);
HistFInterp(:,3)=interp1(HistLogFPeak(:,1),HistLogFPeak(:,2),HistFInterp(:,1),'linear',1);
HistFFunc=HistFInterp(:,3)./HistFInterp(:,2);


% Search threshold:
[MaxNoiseHist,MaxNoiseHistInd]=max(HistFInterp(:,2));
AboveNoise=HistFInterp(:,3)>=HistFInterp(:,2);
AboveNoise(1:MaxNoiseHistInd)=false; 
AboveNoiseInd=find(AboveNoise);
NoiseBorderLowInd=find(AboveNoise,1,'first');
NoiseBorderHighInd=find(not(AboveNoise),1,'last');
ThresholdF=(HistFInterp(NoiseBorderLowInd,1)+HistFInterp(NoiseBorderHighInd,1))/2;
if isempty(ThresholdF)
   if isempty(NoiseBorderLowInd)
       ThresholdF=HistFInterp(NoiseBorderHighInd,1);
   end;
   if isempty(NoiseBorderHighInd)
       ThresholdF=HistFInterp(NoiseBorderLowInd,1);
   end;
end; 
ThresholdF=10^ThresholdF;    % Threshold for separation F signal and noise.

%mark all selected signal tops and expected tops in signal fronts: 
%FBool=PosFBool&trF>ThresholdF;
FBool=PeakFBool&trF>ThresholdF;
FInd=find(FBool); FIndN=size(FInd,1);
PeakFInd=zeros(FIndN,1);
PeakSet.PeakOnFrontInd=[];
for i=1:FIndN-1
    y=tr(FInd(i):FInd(i+1)-1); 
    yR=tr(FInd(i)+1:FInd(i+1)); yL=tr(FInd(i)-1:FInd(i+1)-2);
    FindMax=find(y>=yR&y>yL,1,'first');
    if isempty(FindMax) % then a peak on the front or tail is expected
%         y=trD(FInd(i):FInd(i+1)-1); 
%         yR=trD(FInd(i)+1:FInd(i+1)); yL=trD(FInd(i)-1:FInd(i+1)-2);
%         FindMax=find(abs(y)<abs(yR)&abs(y)<=abs(yL),1,'first');
%         if not(isempty(FindMax)); 
%             D1=(trD(FInd(i)+FindMax-1)-trD(FInd(i)+FindMax-2));
%             D2=(trD(FInd(i)+FindMax)-trD(FInd(i)+FindMax-1));
%             if (D1>0&&D2>0)||(D1<0&&D2<0) 
               FindMax=find(trDD(FInd(i):FInd(i+1)-1)>0,1,'first');
%             end;
%         end;
%         if isempty(FindMax); 
%             [Miny,FindMax]=min(abs(y)); 
%         end;
       if not(isempty(FindMax));
        PeakSet.PeakOnFrontInd=[PeakSet.PeakOnFrontInd;FInd(i)+FindMax-1];
       end;
    end;
    if not(isempty(FindMax));
      PeakFInd(i)=FInd(i)+FindMax-1;
    end;
end;
y=tr(FInd(end):end-1);
yR=tr(FInd(end)+1:end);yL=tr(FInd(end)-1:end-2);
FindMax=find(y>=yR&y>yL,1,'first');
if isempty(FindMax)
    y=trD(FInd(end):end-1); 
    yR=trD(FInd(end)+1:end); yL=trD(FInd(end)-1:end-2);
    FindMax=find(y<yR&y<=yL,1,'first');
    if isempty(FindMax); [Miny,FindMax]=min(abs(y)); end;
    PeakSet.PeakOnFrontInd=[PeakSet.PeakOnFrontInd;FInd(end)+FindMax-1];
end;

PeakFInd(FIndN)=FInd(FIndN)+FindMax-1;
PeakFInd(PeakFInd<=3|PeakFInd>=trSize-2)=[];
PeakFBool=false(trSize,1);
PeakFBool(PeakFInd)=true;
PeakFIndN=size(PeakFInd,1);

NoiseFBool=not(PeakFBool)&PosFBool;   %Noise
NoiseFInd=find(NoiseFBool); 
NoiseFInd(NoiseFInd<=3|NoiseFInd>=trSize-2)=[];
NoiseFIndN=size(NoiseFInd,1); 

clear trDD trFA AllBool PosFBool FBool AbsFBool NoiseFBool...
      BoolInd bool LogFNoise LogFPeak FInd NoiseInd  ...
      MaxFrontDiff MaxTailDiff Interval FindMax;
Time(end+1)=toc;
disp(['Section 1 time=', num2str(Time(end))]);
  
%================ section 2 ==============  
tic;

[MeanVal,StdVal,PeakPolarity,Noise]=MeanSearch(tr,3,0);
ThresholdStd=StdVal*OverSt;

trR1=circshift(tr,1);  trR1(1)=trR1(2);
trR2=circshift(tr,2);  trR2(1)=trR2(3); trR2(2)=trR2(3);
trL1=circshift(tr,-1); trL1(end)=trL1(end-1);
trL2=circshift(tr,-2); trL2(end)=trL2(end-2); trL2(end-1)=trL2(end-2);
% search all peaks in tr:
MaxIndN=size(find(tr>trR1&tr>=trL1),1);

%5-points noise analysis
% noise like: /\/\
NoiseMInd=find(tr<trR1&tr<trL1&trL2<trL1&trR2<trR1);
NoiseMInd(NoiseMInd<=3|NoiseMInd>=trSize-2)=[];
NoiseMIndN=size(NoiseMInd,1);
% noise like: \/\/
NoiseWInd=find(tr>trR1&tr>trL1&trL2>trL1&trR2>trR1); %&tr>trL2
NoiseWInd(NoiseWInd<=3|NoiseWInd>=trSize-2)=[];
NoiseWIndN=size(NoiseWInd,1);
% PeakF like \/\/ among NoiseW
PeakWInd=find(tr>trR1&tr>trL1&trL2>trL1&trR2>trR1&PeakFBool); %&tr>trL2
PeakWInd(PeakWInd<=3|PeakWInd>=trSize-2)=[];
PeakWIndN=size(PeakWInd,1);
% %Noises like signals and signals:
% NoiseSInd=find(tr>trR1&trR1>trR2&tr>trL1&trL1>trL2);
% NoiseSInd(NoiseSInd<=3|NoiseSInd>=trSize-2)=[];NoiseSIndN=size(NoiseSInd,1);
%Expected signals: //\
SignalBool=tr>trR1&trR1>trR2&tr>=trL1; %&trL1>trL2; (otherwise the peak may be hidden by the next one)
SignalBool(1:3)=false; SignalBool(end-1:end)=false;
SignalBool(NoiseMInd)=false;  SignalBool(NoiseWInd)=false; 
SignalInd=find(SignalBool); SIndN=size(SignalInd,1);

Time(end+1)=toc;
disp(['Section 2 time=', num2str(Time(end))]);

%3. ====== Combination ====================
tic;
PeakBool=PeakFBool&SignalBool;
PeakBool=PeakBool&trProcessBool;

PeakInd=find(PeakBool); 
PeakInd=[PeakInd;PeakSet.PeakOnFrontInd];  
PeakInd=sort(PeakInd);
PeakIndN=size(PeakInd,1);
PeakOnFrontIndN=size(PeakSet.PeakOnFrontInd,1);

Time(end+1)=toc;
disp(['Combination time=', num2str(Time(end))]);

tic;
PeakIndN=size(PeakInd,1);
RangePeak=zeros(1, PeakIndN);
for i=1:PeakIndN 
    IndMax=min([size(tr,1),PeakInd(i)+2]);
    IndMin=max([1,PeakInd(i)-2]);
    y=tr(IndMin:IndMax);    RangePeak(i)=log10(tr(PeakInd(i))-min(y));
end;
clear IndMax IndMin;
Time(end+1)=toc;
% disp(['RangePeak calculation=', num2str(Time(end))]);
toc;

if HistCalc
tic;

HistStart =1e20;  HistEnd= -1e20;
HistInterpStart=1e20;
HistInterpEnd=-1e20;
HistInterpStep=1e20;
MaxHistInterpI=-1e20;

RangeM=zeros(1, NoiseMIndN);
for i=1:NoiseMIndN 
    y=tr(NoiseMInd(i)-3:NoiseMInd(i)+2); RangeM(i)=log10(max(y)-min(y));
end;
if not(isempty(RangeM)); 
    HistStart=min(HistStart,min(RangeM)); 
    HistEnd=max(HistEnd,max(RangeM));  
    [HistRangeM,HistRangeMI,HistRangeMS]=sid_hist(RangeM);
    HistInterpStart=HistRangeM(1,1);
    HistInterpEnd=HistRangeM(end,1);
    HistInterpStep=HistRangeMS;
    MaxHistInterpI=HistRangeMI;
end;



RangeW=zeros(1, NoiseWIndN);
for i=1:NoiseWIndN 
    y=tr(NoiseWInd(i)-3:NoiseWInd(i)+2); RangeW(i)=log10(max(y)-min(y));
end;
if not(isempty(RangeW)); 
    HistStart=min(HistStart,min(RangeW)); 
    HistEnd=max(HistEnd,max(RangeW));  
    [HistRangeW,HistRangeWI,HistRangeWS]=sid_hist(RangeW);
    HistInterpStart=min(HistInterpStart,HistRangeW(1,1));
    HistInterpEnd=max(HistInterpEnd,HistRangeW(end,1));
    HistInterpStep=min(HistInterpStep,HistRangeWS);
    MaxHistInterpI=max(MaxHistInterpI,HistRangeWI);
end;



RangePeakW=zeros(1, PeakWIndN);
for i=1:PeakWIndN 
    y=tr(PeakWInd(i)-3:PeakWInd(i)+2); RangePeakW(i)=log10(max(y)-min(y));
end;
if not(isempty(RangePeakW)); 
    HistStart=min(HistStart,min(RangePeakW)); 
    HistEnd=max(HistEnd,max(RangePeakW));  
   [HistRangePeakW,HistRangePeakWI,HistRangePeakWS]=sid_hist(RangePeakW);
    HistInterpStart=min(HistInterpStart,HistRangePeakW(1,1));
    HistInterpEnd=max(HistInterpEnd,HistRangePeakW(end,1));
    HistInterpStep=min(HistInterpStep,HistRangePeakWS);
    MaxHistInterpI=max(MaxHistInterpI,HistRangePeakWI);
end;

% Histogram of the range of noise F signals:
RangeNoiseF=zeros(1,NoiseFIndN);
for i=1:NoiseFIndN 
    y=tr(NoiseFInd(i)-3:NoiseFInd(i)+2); RangeNoiseF(i)=log10(max(y)-min(y));
end;
if not(isempty(RangeNoiseF)); 
    [HistRangeNoiseF,HistRangeNoiseFI,HistRangeNoiseFS]=sid_hist(RangeNoiseF);
    HistInterpStart=min(HistInterpStart,HistRangeNoiseF(1,1));
    HistInterpEnd=max(HistInterpEnd,HistRangeNoiseF(end,1));
    HistInterpStep=min(HistInterpStep,HistRangeNoiseFS);
    MaxHistInterpI=max(MaxHistInterpI,HistRangeNoiseFI);
end;


RangeS=zeros(1, SIndN);
for i=1:SIndN 
    y=tr(SignalInd(i)-3:SignalInd(i)+2);   %RangeS(i)=log10(max(y)-min(y));
    RangeS(i)=log10(tr(SignalInd(i))-min(y));
end;
if not(isempty(RangeS)); 
    HistStart=min(HistStart,min(RangeS)); 
    HistEnd=max(HistEnd,max(RangeS));  
    [HistRangeS,HistRangeSI,HistRangeSS]=sid_hist(RangeS);
    HistInterpStart=min(HistInterpStart,HistRangeS(1,1));
    HistInterpEnd=max(HistInterpEnd,HistRangeS(end,1));
    HistInterpStep=min(HistInterpStep,HistRangeSS);
    MaxHistInterpI=max(MaxHistInterpI,HistRangeSI);
end;


RangePeakF=zeros(1, PeakFIndN);
for i=1:PeakFIndN 
    y=tr(PeakFInd(i)-3:PeakFInd(i)+2); 
    RangePeakF(i)=log10(tr(PeakFInd(i))-min(y));
end;
if not(isempty(RangePeakF)); 
    [HistRangePeakF,HistRangePeakFI,HistRangePeakFS]=sid_hist(RangePeakF);
    HistInterpStart=min(HistInterpStart,HistRangePeakF(1,1));
    HistInterpEnd=max(HistInterpEnd,HistRangePeakF(end,1));
    HistInterpStep=min(HistInterpStep,HistRangePeakFS);
    MaxHistInterpI=max(MaxHistInterpI,HistRangePeakFI);
end;


PeakInd(PeakInd+3>trSize)=[];  PeakInd(PeakInd-2<1)=[];
%PeakInd(tr(PeakInd)>MaxSignal)=[];

% PeakIndN=size(PeakInd,1);
% RangePeak=zeros(1, PeakIndN);
% for i=1:PeakIndN 
%     y=tr(PeakInd(i)-3:PeakInd(i)+2);    RangePeak(i)=log10(tr(PeakInd(i))-min(y));
% end;

if not(isempty(RangePeak)); 
    HistStart=min(HistStart,min(RangePeak)); 
    HistEnd=max(HistEnd,max(RangePeak));  
    [HistRangePeak,HistRangePeakI,HistRangePeakS]=sid_hist(RangePeak);
    HistInterpStart=min(HistInterpStart,HistRangePeak(1,1));
    HistInterpEnd=max(HistInterpEnd,HistRangePeak(end,1));
    HistInterpStep=min(HistInterpStep,HistRangePeakS);
    MaxHistInterpI=max(MaxHistInterpI,HistRangePeakI);
end;


PeakSet.PeakOnFrontInd(PeakSet.PeakOnFrontInd+2>trSize)=[];  
PeakSet.PeakOnFrontInd(PeakSet.PeakOnFrontInd-2<1)=[];
PeakOnFrontIndN=size(PeakSet.PeakOnFrontInd,1);
RangePeakOnFront=zeros(1, PeakOnFrontIndN);
for i=1:PeakOnFrontIndN 
    y=tr(PeakSet.PeakOnFrontInd(i)-2:PeakSet.PeakOnFrontInd(i)+2);    
    RangePeakOnFront(i)=log10(tr(PeakSet.PeakOnFrontInd(i))-min(y));
end;

if not(isempty(RangePeakOnFront)); 
    [HistRangePeakOnFront,HistRangePeakOnFrontI,HistRangePeakOnFrontS]=sid_hist(RangePeakOnFront);
    HistInterpStart=min(HistInterpStart,HistRangePeakOnFront(1,1));
    HistInterpEnd=max(HistInterpEnd,HistRangePeakOnFront(end,1));
    HistInterpStep=min(HistInterpStep,HistRangePeakOnFrontS);
    MaxHistInterpI=max(MaxHistInterpI,HistRangePeakOnFrontI);
end;

HistRangeM(:,2)=MaxHistInterpI.*HistRangeM(:,2)./HistRangeMI;
HistRangeW(:,2)=MaxHistInterpI.*HistRangeW(:,2)./HistRangeWI;
HistRangeNoiseF(:,2)=MaxHistInterpI.*HistRangeNoiseF(:,2)./HistRangeNoiseFI;
HistRangeS(:,2)=MaxHistInterpI.*HistRangeS(:,2)./HistRangeSI;
HistRangePeakF(:,2)=MaxHistInterpI.*HistRangePeakF(:,2)./HistRangePeakFI;
HistRangePeak(:,2)=MaxHistInterpI.*HistRangePeak(:,2)./HistRangePeakI;
HistRangePeakW(:,2)=MaxHistInterpI.*HistRangePeakW(:,2)./HistRangePeakWI;


HistInterp(:,1)=HistInterpStart:HistInterpStep:HistInterpEnd;
HistInterp(:,2)=interp1(HistRangeM(:,1),HistRangeM(:,2),HistInterp(:,1),'linear',1);
HistInterp(:,3)=interp1(HistRangeW(:,1),HistRangeW(:,2),HistInterp(:,1),'linear',1);
HistInterp(:,4)=interp1(HistRangeNoiseF(:,1),HistRangeNoiseF(:,2),HistInterp(:,1),'linear',1);
HistInterp(:,5)=interp1(HistRangeS(:,1),HistRangeS(:,2),HistInterp(:,1),'linear',1);
HistInterp(:,6)=interp1(HistRangePeakF(:,1),HistRangePeakF(:,2),HistInterp(:,1),'linear',1);
HistInterp(:,7)=interp1(HistRangePeak(:,1),HistRangePeak(:,2),HistInterp(:,1),'linear',1);
HistInterp(:,8)=interp1(HistRangePeakW(:,1),HistRangePeakW(:,2),HistInterp(:,1),'linear',1);
HistInterpFunc=(HistInterp(:,5).*HistInterp(:,6).*HistInterp(:,7))./(HistInterp(:,2).*HistInterp(:,3).*HistInterp(:,4).*HistInterp(:,8));

[MaxPeakHist,MaxPeakHistInd]=max(HistInterp(:,8));

Time(end+1)=toc;
disp(['Histograms calculation time=', num2str(Time(end))]);
tic;

 % Threshold:
 %NoiseHist=(Hist(:,2)+Hist(:,3))/2;
 [MaxPeakHist,MaxPeakHistInd]=max(HistInterp(:,7));
 %[MaxNoiseHist,MaxNoiseHistInd]=max(NoiseHist);
 %AboveNoise=Hist(:,7)>=NoiseHist; 
 AboveNoise=HistInterp(:,7)>HistInterp(:,8); 
 [MaxNoiseHist,MaxNoiseHistInd]=max(HistInterp(:,8));
 AboveNoise(1:MaxNoiseHistInd)=false; 
 AboveNoiseInd=find(AboveNoise);
 NoiseBorderLowInd=find(AboveNoise,1,'first');
 NoiseBorderHighInd=find(not(AboveNoise),1,'last');
 %Threshold=(Hist(NoiseBorderLowInd,1)+Hist(NoiseBorderHighInd,1))/2;
 Threshold1=HistInterp(NoiseBorderLowInd,1);
 if isempty(Threshold1)
    if isempty(NoiseBorderLowInd)
        Threshold1=HistInterp(NoiseBorderHighInd,1);
    end;
    if isempty(NoiseBorderHighInd)
        Threshold1=HistInterp(NoiseBorderLowInd,1);
    end;
 end; 
Threshold1=10^Threshold1;

AboveNoise=HistInterpFunc>1;
NoiseBorderInd=find(HistInterp(:,1)>=log10(OverSt*StdVal),1,'first');
AboveNoise(1:NoiseBorderInd)=false;
NoiseBorderInd=find(AboveNoise,1,'first');
Threshold=HistInterp(NoiseBorderInd,1);
if isempty(Threshold)
    Threshold=log10(OverSt*StdVal);
end;

Threshold=10^Threshold;

Time(end+1)=toc;
disp(['Threshold determination time=', num2str(Time(end))]);
tic;

if Plot
    figure; 
    subplot(2,1,1);
    title(['track noise separation. ThresholdF=',num2str(ThresholdF)]);  
    hold on; grid on; xlabel('log10(trF)');
    plot(HistLogFNoise(:,1),HistLogFNoise(:,2),'-b.'); 
    plot(HistLogFPeak(:,1),HistLogFPeak(:,2),'-g.'); 
    plot(HistLogNegFBool(:,1),HistLogNegFBool(:,2),'-c.');
    plot(HistFInterp(:,1),HistFFunc(:),'-r');
    legend('trF noise','trFsignal','trFNeg','Func', 'Location','NorthWest');
    plot(log10([ThresholdF,ThresholdF]),[0,MaxNoiseHist],'r','LineWidth',2);
    
    subplot(2,1,2);
    title(['Peak noise separation. Threshold=',num2str(Threshold),' Threshold1=',num2str(Threshold1),' Threshold by Std=',num2str(ThresholdStd)]);
    hold on; grid on; xlabel('log10(Range)');
    plot(HistRangeM(:,1),HistRangeM(:,2),'-k.');    
    plot(HistRangeW(:,1),HistRangeW(:,2),'-b.');
    plot(HistRangeNoiseF(:,1),HistRangeNoiseF(:,2),'-c.');
    plot(HistRangeS(:,1),HistRangeS(:,2),'-m.');  
    plot(HistRangePeakF(:,1),HistRangePeakF(:,2),'-r.');
    plot(HistRangePeak(:,1),HistRangePeak(:,2),'-g.');
    plot(HistRangePeakW(:,1),HistRangePeakW(:,2),'-y.');   
    plot(HistInterp(:,1),HistInterpFunc(:),'-r','LineWidth',2);
    %set(gca,'YScale','log');
    legend('NoiseM','NoiseW','NoiseF','PeakS','PeakF','Peak','PeakW','Func', 'Location','NorthWest');
    plot(log10([StdVal,StdVal]),[0,MaxPeakHist],'r','LineWidth',2);
    plot(log10([Threshold,Threshold]),[0,MaxPeakHist],'b','LineWidth',2);
    plot(log10([Threshold1,Threshold1]),[0,MaxPeakHist],'k','LineWidth',2);
    plot(log10([ThresholdStd,ThresholdStd]),[0,MaxPeakHist],'m','LineWidth',2);       
end;

else
    Threshold=0;
    Threshold1=0;  
end;
    Time(end+1)=toc;
%     disp(['Ploting time=', num2str(Time(end))]);
    fprintf(['Press ''C'' to correct the threshold or to accept the followes one as Threshold: \n',...
        '''r'' (red) by Standard deviation %6.3f\n',...
        '''b'' (blue)by Func %6.3f\n',...
        '''k'' (black)by Peaks above Noise  in Histogram %6.3f\n',...
        '''m'' (magenta) by Std*OverSt %6.3f\n',...
        '''e'' for manual input \n'],StdVal,Threshold,Threshold1,ThresholdStd);

        
    Decision=input('Default is Maximal Threshold ','s');
    if isempty(Decision); Decision='q'; end;  
    if Decision=='q'  
        Threshold=max([Threshold,Threshold1,ThresholdStd]);
    end;
    if Decision=='r'||Decision=='R'
        Threshold=StdVal;
    end;
    if Decision=='b'||Decision=='B'
        Threshold=Threshold;
    end;

    if Decision=='k'||Decision=='K'
        Threshold=Threshold1;
    end;

    if Decision=='m'||Decision=='M'
        Threshold=ThresholdStd;
    end;

    if Decision=='e'||Decision=='E'
        Threshold=input('Input threshold ');
        if isempty(Threshold)
            Threshold=max([Threshold,Threshold1,ThresholdStd]);
        end;
    end;

    if Plot
    if Decision=='c'||Decision=='C'
        %Colors=['k','b','g','y','c','m']';
        %Decision='q';
        %while not(Decision=='c'||Decision=='C')
            Color='m';   %Colors(1);
            x=[]; z=[];
            [x,z]=ginput(1);
            plot([x,x],[0,MaxPeakHist],Color,'LineWidth',2);
            %Colors=circshift(Colors,-1);
            %Decision= input('Press ''c'' when new threshold is selected      ','s');
        %end;
        NewThreshold = 10^x;
        disp('=====================');
        disp(['Automatic Threshold is ',num2str(Threshold)]);
        disp(['Manual Threshold =',num2str(NewThreshold),' is taken']);

        %Decision=input('Press ''c'' to accept the new threshold or any key to leave the old one    ','s');
        %if isempty(Decision); Decision='q'; end;
        %if Decision=='C'||Decision=='c'
            Threshold=NewThreshold;
        %end; 
    end;    
    end;
tic;    

SelectedPeakBool=RangePeak>log10(Threshold);


PeakSet.SelectedPeakInd=PeakInd(SelectedPeakBool);
SelectedPeakN=size(PeakSet.SelectedPeakInd,1);
PeakSet.Threshold=Threshold;


%preselection to search standard peak: 
if HistCalc
    PeakRangeMost=10^HistInterp(MaxPeakHistInd,1);
else
    PeakRangeMost=mean(10.^RangePeak(SelectedPeakBool));
end;
RangeSelectedPeak=10.^RangePeak(SelectedPeakBool);
% StandardPeakBool=RangePeak>(Threshold+MaxPeakHist)/2; 
% StandardPeakInd=PeakInd(StandardPeakBool);
% StandardPeakIndN=size(StandardPeakInd,1);


if Plot    
    figure; hold on; grid on; 
    plot(tr,'-y.');  %plot(trD,'m');  
    plot(NoiseMInd,tr(NoiseMInd),'k.'); plot(NoiseWInd,tr(NoiseWInd),'b.');
    plot(SignalInd,tr(SignalInd),'m.');          
    plot(PeakFInd,tr(PeakFInd),'r.');   plot(PeakInd,tr(PeakInd),'g.'); 
    plot(PeakSet.SelectedPeakInd,tr(PeakSet.SelectedPeakInd),'go'); 
    plot(PeakSet.PeakOnFrontInd,tr(PeakSet.PeakOnFrontInd),'bo'); 
    legend('track','NoiseM','NoiseW','S','PeakF','Peak','Selected peaks','PeaksOnFronts');
    plot(trF,'c');
    plot([1,trSize],[ThresholdF,ThresholdF]);
end; 




fprintf('=====  Search of peak tops      ==========\n');
fprintf('The number of measured points  = %7.0f during %7.0f us \n',trSize,trSize*tau);
fprintf('The total number of peaks = %7.0f \n',MaxIndN);
fprintf('The number of noise peaks selected from trF = %7.0f \n',PeakFIndN);
fprintf('The number of noise peaks (W and M types)= %7.0f \n',NoiseMIndN+NoiseWIndN);
fprintf('The number of signal peaks = %7.0f \n',SIndN);
fprintf('The number of signal peaks combined with F peaks = %7.0f \n',PeakIndN);
fprintf('The number of selected peaks above %7.2f threshold = %7.0f \n',PeakSet.Threshold,SelectedPeakN);
fprintf('The number of peaks on the front of the selected peaks = %7.0f \n',PeakOnFrontIndN);
fprintf('F Threshold = %7.0f \n',ThresholdF);
Time(end+1)=toc;
disp(['Search peak tops time=', num2str(Time(end))]);
fprintf('>>>>>>>>>>>>>>>>>>>>>>\n');
%================ section 4 ==============
%Distribution of time intervals among peaks: 

fprintf('=====  Search of Standard pulse    ==========\n');
tic;
if not(isempty(PeakSet.SelectedPeakInd))
    IntervalBefore=PeakSet.SelectedPeakInd-circshift(PeakSet.SelectedPeakInd,1);
    IntervalBefore(1)=PeakSet.SelectedPeakInd(1);
    IntervalAfter=circshift(PeakSet.SelectedPeakInd,-1)-PeakSet.SelectedPeakInd;
    IntervalAfter(end)=trSize-PeakSet.SelectedPeakInd(end);


    SingleInterval=(MaxFrontN+MaxTailN);
    StandardPeakBool=IntervalBefore>SingleInterval&IntervalAfter>SingleInterval;
    StandardPeakBool(RangeSelectedPeak<(PeakSet.Threshold+PeakRangeMost)/2)=false;
    StandardPeakInd=PeakSet.SelectedPeakInd(StandardPeakBool);
    StandardPeakN=size(StandardPeakInd,1);
    if StandardPeakN>0
        %Synhronize standard peaks using two highest points:
        AscendTop=tr(StandardPeakInd-1)>=tr(StandardPeakInd+1);
        if StandardPeakInd(end)-AscendTop(end)+MaxTailN>trSize
            StandardPeakN=StandardPeakN-1; StandardPeakInd(end)=[]; end;
        if StandardPeakInd(1)-AscendTop(1)-MaxFrontN<1;
            StandardPeakN=StandardPeakN-1; StandardPeakInd(1)=[]; end;
        SampleN=MaxFrontN+MaxTailN+1;
        StandardPulse=zeros(SampleN,StandardPeakN);

        % Make StandardPule matrix
        for i=1:StandardPeakN;
            NN=StandardPeakInd(i)-AscendTop(i);
            StandardPulse(:,i)=tr(NN-MaxFrontN:NN+MaxTailN)-...
                (tr(NN-MaxFrontN)+tr(NN+MaxTailN))/2;
        end;
        % remove all signals above MaxSignal:
        MaxSignal=3000;
        SignalsOk=StandardPulse<MaxSignal;
        for i=1:SampleN
            SelectedStandrdPulse=StandardPulse(i,SignalsOk(i,:));
            MeanStandardPulse(i,1)=mean(SelectedStandrdPulse);
            stdStandardPulse(i,1)=std(SelectedStandrdPulse);
            SelectedN(i,1)=sum(SignalsOk(i,:));
        end;
        StdNoise=mean(stdStandardPulse(end-6:end-3));

        % correction of zero line:
        x=[1,2,SampleN-3,SampleN-2,SampleN-1,SampleN]';
        Zero=polyfit(x,MeanStandardPulse(x),1);
        x=(1:SampleN)';
        MeanStandardPulse=MeanStandardPulse-(Zero(1)*x+Zero(2));
        [MaxStandardPulse,MaxStandardPulseIndx]=max(MeanStandardPulse);

        SmoothStartInd=MaxStandardPulseIndx+MaxFrontN;
        SmoothN=SampleN-SmoothStartInd;
        if SmoothN>3
            SmoothTail=smooth(MeanStandardPulse(SmoothStartInd-2:end),3);
            MeanStandardPulse(SmoothStartInd:end)=SmoothTail(3:end);
        end;
        LastFrontZero=find(MeanStandardPulse(1:MaxStandardPulseIndx)<=0,1,'last');
        FirstTailZero=find(MeanStandardPulse(MaxStandardPulseIndx+1:end)<=0,1,'first')+MaxStandardPulseIndx;
        MeanStandardPulse(1:LastFrontZero)=0;
        MeanStandardPulse(FirstTailZero:end)=0;
        StandardPulseNorm=MeanStandardPulse/MaxStandardPulse;
        
        % correction pre front zero point number;
        if LastFrontZero>1
         StandardPulseNorm(1:LastFrontZero-1)=[];
        end;

        [StPMax,StPMaxInd]=max(StandardPulseNorm);
        [StPMax1,StPMax1Ind]=max(StandardPulseNorm(StandardPulseNorm<StPMax));
        StPFitInd=min(StPMaxInd,StPMax1Ind);

        fprintf('The number of standard pulses found = %7.0f \n',StandardPeakN);
        StandardPulseNormD=diff(StandardPulseNorm);
        StandardPulseNormD(end+1)=StandardPulseNormD(end);
        StandardPulseNormDD=diff(StandardPulseNorm,2);
        StandardPulseNormDD(end+1)=StandardPulseNormDD(end);
        StandardPulseNormDD(end+1)=StandardPulseNormDD(end);
        StandardPulseNormF=-20*StandardPulseNormD.^2.*StandardPulseNormDD;
    end;

    if Plot
        figure;
        if StandardPeakN>0
            subplot(2,1,1);
            hold on;  x=(1:SampleN)';
            for i=1:StandardPeakN
                plot(x(SignalsOk(:,i)),StandardPulse(SignalsOk(:,i),i));
            end;
            plot(MeanStandardPulse,'-c.','LineWidth',2,'MarkerSize',12);
            plot(stdStandardPulse,'-m.');
            ylim([min(StandardPulse(SignalsOk)), 1.1*max(StandardPulse(SignalsOk))]);
            grid on;
            subplot(2,1,2); hold on;
            plot(StandardPulseNorm,'-r.'); grid on;
            plot(StandardPulseNormF,'-b.');
        end;
    end;
end;

% Readout of standard pulse averaged aver many tracks
 
if exist(StandardPulseFile,'file');
   StandardPulseNormFile=load(StandardPulseFile);
   [StPFMax,StPFMaxInd]=max(StandardPulseNormFile);
   [StPFMax1,StPFMax1Ind]=max(StandardPulseNormFile(StandardPulseNormFile<StPFMax));
   StPFFitInd=min(StPFMaxInd,StPFMax1Ind);

   disp(['Standard pulses is taken from ',StandardPulseFile]);

    StandardPulseNormFileD=diff(StandardPulseNormFile); 
    StandardPulseNormFileD(end+1)=StandardPulseNormFileD(end); 
    StandardPulseNormFileDD=diff(StandardPulseNormFile,2); 
    StandardPulseNormFileDD(end+1)=StandardPulseNormFileDD(end);
    StandardPulseNormFileDD(end+1)=StandardPulseNormFileDD(end);
    StandardPulseNormFileF=-20*StandardPulseNormFileD.^2.*StandardPulseNormFileDD;
    
   if Plot
    plot([(StPFitInd-StPFFitInd)+1:(StPFitInd-StPFFitInd)+size(StandardPulseNormFile,1)],StandardPulseNormFile,'-ro'); grid on;  hold on;
    plot([(StPFitInd-StPFFitInd)+1:(StPFitInd-StPFFitInd)+size(StandardPulseNormFile,1)],StandardPulseNormFileF,'-bo');
    legend('Standard Pulse','Standard Pulse F','File Standard Pulse','File Standard Pulse F');
   end;

end;

TrekSet.PeakOnFrontInd=PeakSet.PeakOnFrontInd;
TrekSet.SelectedPeakInd=PeakSet.SelectedPeakInd;
TrekSet.Threshold=PeakSet.Threshold;


Time(end+1)=toc;
disp(['Standard Pulse Analyze=', num2str(Time(end))]);
fprintf('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n');
disp(['Full processing time=', num2str(sum(Time))]);
CloseGraphs;
disp('================ TrekTops.m finished');
      