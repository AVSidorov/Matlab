function [PeakSet,StandardPulseNorm]=Tops(FileName,Plot,PreThreshold,trProcessBool)
%PeakSet -> [SelectedPeakInd,PeakOnFrontInd,Threshold]
% Search peak top indexes of tr(:,1) array.
%FileName - file of 1D array of measurement sampled at 1/tau rate
           %tr signals are supposed to be positive short pulses,
           %FileName signals are supposed to be negative short pulses,
           % front ~3-4 points, tail is more than 4 points.

           
%SelectedPeakInd - indexes of peak tops selected
%PeakOnFrontInd - indexes of peak tops overlaped with other peak fronts
%Threshold - noise standard deviation      
      

% Signal are cathed from noises by detecting their fronts(1) and tops(2):
% 1. Front detection using array trF=-trD.^2.*trDD, 
%     which quite sensitive to real signal (Section 1) 
% 2. Top detection using variation of 5 measurements 
%     around any top (Section 2)
% 3. Combimagtion of (1) and (2) to select noise out. 
% 4. Search a standradr signal pulse from extracted signal.  

Text  = false;    % switch between text and bin files
tau=0.020;        % us digitizing time
MinFront=0.05;    % minimal peak front, us
MaxFront=0.125;   % maximal peak front, us
MinTail=0.05;     % minimal peak tail, us
MaxTail=0.8;      % maximal peak tail, us
OverSt=1.1;       % noise regection threshold, in standard deviations

MaxSignal= 3300;  % maximal signal whithout distortion
notProcessTail=8; % number of points after exceeding of Maxsignal, which will'nt be processed

StandardPulseFile='D:\!SCN\EField\StandPeakAnalys\StPeak20ns_1.dat';


if nargin<2; Plot=true; end;
if nargin<3; 
    [tr,ProcInt,ProcIntTime,StdVal]=PrepareTrek(FileName); 
    PreThreshold=OverSt*StdVal;
else
    tr=FileName;
end;

Time=[];

disp('>>>>>>>>Tops.m started'); 
if nargin<4|isempty(trProcessBool);
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

[MeanVal,StdVal,PeakPolarity,Noise]=MeanSearch(trF,3,0);
% PeakPolarity must be ==1; %
    PeakFBool=(PosFBool&not(Noise)&(trF>0));
    NoiseFBool=(PosFBool&Noise)|(NegFBool&Noise&trF>-StdVal);

%PeakFBool=PeakFBool&not(Noise); 

HistFPoints= min(50,round(min(size(find(PeakFBool),1),size(find(NoiseFBool),1))/4));    % average number of points per an histogram interval   
HistFN=round(min(size(find(PeakFBool),1),size(find(NoiseFBool),1))/HistFPoints);

% Searching the threshould for extraction real signals from PeakFBool
% Signal and noise distributions of trF:
LogFNoise=log10(0.0001*StdVal+abs(trF(NoiseFBool))); 
LogFPeak=log10(trF(PeakFBool));
LogNegFBool=log10(0.0001*StdVal-trF(NegFBool));

HistFStart=min(min(LogFNoise),min(LogFPeak));
HistFEnd  =max(max(LogFNoise),max(LogFPeak));
HistFStep= (HistFEnd-HistFStart)/(HistFN-1);
for i=1:HistFN
    X=HistFStart+(i-1)*HistFStep;
    HistF(i,1)=X; X1=X-HistFStep/2;  X2=X+HistFStep/2;
    HistF(i,2)=size(find(LogFNoise >X1&LogFNoise<=X2),1);
    HistF(i,3)=size(find(LogFPeak>X1&LogFPeak<=X2),1);
    HistF(i,4)=size(find(LogNegFBool>X1&LogNegFBool<=X2),1);
