function PeakSet=Tops_my(FileName,Plot)
%PeakSet -> [SelectedPeakInd,PeakOnFrontInd,StandardPulseNorm,Threshold]
% Search peak top indexes of tr(:,1) array.
%FileName - file of 1D array of measurement sampled at 1/tau rate
           %tr signals are supposed to be positive short pulses,
           %FileName signals are supposed to be negative short pulses,
           % front ~3-4 points, tail is more than 4 points.

           
%SelectedPeakInd - indexes of peak tops selected
%PeakOnFrontInd - indexes of peak tops overlaped with other peak fronts
%StandardPulseNorm - standard pulse shape
%Threshold - noise standard deviation      

      

% Signal are cathed from noises by detecting their fronts(1) and tops(2):
% 1. Front detection using array trF=-trD.^2.*trDD, 
%     which quite sensitive to real signal (Section 1) 
% 2. Top detection using variation of 5 measurements 
%     around any top (Section 2)
% 3. Combimagtion of (1) and (2) to select noise out. 
% 4. Search a standradr signal pulse from extracted signal.  

Text  = false;    % switch between text and bin files
tau=0.025;        % us digitizing time
MinFront=0.05;    % minimal peak front, us
MaxFront=0.125;   % maximal peak front, us
MinTail=0.05;     % minimal peak tail, us
MaxTail=0.8;      % maximal peak tail, us


if nargin<2; Plot=true; end;

if not(isstr(FileName)); 
    tr=FileName;  
    if size(tr,2)==2; tr(:,1)=[]; end;
else
    if Text;  tr=load(FileName); else
        fid = fopen(FileName); tr = fread(fid,inf,'int16'); fclose(fid); clear fid;
    end;
    if size(tr,2)==2; tr(:,1)=[]; end;
    bool=(tr>4095)|(tr<0); OutRangeN=size(find(bool),1);
    if OutRangeN>0; fprintf('%7.0f  points out of the ADC range  \n',OutRangeN); end;
    tr(bool)=[];  clear bool;
    MeanTr=mean(tr);
    if size(find(tr>MeanTr))>size(find(tr<MeanTr))
       tr=Mean-tr;  else tr=tr-Mean;  end;         
end;

MaxFrontN=round(MaxFront/tau); MaxTailN=round(MaxTail/tau);
MinFrontN=round(MinFront/tau); MinTailN=round(MinTail/tau);


trSize=size(tr,1);
%================ section 1 ==============
% catch signal fronts:
trD=diff(tr);     trD(end+1)=trD(end);
trDD=diff(tr,2);  trDD(end+1:end+2)=trDD(end);
trF=-trD.^2.*trDD/1000;  % tops of trF are very sensitive to peak front !!!

% Mark all trF tops which correspond to peak fronts:
AllFBool=(trF>0)&(trF>circshift(trF,1))&(trF>circshift(trF,2))&...
    (trF>circshift(trF,-2))&(trF>circshift(trF,-1));
AllFBool(1:2)=false;  AllFBool(end-1:end)=false;

% additional criterion for the fronts of real peaks:
trFA=abs(trF);
AbsFBool=(trFA>circshift(trFA,1))&(trFA>circshift(trFA,2))&...
    (trFA>circshift(trFA,-2))&(trFA>circshift(trFA,-1));
AbsFBool(1:2)=false;  AbsFBool(end-1:end)=false;

% separation signal and noises: 
PeakFBool=AllFBool&AbsFBool;            %Signals
NoiseFBool=not(AbsFBool)&AllFBool;   %Noise

HistFPoints= 50;    % average number of points per an histogram interval   
HistFN=round(min(size(find(PeakFBool),1),size(find(NoiseFBool),1))/HistFPoints);

% Searching the threshould for extraction real signals from PeakFBool
% Signal and noise distributions of trF:
LogFNoise=log10(trF(NoiseFBool)); LogFPeak=log10(trF(PeakFBool));
HistFStart=min(min(LogFNoise),min(LogFPeak));
HistFEnd  =max(max(LogFNoise),max(LogFPeak));
HistFStep= (HistFEnd-HistFStart)/(HistFN-1);
for i=1:HistFN
    X=HistFStart+(i-1)*HistFStep;
    HistF(i,1)=X; X1=X-HistFStep/2;  X2=X+HistFStep/2;
    HistF(i,2)=size(find(LogFNoise >X1&LogFNoise<=X2),1);
    HistF(i,3)=size(find(LogFPeak>X1&LogFPeak<=X2),1);