end;
% Search threshold:
[MaxNoiseHist,MaxNoiseHistInd]=max(HistF(:,2));
AboveNoise=HistF(:,3)>=HistF(:,2);
AboveNoise(1:MaxNoiseHistInd)=false; 
AboveNoiseInd=find(AboveNoise);
NoiseBorderLowInd=find(AboveNoise,1,'first');
NoiseBorderHighInd=find(not(AboveNoise),1,'last');
ThresholdF=(HistF(NoiseBorderLowInd,1)+HistF(NoiseBorderHighInd,1))/2;
if isempty(ThresholdF)
   if isempty(NoiseBorderLowInd)
       ThresholdF=HistF(NoiseBorderHighInd,1);
   end;
   if isempty(NoiseBorderHighInd)
       ThresholdF=HistF(NoiseBorderLowInd,1);
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

HistStart =1e20;  HistEnd= -1e20;

RangeM=zeros(1, NoiseMIndN);
for i=1:NoiseMIndN 
    y=tr(NoiseMInd(i)-3:NoiseMInd(i)+2); RangeM(i)=log10(max(y)-min(y));
end;
if not(isempty(RangeM)); 
    HistStart=min(HistStart,min(RangeM)); 
    HistEnd=max(HistEnd,max(RangeM));  
end;

RangeW=zeros(1, NoiseWIndN);
for i=1:NoiseWIndN 
    y=tr(NoiseWInd(i)-3:NoiseWInd(i)+2); RangeW(i)=log10(max(y)-min(y));
end;
if not(isempty(RangeW)); 
    HistStart=min(HistStart,min(RangeW)); 
    HistEnd=max(HistEnd,max(RangeW));  
end;

RangePeakW=zeros(1, PeakWIndN);
for i=1:PeakWIndN 
    y=tr(PeakWInd(i)-3:PeakWInd(i)+2); RangePeakW(i)=log10(max(y)-min(y));
end;
if not(isempty(RangePeakW)); 
    HistStart=min(HistStart,min(RangePeakW)); 
    HistEnd=max(HistEnd,max(RangePeakW));  
end;

% Histogram of the range of noise F signals:
RangeNoiseF=zeros(1,NoiseFIndN);
for i=1:NoiseFIndN 
    y=tr(NoiseFInd(i)-3:NoiseFInd(i)+2); RangeNoiseF(i)=log10(max(y)-min(y));
end;

RangeS=zeros(1, SIndN);
for i=1:SIndN 
    y=tr(SignalInd(i)-3:SignalInd(i)+2);   %RangeS(i)=log10(max(y)-min(y));
    RangeS(i)=log10(tr(SignalInd(i))-min(y));
end;
if not(isempty(RangeS)); 
    HistStart=min(HistStart,min(RangeS)); 
    HistEnd=max(HistEnd,max(RangeS));  
end;

RangePeakF=zeros(1, PeakFIndN);
for i=1:PeakFIndN 
    y=tr(PeakFInd(i)-3:PeakFInd(i)+2); 
    RangePeakF(i)=log10(tr(PeakFInd(i))-min(y));
end;

PeakInd(PeakInd+3>trSize)=[];  PeakInd(PeakInd-2<1)=[];
%PeakInd(tr(PeakInd)>MaxSignal)=[];

PeakIndN=size(PeakInd,1);
RangePeak=zeros(1, PeakIndN);
for i=1:PeakIndN 
    y=tr(PeakInd(i)-3:PeakInd(i)+2);    RangePeak(i)=log10(tr(PeakInd(i))-min(y));
end;
if not(isempty(RangePeak)); 
    HistStart=min(HistStart,min(RangePeak)); 
    HistEnd=max(HistEnd,max(RangePeak));  
end;

PeakSet.PeakOnFrontInd(PeakSet.PeakOnFrontInd+2>trSize)=[];  
PeakSet.PeakOnFrontInd(PeakSet.PeakOnFrontInd-2<1)=[];
PeakOnFrontIndN=size(PeakSet.PeakOnFrontInd,1);
RangePeakOnFront=zeros(1, PeakOnFrontIndN);
for i=1:PeakOnFrontIndN 
    y=tr(PeakSet.PeakOnFrontInd(i)-2:PeakSet.PeakOnFrontInd(i)+2);    
    RangePeakOnFront(i)=log10(tr(PeakSet.PeakOnFrontInd(i))-min(y));
end;

HistPoints= min(100, round(mean([NoiseMIndN,NoiseWIndN,SIndN,NoiseFIndN,PeakFIndN,PeakIndN])/4));    % average number of points per an histogram interval
HistN=round(mean([NoiseMIndN,NoiseWIndN,SIndN,NoiseFIndN,PeakFIndN,PeakIndN])/HistPoints);
%HistStart =min(min(min(RangeM),min(RangeW)),min(min(RangeS),min(RangePeak)));
%HistEnd   =max(max(max(RangeM),max(RangeW)),max(max(RangeS),max(RangePeak)));
HistStep=(HistEnd-HistStart)/(HistN-1);
for i=1:HistN 
    X=HistStart+(i-1)*HistStep;   Hist(i,1)=X;
    Hist(i,2)=size(find((RangeM<=X+HistStep/2)&(RangeM>X-HistStep/2)),2); 
    Hist(i,3)=size(find((RangeW<=X+HistStep/2)&(RangeW>X-HistStep/2)),2);
    Hist(i,4)=size(find((RangeNoiseF<=X+HistStep/2)&(RangeNoiseF>X-HistStep/2)),2);
    Hist(i,5)=size(find((RangeS<=X+HistStep/2)&(RangeS>X-HistStep/2)),2);
    Hist(i,6)=size(find((RangePeakF<=X+HistStep/2)&(RangePeakF>X-HistStep/2)),2);
    Hist(i,7)=size(find((RangePeak<=X+HistStep/2)&(RangePeak>X-HistStep/2)),2);
    Hist(i,8)=size(find((RangePeakW<=X+HistStep/2)&(RangePeakW>X-HistStep/2)),2);
end;

Time(end+1)=toc;
disp(['Histograms calculation time=', num2str(Time(end))]);
tic;

% Threshold:
%NoiseHist=(Hist(:,2)+Hist(:,3))/2;
[MaxPeakHist,MaxPeakHistInd]=max(Hist(:,7));
%[MaxNoiseHist,MaxNoiseHistInd]=max(NoiseHist);
%AboveNoise=Hist(:,7)>=NoiseHist; 
AboveNoise=Hist(:,7)>Hist(:,8); 
[MaxNoiseHist,MaxNoiseHistInd]=max(Hist(:,8));
AboveNoise(1:MaxNoiseHistInd)=false; 
AboveNoiseInd=find(AboveNoise);
NoiseBorderLowInd=find(AboveNoise,1,'first');
%NoiseBorderHighInd=find(not(AboveNoise),1,'last');
%Threshold=(Hist(NoiseBorderLowInd,1)+Hist(NoiseBorderHighInd,1))/2;
Threshold=Hist(NoiseBorderLowInd,1);
if isempty(Threshold)
   if isempty(NoiseBorderLowInd)
       Threshold=Hist(NoiseBorderHighInd,1);
   end;
   if isempty(NoiseBorderHighInd)
       Threshold=Hist(NoiseBorderLowInd,1);
   end;
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
    plot(HistF(:,1),HistF(:,2),'-b.'); 
    plot(HistF(:,1),HistF(:,3),'-g.'); 
    plot(HistF(:,1),HistF(:,4),'-c.');
    legend('trF noise','trFsignal','trFNeg', 'Location','NorthWest');
    plot(log10([ThresholdF,ThresholdF]),[0,MaxNoiseHist],'r','LineWidth',2);
    
    subplot(2,1,2);
    title(['Peak noise separation. Threshold=',num2str(Threshold),' PreThreshold=',num2str(PreThreshold)]);
    hold on; grid on; xlabel('log10(Range)');
    plot(Hist(:,1),Hist(:,2),'-k.');    plot(Hist(:,1),Hist(:,3),'-b.');
    plot(Hist(:,1),Hist(:,4),'-c.');    plot(Hist(:,1),Hist(:,5),'-m.');  
    plot(Hist(:,1),Hist(:,6),'-r.');    plot(Hist(:,1),Hist(:,7),'-g.');
    plot(Hist(:,1),Hist(:,8),'-y.');
    legend('NoiseM','NoiseW','NoiseF','PeakS','PeakF','Peak','PeakW', 'Location','NorthWest');
    plot(log10([Threshold,Threshold]),[0,MaxNoiseHist],'r','LineWidth',2);
    if nargin>2;
        plot(log10([PreThreshold,PreThreshold]),[0,MaxNoiseHist],'b','LineWidth',2);       
    end;