end;
% Search threshold:
[MaxNoiseHist,MaxNoiseHistInd]=max(HistF(:,2));
AboveNoise=HistF(:,3)>=HistF(:,2); AboveNoise(1:MaxNoiseHistInd)=false; 
AboveNoiseInd=find(AboveNoise);
NoiseBorderLowInd=find(AboveNoise,1,'first');
NoiseBorderHighInd=find(not(AboveNoise),1,'last');
ThresholdF=(HistF(NoiseBorderLowInd,1)+HistF(NoiseBorderHighInd,1))/2;
ThresholdF=10^ThresholdF;    % Threshold for separation F signal and noise.

%mark all selected signal tops and expected tops in signal fronts: 
FBool=AllFBool&trF>ThresholdF;
FInd=find(FBool); FIndN=size(FInd,1);
PeakFInd=zeros(FIndN,1);
PeakSet.PeakOnFrontInd=[];
for i=1:FIndN-1
    y=tr(FInd(i):FInd(i+1)-1); yR=tr(FInd(i)+1:FInd(i+1)); yL=tr(FInd(i)-1:FInd(i+1)-2);
    FindMax=find(y>=yR&y>yL,1,'first');
    if isempty(FindMax) % then a peak on the front is expected
        y=trD(FInd(i):FInd(i+1)-1); 
        yR=trD(FInd(i)+1:FInd(i+1)); yL=trD(FInd(i)-1:FInd(i+1)-2);
        FindMax=find(y<yR&y<=yL,1,'first');
        if isempty(FindMax); [Miny,FindMax]=min(abs(y)); end;
        PeakSet.PeakOnFrontInd=[PeakSet.PeakOnFrontInd;FInd(i)+FindMax-1];
    end;
    PeakFInd(i)=FInd(i)+FindMax-1;
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
PeakFInd(PeakFInd<3|PeakFInd>trSize-2)=[];
PeakFBool=false(trSize,1);
PeakFBool(PeakFInd)=true;
PeakFIndN=size(PeakFInd,1);

NoiseFBool=not(PeakFBool)&AllFBool;   %Noise
NoiseFInd=find(NoiseFBool); NoiseFIndN=size(NoiseFInd,1); 

clear trDD trFA AllBool AllFBool FBool AbsFBool NoiseFBool...
      BoolInd bool LogFNoise LogFPeak FInd NoiseInd  ...
      MaxFrontDiff MaxTailDiff Interval FindMax;

  
%================ section 2 ==============  
trR1=circshift(tr,1);  trR1(1)=trR1(2);
trR2=circshift(tr,2);  trR2(1)=trR2(3); trR2(2)=trR2(3);
trL1=circshift(tr,-1); trL1(end)=trL1(end-1);
trL2=circshift(tr,-2); trL2(end)=trL2(end-2); trL2(end-1)=trL2(end-2);
% search all peaks in tr:
MaxIndN=size(find(tr>trR1&tr>=trL1),1);

%5-points noise analysis
% noise like: /\/\
NoiseMInd=find(tr<trR1&tr<trL1&trL2<trL1&trR2<trR1);
NoiseMInd(NoiseMInd<3|NoiseMInd>trSize-2)=[];NoiseMIndN=size(NoiseMInd,1);
% noise like: \/\/
NoiseWInd=find(tr>trR1&tr>trL1&trL2>trL1&trR2>trR1); %&tr>trL2
NoiseWInd(NoiseWInd<3|NoiseWInd>trSize-2)=[];NoiseWIndN=size(NoiseWInd,1);
% %Noises like signals and signals:
% NoiseSInd=find(tr>trR1&trR1>trR2&tr>trL1&trL1>trL2);
% NoiseSInd(NoiseSInd<3|NoiseSInd>trSize-2)=[];NoiseSIndN=size(NoiseSInd,1);
%Expected signals:
SignalBool=tr>trR1&trR1>trR2&tr>=trL1; %&trL1>trL2; (otherwise the peak may be hidden by the next one)
SignalBool(1:2)=false; SignalBool(end-1:end)=false;
SignalBool(NoiseMInd)=false;  SignalBool(NoiseWInd)=false; 
SignalInd=find(SignalBool); SIndN=size(SignalInd,1);

%3. ====== Combination ====================
PeakBool=PeakFBool&SignalBool;

PeakInd=find(PeakBool); 
PeakInd=[PeakInd;PeakSet.PeakOnFrontInd];  
PeakInd=sort(PeakInd);
PeakIndN=size(PeakInd,1);
PeakOnFrontIndN=size(PeakSet.PeakOnFrontInd,1);

RangeM=zeros(1, NoiseMIndN);
for i=1:NoiseMIndN 
    y=tr(NoiseMInd(i)-2:NoiseMInd(i)+2); RangeM(i)=log10(max(y)-min(y));
end;
RangeW=zeros(1, NoiseWIndN);
for i=1:NoiseWIndN 
    y=tr(NoiseWInd(i)-2:NoiseWInd(i)+2); RangeW(i)=log10(max(y)-min(y));