end;

    Time(end+1)=toc;
    disp(['Ploting time=', num2str(Time(end))]);

    Decision=input('Press ''C'' to correct the threshold or any other key to accept the bellow one \n Default is PreThreshold (blue)   ','s');
    if isempty(Decision); Decision='q'; end;  
    if Decision=='c'||Decision=='C'
        %Colors=['k','b','g','y','c','m']';
        %Decision='q';
        %while not(Decision=='c'||Decision=='C')
            Color='b';   %Colors(1);
            x=[]; z=[];
            [x,z]=ginput(1);
            plot([x,x],[0,MaxNoiseHist],Color,'LineWidth',2);
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
    else
       Threshold=max([Threshold,PreThreshold]);
    end;    

tic;    
SelectedPeakBool=RangePeak>log10(Threshold); 
PeakSet.SelectedPeakInd=PeakInd(SelectedPeakBool);
SelectedPeakN=size(PeakSet.SelectedPeakInd,1);
PeakSet.Threshold=Threshold;
PeakRangeMost=10^Hist(MaxPeakHistInd,1);
%preselection to search standard peak: 
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
        if StandardPulseNorm(StPMaxInd+1)<StandardPulseNorm(StPMaxInd-1)
               StPMax=StPMaxInd-1;
        end;

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
   if StandardPulseNormFile(StPFMaxInd+1)<StandardPulseNormFile(StPFMaxInd-1)
               StPFMaxInd=StPFMaxInd-1;
   end;
    disp(['Standard pulses is taken from ',StandardPulseFile]);
    if Plot
    StandardPulseNormFileD=diff(StandardPulseNormFile); 
    StandardPulseNormFileD(end+1)=StandardPulseNormFileD(end); 
    StandardPulseNormFileDD=diff(StandardPulseNormFile,2); 
    StandardPulseNormFileDD(end+1)=StandardPulseNormFileDD(end);
    StandardPulseNormFileDD(end+1)=StandardPulseNormFileDD(end);
    StandardPulseNormFileF=-20*StandardPulseNormFileD.^2.*StandardPulseNormFileDD;

    if StandardPulseNormFile(StPFMaxInd+1)<StandardPulseNormFile(StPFMaxInd-1)
        StPFMaxInd=StPFMaxInd-1;
    end;
    
    plot([(StPMaxInd-StPFMaxInd)+1:(StPMaxInd-StPFMaxInd)+size(StandardPulseNormFile,1)],StandardPulseNormFile,'-ro'); grid on;  hold on;
    plot([(StPMaxInd-StPFMaxInd)+1:(StPMaxInd-StPFMaxInd)+size(StandardPulseNormFile,1)],StandardPulseNormFileF,'-bo');
    end;
end;

Time(end+1)=toc;
disp(['Standard Pulse Analyze=', num2str(Time(end))]);
fprintf('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n');
disp(['Full processing time=', num2str(sum(Time))]);
disp('================ Tops.m finished');
      