end;
% Histogram of the range of noise F signals:
RangeNoiseF=zeros(1,NoiseFIndN);
for i=1:NoiseFIndN 
    y=tr(NoiseFInd(i)-2:NoiseFInd(i)+2); RangeNoiseF(i)=log10(max(y)-min(y));
end;

RangeS=zeros(1, SIndN);
for i=1:SIndN 
    y=tr(SignalInd(i)-2:SignalInd(i)+2);   %RangeS(i)=log10(max(y)-min(y));
    RangeS(i)=log10(tr(SignalInd(i))-min(y));
end;
RangePeakF=zeros(1, PeakFIndN);
for i=1:PeakFIndN 
    y=tr(PeakFInd(i)-2:PeakFInd(i)+2);  RangePeakF(i)=log10(tr(PeakFInd(i))-min(y));
end;

PeakInd(PeakInd+2>trSize)=[];  PeakInd(PeakInd-2<1)=[];
PeakIndN=size(PeakInd,1);
RangePeak=zeros(1, PeakIndN);
for i=1:PeakIndN 
    y=tr(PeakInd(i)-2:PeakInd(i)+2);    RangePeak(i)=log10(tr(PeakInd(i))-min(y));
end;

PeakSet.PeakOnFrontInd(PeakSet.PeakOnFrontInd+2>trSize)=[];  
PeakSet.PeakOnFrontInd(PeakSet.PeakOnFrontInd-2<1)=[];
PeakOnFrontIndN=size(PeakSet.PeakOnFrontInd,1);
RangePeakOnFront=zeros(1, PeakOnFrontIndN);
for i=1:PeakOnFrontIndN 
    y=tr(PeakSet.PeakOnFrontInd(i)-2:PeakSet.PeakOnFrontInd(i)+2);    
    RangePeakOnFront(i)=log10(tr(PeakSet.PeakOnFrontInd(i))-min(y));
end;

HistPoints= 100;    % average number of points per an histogram interval
HistN=round(mean([NoiseMIndN,NoiseWIndN,SIndN,NoiseFIndN,PeakFIndN,PeakIndN])/HistPoints);
HistStart =min(min(min(RangeM),min(RangeW)),min(min(RangeS),min(RangePeak)));
HistEnd   =max(max(max(RangeM),max(RangeW)),max(max(RangeS),max(RangePeak)));
HistStep=(HistEnd-HistStart)/(HistN-1);
for i=1:HistN 
    X=HistStart+(i-1)*HistStep;   Hist(i,1)=X;
    Hist(i,2)=size(find((RangeM<=X+HistStep/2)&(RangeM>X-HistStep/2)),2); 
    Hist(i,3)=size(find((RangeW<=X+HistStep/2)&(RangeW>X-HistStep/2)),2);
    Hist(i,4)=size(find((RangeNoiseF<=X+HistStep/2)&(RangeNoiseF>X-HistStep/2)),2);
    Hist(i,5)=size(find((RangeS<=X+HistStep/2)&(RangeS>X-HistStep/2)),2);
    Hist(i,6)=size(find((RangePeakF<=X+HistStep/2)&(RangePeakF>X-HistStep/2)),2);
    Hist(i,7)=size(find((RangePeak<=X+HistStep/2)&(RangePeak>X-HistStep/2)),2);
end;

% Threshold:
NoiseHist=(Hist(:,2)+Hist(:,3))/2;
[MaxNoiseHist,MaxNoiseHistInd]=max(NoiseHist);
[MaxPeakHist,MaxPeakHistInd]=max(Hist(:,end));
AboveNoise=Hist(:,7)>=NoiseHist; AboveNoise(1:MaxNoiseHistInd)=false; 
AboveNoiseInd=find(AboveNoise);
NoiseBorderLowInd=find(AboveNoise,1,'first');
NoiseBorderHighInd=find(not(AboveNoise),1,'last');
Threshold=(Hist(NoiseBorderLowInd,1)+Hist(NoiseBorderHighInd,1))/2;
Threshold=10^Threshold;

if Plot
    figure; 
    subplot(2,1,1);
    title(['track noise separation. ThresholdF=',num2str(ThresholdF)]);  
    hold on; grid on; xlabel('log10(trF)');
    plot(HistF(:,1),HistF(:,2),'-b.'); 
    plot(HistF(:,1),HistF(:,3),'-g.'); 
    legend('trF noise','trFsignal');
    plot(log10([ThresholdF,ThresholdF]),[0,MaxNoiseHist],'r','LineWidth',2);
    
    subplot(2,1,2);
    title(['Peak noise separation. Threshold=',num2str(Threshold)]);
    hold on; grid on; xlabel('log10(Range)');
    plot(Hist(:,1),Hist(:,2),'-k.');    plot(Hist(:,1),Hist(:,3),'-b.');
    plot(Hist(:,1),Hist(:,4),'-c.');    plot(Hist(:,1),Hist(:,5),'-m.');  
    plot(Hist(:,1),Hist(:,6),'-r.');    plot(Hist(:,1),Hist(:,7),'-g.');
    legend('NoiseM','NoiseW','NoiseF','PeakS','PeakF','Peak');
    plot(log10([Threshold,Threshold]),[0,MaxNoiseHist],'r','LineWidth',2);
    
    
    Decision=input('Press ''C'' to correct the threshold or any other key to accept the bellow one     \n','s');
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
        disp(['Manual Threshold is ',num2str(NewThreshold)]);

        Decision=input('Press ''c'' to accept the new threshold or any key to leave the old one   \n ','s');
        if isempty(Decision); Decision='q'; end;
        if Decision=='C'||Decision=='c'
            Threshold=NewThreshold;
        end; 
    end;
end;    
    
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
    legend('track','NoiseF','NoiseW','S','PeakF','Peak','Selected peaks','PeaksOnFronts');
    plot(trF,'c');
end; 




fprintf('=====  Search of peak tops      ==========\n');
fprintf('The number of measured points  = %7.0f during %7.0f us \n',trSize,trSize*0.025);
fprintf('The total number of peaks = %7.0f \n',MaxIndN);
fprintf('The number of noise peaks selected from trF = %7.0f \n',PeakFIndN);
fprintf('The number of noise peaks (W and M types)= %7.0f \n',NoiseMIndN+NoiseWIndN);
fprintf('The number of signal peaks = %7.0f \n',SIndN);
fprintf('The number of signal peaks combined with F peaks = %7.0f \n',PeakIndN);
fprintf('The number of selected peaks above %7.2f threshold = %7.0f \n',PeakSet.Threshold,SelectedPeakN);
fprintf('The number of peaks on the front of the selected peaks = %7.0f \n',PeakOnFrontIndN);


%================ section 4 ==============
%Distribution of time intervals among peaks: 
IntervalBefore=PeakSet.SelectedPeakInd-circshift(PeakSet.SelectedPeakInd,1); 
IntervalBefore(1)=PeakSet.SelectedPeakInd(1);
IntervalAfter=circshift(PeakSet.SelectedPeakInd,-1)-PeakSet.SelectedPeakInd; 
IntervalAfter(end)=trSize-PeakSet.SelectedPeakInd(end);

SingleInterval=(MaxFrontN+MaxTailN);
StandardPeakBool=IntervalBefore>SingleInterval&IntervalAfter>SingleInterval;
StandardPeakBool(RangeSelectedPeak<(PeakSet.Threshold+PeakRangeMost)/2)=false; 
StandardPeakInd=PeakSet.SelectedPeakInd(StandardPeakBool);
StandardPeakN=size(StandardPeakInd,1);

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
PeakSet.StandardPulseNorm=MeanStandardPulse/MaxStandardPulse;

fprintf('The number of standard pulses found = %7.0f \n',StandardPeakN);
StandardPulseNormD=diff(PeakSet.StandardPulseNorm); 
StandardPulseNormD(end+1)=StandardPulseNormD(end); 
StandardPulseNormDD=diff(PeakSet.StandardPulseNorm,2); 
StandardPulseNormDD(end+1)=StandardPulseNormDD(end);
StandardPulseNormDD(end+1)=StandardPulseNormDD(end);
StandardPulseNormF=-20*StandardPulseNormD.^2.*StandardPulseNormDD;

if Plot
    figure;
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
    plot(PeakSet.StandardPulseNorm,'-r.'); grid on;
    plot(StandardPulseNormF,'-b.');
end;

% Readout of standard pulse averaged aver many tracks

StndardPulseFile='E:\MK\matlab\Standard Pulse.dat';

if exist(StndardPulseFile,'file');
    PeakSet.StandardPulseNorm=load(StndardPulseFile);
    disp(['Standard pulses is taken from ',StndardPulseFile]);
    StandardPulseNormD=diff(PeakSet.StandardPulseNorm); 
    StandardPulseNormD(end+1)=StandardPulseNormD(end); 
    StandardPulseNormDD=diff(PeakSet.StandardPulseNorm,2); 
    StandardPulseNormDD(end+1)=StandardPulseNormDD(end);
    StandardPulseNormDD(end+1)=StandardPulseNormDD(end);
    StandardPulseNormF=-20*StandardPulseNormD.^2.*StandardPulseNormDD;
    plot(PeakSet.StandardPulseNorm,'-ro'); grid on;
    plot(StandardPulseNormF,'-bo');
    
end;

      