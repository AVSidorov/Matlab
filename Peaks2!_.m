function [peaks,HistA]=Peaks2_(FileName,Dialog,MaxSignal);
%[peaks,HistA]=Peaks(FileName); gets peaks from plasma x-ray trek.

Text=0;           % switch between text and binary input files
Delta=1;          % if Delta=1 then trekD is used for peak detection, else the peaks are detected from the trek.  
Fourie=0;         %if Fourie=1 then performes Fourie transformation of the signal. 
                  % there are bugs in Fourie still. scale etc... 
FrontCharge=1;    % if FrontCharge=1 then the cahrge is calculated till peak maximum else charge is calculated within ChargeTime
DeadAfter=1;      % if DeadAfter=1 then all pulses during DeadTime 
                  % after peaks exceeding MaxSignal are eliminated (to avoied excited noises) 
Plot1=1;          % if 1 then trek plot is active                  
Plot2=0;          % if 1 then interval plot is active

AverageGate=0.1;  % Averaging gate
OverSt=2;         % noise regection threshold, in standard deviations    
PeakSt=2;         % peak threshold, in standard deviations   
MinFront=0.05;    % minimal front edge of peaks, us
MaxFront=0.15;    % maximal front edge of peaks, us
MinTail=0.05;     % minimal tail edge of peaks, us
MaxTail=0.8;      % maximal tail edge of peaks, us

MinDuration=0.1;  % minimal peak duration, us. Shorter peaks are eliminated 
MaxDuration=0.95; % maximal peak duration, us. Longer peaks are eliminated. 

Dshift=1;         %circshift(trek(:,2),Dshift); 
ZeroPoints=8;     % for avaraging peak zero level
MinInterval=0.1;  % minimum peak-to-peak interval,  us
MaxCombined=30;   % maximum combined peaks allowed for MinInterval
AveragN=20;       % Averaged number of peaks in histogram interval  

HistInterval=20;  % count interval for amplitude and cahrge histograms
ChargeTime=0.5;   % us
DeadTime=1.6;     % us 
tau=0.025;        % us digitizing time
lowf=5;           % MHz,  frequencies higher than lowf may be cut by digital filter

BFitPointsN=3;    %number of points for fitting b
TauFitN=10;       %number of intervals in fitting by time dt=tau/TauFitN
SigmaThr=1;       %Sigma^2 threshold in pulsefiting;      

MaxFrontN=round(MaxFront/tau); MaxTailN=round(MaxTail/tau);
MinFrontN=round(MinFront/tau); MinTailN=round(MinTail/tau);

%%%% Normal distribution  G(x)=exp(-0.5*((x-x0)/sigma)^2)/(2*pi)^0.5/sigma;
%%%% <G(x)>=1; <x*G(x)>=x0; <x^2*G(x)>=sigma^2; 
%%%% x>x0: <G(x)>=0.5; <x*G(x)>=x0+sigma/(2*pi)^0.5; <x^2*G(x)>=0.5*sigma^2; 
%%%% the number of meaurements N at x>k*sigma: 
%%%% k=(0.,0.2,0.4,0.6,0.8,1,1.2,1.4,1.8,2,2.2,2.4,2.6,2.8,3,3.2,3.4,3.6,3.8,4)
%%%% N=(1,0.841,0.689,0.548,0.423,0.317,0.230,0.161,0.0718,0.0455,0.0278,0.0164,0.00932,0.00511,0.00270,0.00137,0.000674,0.000318,0.000145,0.0000633)

%%%% G(x-x0=sigma)=0.607*G(0); G(x-x0=2*sigma)=0.368*G(0)


% frequency range after the fft transformation 
% N - the number of points in a trek
% tau  - measurement period
% fft(trek,N) -> N points in the spectrum in the range grom 0 to 1/tau
% and distanced by 1/tau/N-1. Only (0-1/2/tau) range should be taken into account!!!

if nargin<2 Dialog=true; MaxSignal=4095;  end; 

tic;
if Text  
  if isstr(FileName) trek=load(FileName);  else  trek=FileName;  end; 
else    
  if isstr(FileName) 
     fid = fopen(FileName); trek = fread(fid,inf,'int16'); fclose(fid);  
  else  trek=FileName;  end; 
end; 

if size(trek,2)==1 trek(:,2)=trek; trek(:,1)=(0:tau:tau*(size(trek,1)-1))'; end; 
bool=(trek(:,2)>4095)|(trek(:,2)<0); OutRangeN=size(find(bool),1); 
if OutRangeN>0 fprintf('%7.0f  points out of the ADC range  \n',OutRangeN); end; 
trek(bool,:)=[];  bool=[]; 
trekSize=size(trek(:,1),1);
fprintf('Loading time =                         %7.4f  sec\n', toc); tic; 


% search the signal pedestal and standard deviation 
NoiseArray=logical(ones(trekSize,1));  % first, all measurements are considered as noise
[MeanVal,StdVal,PeakPolarity,NoiseArray]=MeanSearch(trek,OverSt,NoiseArray,0,0); 
%fprintf(' PeakPolarity = %2.0f\n', PeakPolarity);
if PeakPolarity==1 trek(:,2)=trek(:,2)-MeanVal;  else trek(:,2)=MeanVal-trek(:,2); end;    
PolyZero=polyfit(trek(NoiseArray,1),trek(NoiseArray,2),2); 

fprintf('Mean search  =                         %7.4f  sec\n', toc); tic;
fprintf('  Previous mean   = %6.4f\n', MeanVal);
fprintf('  Standard deviat = %6.4f\n', StdVal);


if Plot1  hp=figure;                 
   if isstr(FileName) set(hp,'name',FileName); else set(hp,'name','array');   end; 
   if Plot2|Fourie subplot(2,1,1); end; 
     hold on; grid on; 
     if Dialog TrekPlot0=plot(trek(:,1),trek(:,2),'-b'); end;   % row data
     plot(trek(1:1000:end,1),PolyZero(1)*trek(1:1000:end,1).^2+PolyZero(2)*trek(1:1000:end,1)+PolyZero(3),'-.g','LineWidth',1);
     plot([trek(1,1),trek(end,1)],[OverSt*StdVal,OverSt*StdVal],'-r','LineWidth',1);
     xlabel('t, us');
end;    
 trek(:,2)=trek(:,2)-(PolyZero(1)*trek(:,1).^2+PolyZero(2)*trek(:,1)+PolyZero(3));
 [MeanVal,StdVal,PeakPolarity,NoiseArray]=MeanSearch(trek,OverSt,NoiseArray,0,0); 
 %fprintf(' PeakPolarity = %2.0f\n', PeakPolarity);
 if PeakPolarity==1 trek(:,2)=trek(:,2)-MeanVal;  else trek(:,2)=MeanVal-trek(:,2); end;    
 if Dialog delete(TrekPlot0); TrekPlot0=plot(trek(:,1),trek(:,2),'-b'); end; 
 fprintf('  fitting mean   = %6.4f\n', MeanVal);
 fprintf('  fitting standard deviat = %6.4f\n', StdVal);
 


if Dialog 
    MaxSignal = input('Input the maximum signal level. Higher signals will be cut: \n');  
    if isempty(MaxSignal) MaxSignal = 1.1*max(trek(:,2)); end;
    MaxAmp=MaxSignal; 
    MinTime = input('Input the minimum time.  Peaks before this time will be cut: \n');  
    if isempty(MinTime) MinTime=trek(1,1); end;
    MaxTime = input('Input the maximum time.  Peaks after this time will be cut: \n');  
    if isempty(MaxTime) MaxTime=trek(end,1); end;
    x=[MinTime,MaxTime]; y=[MaxSignal,MaxSignal];   FR1=plot(x,y,'-r','LineWidth',2); 
    x=[MinTime,MinTime]; y=[0,MaxSignal];           FR2=plot(x,y,'-r','LineWidth',2); 
    x=[MaxTime,MaxTime]; y=[0,MaxSignal];           FR3=plot(x,y,'-r','LineWidth',2);     
    %%  Move OutLimits before PolyZero  ???? 
    OutLimits=(trek(:,1)>MaxTime)|(trek(:,1)<MinTime);   %|(trek(:,2)>MaxSignal);
    trek(OutLimits,:)=[];  NoiseArray(OutLimits,:)=[];
    trekSize=size(trek(:,1),1);     
    if Fourie
        spectr=fft(trek(:,2),trekSize)/trekSize;
        spectr(:,2)=spectr(:,1);
        spectr(:,1)=(0:1/tau/(trekSize-1):1/tau)';
        spectr(:,3)=abs(spectr(:,2));
        MaxSpectr0=max(spectr(:,3));
        subplot(2,1,2);
        plot(spectr(:,1),spectr(:,3),'-r'); grid on; hold on;
        plot([lowf,lowf],[0,1.1*MaxSpectr0],'-g');
        axis([0 1/2/tau 0 max(spectr(:,3))]);    xlabel('f, MHz');
        fprintf('fft  =                                 %7.4f  sec\n', toc); tic;
        MaxSpectr = input('     Input the maximum peak amplitude in the high frequency part of the spectrum \n     Peaks will be restricted by this value: \n');  
        if isempty(MaxSpectr)  MaxSpectr=MaxSpectr0; end;    
        x=[lowf,1/2/tau]; y=[MaxSpectr,MaxSpectr];   plot(x,y,'-g'); 
    else
        MaxSpectr=1; MaxSpectr0=0.5;  
    end;     
else 
    MaxAmp=MaxSignal;  MinTime=trek(1,1);  MaxTime=trek(end,1);
    MaxSpectr=1; MaxSpectr0=0.5;    
end; 

% OutLimits=(trek(:,1)>MaxTime)|(trek(:,1)<MinTime);   %|(trek(:,2)>MaxSignal);
% trek(OutLimits,:)=[]; NoiseArray(OutLimits,:)=[];
% trekSize=size(trek(:,1),1); 
    

if MaxSpectr<MaxSpectr0 
    DumpFilter=(spectr(:,1)>lowf)&(spectr(:,3)>MaxSpectr); 
    spectrFilter=spectr; 
    spectrFilter(DumpFilter,2)=MaxSpectr*spectr(DumpFilter,2)./spectr(DumpFilter,3);
            %trekFilter=trek;     trekFilter(:,2)=ifft(spectrFilter(:,2),trekSize); 
    trek(:,2)=ifft(spectrFilter(:,2),trekSize)*1e6; 
   if Plot2|Fourie subplot(2,1,1); end;               
        RealTrekPlot=plot(trek(:,1),real(trek(:,2)),'-r'); hold on; 
        ImagTrekPlot=plot(trek(:,1),imag(trek(:,2)),'-m');
        MaxImag=max(imag(trek(:,2))); 
       
    fprintf('Maximum absolute imaganary part of the filtered signal = %10.5f\n ',MaxImag);  
    fprintf('Imaganary part of the filtered signal will be put zero \n ');  
    fprintf('Pause. look at the filtered signals and press any key  \n');
    if Dialog  pause;  end; 
    tic; 
    trek(:,2)=real(trek(:,2));   
    [MeanVal,StdVal,PeakPolarity,NoiseArray]=MeanSearch(trek,OverSt,NoiseArray,0,0);
    %fprintf(' PeakPolarity = %2.0f\n', PeakPolarity);
    if PeakPolarity==1 trek(:,2)=trek(:,2)-MeanVal;  else  trek(:,2)=MeanVal-trek(:,2); end;  
    fprintf('New mean search  =                 %7.4f  sec\n', toc); tic;
    fprintf('  New mean            = %6.4f\n', MeanVal);
    fprintf('  New standard deviat = %6.4f\n', StdVal);               
end; 
fprintf('Pause. look at the figure and press any key\n');
if Dialog pause;  end; 
    %noise smoothing^
tic;    

SmoothGate=round(AverageGate/tau);
%SmoothedNoise=filter(ones(1,SmoothGate)/SmoothGate,1,trek(NoiseArray,2));
%trek(NoiseArray,2)=SmoothedNoise; 
SmoothedNoise=filter(ones(1,SmoothGate)/SmoothGate,1,trek(:,2));
trek(:,2)=SmoothedNoise; 
[MeanVal,StdVal,PeakPolarity,NoiseArray]=MeanSearch(trek,OverSt,NoiseArray,0,0); 
%fprintf(' PeakPolarity = %2.0f\n', PeakPolarity);
if PeakPolarity==1 trek(:,2)=trek(:,2)-MeanVal;  else trek(:,2)=MeanVal-trek(:,2); end;    
fprintf('  Smoothed mean            = %6.4f\n', MeanVal);
fprintf('  Smoothed standard deviat = %6.4f\n', StdVal);   
if MaxSpectr<MaxSpectr0     delete(TrekPlot0);      delete(ImagTrekPlot);    end; 

delete(TrekPlot0);delete(FR1);delete(FR2);delete(FR3);
TrekPlot0=plot(trek(:,1),trek(:,2),'-b');
fprintf('Pause. look at the figure and press any key\n');
pause;


% search the standard deviation of trekD noises 

    trekR=circshift(trek(:,2),Dshift);   for i=1:Dshift   trekR(i)=trek(i,2);   end; 
    trekL=circshift(trek(:,2),-Dshift);  for i=1:Dshift   trekL(end+1-i)=trek(end+1-i,2);   end; 
    trekD=trek(:,2)-trekR;
    LD=length(trekD);
    trekDR=circshift(trekD,Dshift);   for i=1:Dshift   trekDR(i)=trekD(i);   end; 
    trekDL=circshift(trekD,-Dshift);  for i=1:Dshift   trekDL(end+1-i)=trekD(end+1-i);   end; 
    trekD2=trekD-trekDR;
    LD=length(trekD); 
    %[MeanValD,StdValD,PeakPolarity,NoiseArrayD]=MeanSearch(trek,OverSt,NoiseArray,0,0,trekD);
    StdValD=std(trekD(NoiseArray));
    MeanValD=mean(trekD(NoiseArray));
        
    ThresholdD=StdValD*PeakSt; 
    %ThresholdD=21
    Noise=(abs(trekD)<ThresholdD)&NoiseArray;    
    % !!! remove noises as much as possible, 
    %     but peaks started under Treshold may be missed!!!
    
    % Signal=(abs(trekD)>ThresholdD)|not(NoiseArray); %  remain signals as much as possible
    
    
    %All in start noise    
    NoiseR=circshift(Noise,1);   NoiseR(1)=1;     NoiseL=circshift(Noise,-1);  NoiseL(end)=1; 
    StartNoise=find(Noise-NoiseR==1);   EndNoise=find(Noise-NoiseL==1);  % Noise intervals
    
    if  StartNoise(1)<EndNoise(1)       StartNoise(1)=[];   end;
    if  StartNoise(end)<EndNoise(end)   EndNoise(end)=[];   end;
    %¬се что вначале трека в шум, чтоб не было пиков без началала
    Noise(1:EndNoise(1))=true;  
    %¬се что находитс€ в конце трека в шум, чтоб не было незаконченных пиков  
    Noise(StartNoise(end):end)=true; 
    %«аново ищем начала и концы шумов
    %NoiseR=[];NoiseL=[];
    %NoiseR=circshift(Noise,1);   NoiseR(1)=1;     NoiseL=circshift(Noise,-1);  NoiseL(end)=1; 
    %StartNoise=find(Noise-NoiseR==1);   EndNoise=find(Noise-NoiseL==1);  % Noise intervals

    %if (size(StartNoise,1)>size(EndNoise,1)) StartNoise(end)=[]; end;  
    %if size(EndNoise,1)>size(StartNoise,1)  EndNoise(end)=[]; end;  
                                                                   
                                                                   
    
    %   Signals intervals (include noise edges)
    StartSignal=EndNoise(1:end);   EndSignal=StartNoise(1:end); 
    
    % remove short signal intervals:  
    MoveToNoise=find((EndSignal-StartSignal<2+MinFrontN+MinTailN));
    SizeMoveToNoise=size(MoveToNoise,1);
    for i=1:SizeMoveToNoise; Noise(StartSignal(MoveToNoise(i)):EndSignal(MoveToNoise(i)))=true; end;    
    StartSignal(MoveToNoise)=[]; EndSignal(MoveToNoise)=[];
    SignalN=size(StartSignal,1);
    fprintf('   %3.0f    short signals are removed\n', SizeMoveToNoise); 
    
    % new noise intervals:
    StartNoise=[1;EndSignal];  EndNoise=[StartSignal;trekSize];  
    %remove single noise points: 
    MoveToSignal=find(EndNoise==StartNoise); SizeMoveToSignal=size(MoveToSignal,1);
    for i=1:SizeMoveToSignal; Noise(StartNoise(MoveToSignal(i)))=false; end; 
    StartNoise(MoveToSignal)=[]; EndNoise(MoveToSignal)=[];
    % new Signal intervals:
    StartSignal=EndNoise(1:end-1);   EndSignal=StartNoise(2:end); 
    SignalN=size(StartSignal,1);
    
    %remove slow signals: 
    for i=1:SignalN 
        Slow(i)=(size(find(trekD(StartSignal(i):EndSignal(i))>ThresholdD),1)<2);                  
    end; 
    SlowInd=find(Slow); SlowN=size(SlowInd,2);
    for i=1:size(SlowInd,2); Noise(StartSignal(SlowInd(i)):EndSignal(SlowInd(i)))=true; end; 
    StartSignal(Slow)=[]; EndSignal(Slow)=[]; SignalN=size(StartSignal,1);

    fprintf('   %3.0f    slow signals are removed\n', SlowN);
    
    %remove small signals
    Threshold=StdVal*PeakSt;
    for i=1:SignalN; Range(i)=max(trek(StartSignal(i):EndSignal(i),2))-min(trek(StartSignal(i):EndSignal(i),2)); end;
    MoveToNoise=[]; MoveToNoise=find((Range<Threshold)); 
    SizeMoveToNoise=size(MoveToNoise,2);
    for i=1:SizeMoveToNoise; Noise(StartSignal(MoveToNoise(i)):EndSignal(MoveToNoise(i)))=true; end; 
    StartSignal(MoveToNoise)=[]; EndSignal(MoveToNoise)=[];
    SignalN=size(StartSignal,1);
    fprintf('   %3.0f    small signals are removed\n', SizeMoveToNoise); 
    
    plot(trek(StartSignal,1),trek(StartSignal,2),'g>');
    plot(trek(EndSignal,1),trek(EndSignal,2),'r<');
    fprintf('Pause. look at the figure and press any key\n');
    pause;
    

 
    
    AllSignals=not(Noise); 
    % expansion of peak fronts:
    AllSignals(StartSignal)=true;
    Noise=[]; 
    %Test for matching noise, AllSignals and StartSignal EndSignal    
    
    %Search for max inside signal intervals: 
    PeakInd=[];PeakVal=[];GoodPeakInd=[];GoodPeakVal=[];  
    for i=1:SignalN         
        S=StartSignal(i); E=EndSignal(i);
        %Ќужно различать просто ¬идимые максимумы, коих много и хорошие
        %максимумы. ¬ стандартные пики должны попадать только те, где и видимый
        %и хороший один
        VisiblePeakInd=find((trek(S:E,2)>=trek(S+1:E+1,2))&...
                            (trek(S:E,2)>trek(S-1:E-1,2))&...            
                            (trek(S-1:E-1,2)>trek(S-2:E-2,2)));  % preceeding                
       GoodVisiblePeakInd=find((trek(S:E,2)>=trek(S+1:E+1,2))&...
                            (trek(S:E,2)>trek(S-1:E-1,2))&...            
                            (trek(S-1:E-1,2)>trek(S-2:E-2,2))&...
                            (trek(S:E,2)>trek(S-MinFrontN:E-MinFrontN,2)+MinFrontN*ThresholdD)&...
                            (trek(S:E,2)>trek(S+2:E+2,2)+2*ThresholdD));  % preceeding                
        NumPeaks(i)=size(VisiblePeakInd,1); 
        NumGoodPeaks(i)=size(VisiblePeakInd,1); 
        if NumPeaks(i)==0 [Max,VisiblePeakInd]=max(trek(S:E,2));  end; 
        
        PeakInd=[PeakInd;S+VisiblePeakInd-1];        
        GoodPeakInd=[GoodPeakInd;S+GoodVisiblePeakInd-1];        
        PeakVal=[PeakVal;trek(S+VisiblePeakInd-1,2)]; 
        GoodPeakVal=[GoodPeakVal;trek(S+VisiblePeakInd-1,2)]; 
        [MaxPeak(i),Ind]=max(trek(S+VisiblePeakInd-1,2)); % max signal between S and E
        MaxPeakInd(i)=S+VisiblePeakInd(Ind)-1; 
    end; 
    plot(trek(PeakInd,1),trek(PeakInd,2),'kd');
    plot(trek(GoodPeakInd,1),trek(GoodPeakInd,2),'mo');
    fprintf('Pause. look at the figure and press any key\n');
    pause;
    

    StandardPeaks=find((NumPeaks==1)'&(NumGoodPeaks==1)'&((EndSignal-StartSignal)>=MinFrontN+MinTailN)&(MaxPeak'-trek(StartSignal,2)>=3*Threshold)&(MaxPeak<MaxSignal)');
    StandardPeaksN=size(find(StandardPeaks),1);
    %figure; hold on;
    %for i=1:StandardPeaksN plot(trek(StartSignal(StandardPeaks(i)):EndSignal(StandardPeaks(i)),2));end;
    %pause; 
    
    StandardPulse=zeros(MaxFrontN+MaxTailN,StandardPeaksN);
    %StPF=figure; hold on;
    for i=1:StandardPeaksN 
        Tail=[];
        [PeakStart(i),Idx]=max([StartSignal(StandardPeaks(i)),MaxPeakInd(StandardPeaks(i))-MaxFrontN]);
        [PeakEnd(i),Idx]=min([EndSignal(StandardPeaks(i)),MaxPeakInd(StandardPeaks(i))+MaxTailN]);
        [MaxStPeak(i),MaxStPeakIdx(i)]=max(trek(PeakStart(i):PeakEnd(i),2));
        [MinStPeak(i),MinStPeakIdx(i)]=min(trek(PeakStart(i):PeakEnd(i),2));
        MaxStPeakIdx(i)=PeakStart(i)+MaxStPeakIdx(i)-1;
        MinStPeakIdx(i)=PeakStart(i)+MinStPeakIdx(i)-1;
        StPeakN=size(trek(PeakStart(i):PeakEnd(i),2),1);
        %StandardPulse(1:size(trek(PulseStart(1,i):PulseEnd(1,i),2),1),i)=trek(PulseStart(1,i):PulseEnd(1,i),2);
        
        % –аньше хвост продолжали пр€мой теперь полиномом ecли первое
        % значение меньше последнего
        if MinStPeakIdx(i)>MaxStPeakIdx(i)
           PolyTail=polyfit(1:1:size((PeakStart(i):MaxStPeakIdx(i)-1)',1),trek(PeakStart(i):MaxStPeakIdx(i)-1,2)',1);     
           Tail(1:10)=(PolyTail(1)*(-9:1:0)+PolyTail(2))';
           TailIdx=find(Tail>=trek(MinStPeakIdx(i),2));
           StandardPulse(1:size(TailIdx',1),i)=Tail(TailIdx)';
           if size(TailIdx',1)==0
            StandardPulse(1)=trek(MinStPeakIdx(i),2);     
            TailIdx=1;
           end;
           StandardPulse(size(TailIdx',1)+1:size(TailIdx',1)+StPeakN,i)=trek(PeakStart(i):PeakEnd(i),2);
           StandardPulse(size(TailIdx',1)+StPeakN+1:end,i)=trek(PeakEnd(i),2);
            %figure; hold on;
            %plot(StandardPulse(:,i));
            %plot(1:size(TailIdx',1),Tail(TailIdx),'-ro');
            %pause;
            %close(gcf);
        end;
        if MinStPeakIdx(i)<MaxStPeakIdx(i)
           StandardPulse(1:StPeakN-(MinStPeakIdx(i)-PeakStart(i)),i)=trek(MinStPeakIdx(i):PeakEnd(i),2);
           FitLog=log(trek(MaxStPeakIdx(i)+1:PeakEnd(i),2)-trek(MinStPeakIdx(i),2));
           PolyFitLog=polyfit(1:1:size(FitLog,1),FitLog',1);     
           Tail(1:(MaxFrontN+MaxTailN)-(StPeakN-(MinStPeakIdx(i)-PeakStart(i))))=exp(PolyFitLog(2))*exp(PolyFitLog(1)*((StPeakN-(MinStPeakIdx(i)-PeakStart(i)))+1:MaxFrontN+MaxTailN))+trek(MinStPeakIdx(i),2);
           TailIdx=find(Tail>=trek(MinStPeakIdx(i),2));
           StandardPulse(StPeakN-(MinStPeakIdx(i)-PeakStart(i))+1:StPeakN-(MinStPeakIdx(i)-PeakStart(i))+size(TailIdx',1),i)=Tail(TailIdx)';
           StandardPulse(StPeakN-(MinStPeakIdx(i)-PeakStart(i))+size(TailIdx',1)+1:end,i)=trek(MinStPeakIdx(i),2);
           %figure; hold on;
           %plot(StandardPulse(:,i));
           %plot(StPeakN-(MinStPeakIdx(i)-PeakStart(i))+1:MaxFrontN+MaxTailN,Tail,'-ro'); 
           %pause;
           %close(gcf);
       end;
      
       [MaxSP(i),MaxSPInd(i)]=max(StandardPulse(:,i));
       [MinSP(i),MinSPInd(i)]=min(StandardPulse(:,i));
       RangeSP(i)=MaxSP(i)-MinSP(i); 
     
       
    end;
 %ищем максимальный индекс    
    [MaxIndSP,M]=max(MaxSPInd);
    StandardPulses=zeros(MaxIndSP+MaxTailN,StandardPeaksN);
    StandardPulsesNorm=zeros(MaxIndSP+MaxTailN,StandardPeaksN);
    for i=1:StandardPeaksN 
        StandardPulses(1:MaxIndSP-MaxSPInd(i)+1,i)=StandardPulse(1,i);
        StandardPulsesNorm(1:MaxIndSP-MaxSPInd(i)+1,i)=(StandardPulse(1,i)-MinSP(i))/RangeSP(i);
        StandardPulses(MaxIndSP-MaxSPInd(i)+1:size(StandardPulse(:,i),1)+MaxIndSP-MaxSPInd(i),i)=StandardPulse(:,i);     
        StandardPulsesNorm(MaxIndSP-MaxSPInd(i)+1:size(StandardPulse(:,i),1)+MaxIndSP-MaxSPInd(i),i)=(StandardPulse(:,i)-MinSP(i))/RangeSP(i);     
        StandardPulses(size(StandardPulse(:,i),1)+MaxIndSP-MaxSPInd(i):end,i)=StandardPulse(end,i);
        StandardPulsesNorm(size(StandardPulse(:,i),1)+MaxIndSP-MaxSPInd(i):end,i)=(StandardPulse(end,i)-MinSP(i))/RangeSP(i);
    end;
    
    
    
    %MeanTail=mean(StandardPulse(end-round(MaxTailN/3):end,:),1);
    Pulse=mean(StandardPulses,2);
    [MinPulse,M]=min(Pulse);
    Pulse=Pulse-MinPulse;
    PulseNorm=mean(StandardPulsesNorm,2);
    [MinPulseNorm,M]=min(Pulse);
    PulseNorm=PulseNorm-MinPulseNorm;
    PulseN=size(Pulse,1);
    PulseFit=[];
    [PulseMax,PulseMaxIdx]=max(Pulse);
    PulseOverThr=find(Pulse>Threshold);
    SPF=figure; 
        FPS1=subplot(2,1,1); 
            plot(Pulse,'-bd'); hold on;
            plot([1,size(Pulse,1)],[Threshold,Threshold],'-g','LineWidth',2);  
        subplot(2,1,2);
            plot(Pulse/max(Pulse),'-ro','LineWidth',3);hold on;
            plot(PulseNorm,'-bd','LineWidth',3);
   
    StartFitPoint = input('Input the Start point of pulse for Fitting Points \n Default is first point before Threshold\n');  
        if isempty(StartFitPoint)  StartFitPoint=PulseOverThr(1)-1; end; 
    EndFitPoint = input('Input the end point number from pulse maximum  for Fitting Points \n Default is second point after Max\n');  
        if isempty(EndFitPoint)  EndFitPoint=2; end; 
    StartBFitPoint = input('Input the Start point from maximum  for Fitting Background \n Default is MaxFrontN\n');  
        if isempty(StartBFitPoint)  StartBFitPoint=MaxFrontN; end; 
    BFitPointsN = input('Input number of points for background fitting \n Default is 2\n');  
        if isempty(BFitPointsN)  BFitPointsN=2; end; 

    PulseFitN=PulseMaxIdx+1+EndFitPoint-StartFitPoint;
    PulseFit(1:PulseFitN)=Pulse(StartFitPoint:PulseMaxIdx+EndFitPoint);
    subplot(FPS1);
    plot(StartFitPoint:StartFitPoint+PulseFitN-1,PulseFit,'-m>','LineWidth',3);
    plot(PulseMaxIdx-StartBFitPoint-BFitPointsN+1:PulseMaxIdx-StartBFitPoint,zeros(size((PulseMaxIdx-StartBFitPoint-BFitPointsN+1:PulseMaxIdx-StartBFitPoint)',1),1),'-gd','LineWidth',3);
    fprintf('Pause. look at the figure and press any key\n');
    pause;
    close(SPF);
    
    %AmpSP=rand(100,1).*3;
    %Interv=rand(100,1).*777;
    %trekTest=[];
    %S=1;E=-size(Pulse,1);
    %for i=1:100
    %  S=E+size(Pulse,1)+1;
    %  E=S+round(Interv(i));
    %  NoiseTrT=rand(size((S:E)',1),1);
    %  trekTest(S:E)=3200+(NoiseTrT(1:end,1)-0.5)*StdVal;
    %  trekTest(E+1:E+size(Pulse,1))=3200-Pulse(1:end).*AmpSP(i);
    %end;
    %TTF=figure;
    % plot(trekTest);hold on;
    % plot([1,size(trekTest',1)],[3200,3200],'-k');
    % pause;
    % close(TTF);
    %    fid=fopen('trek000.dat','w'); 
    %    fwrite(fid,trekTest,'int16');
    %    fclose(fid);    
    
  
    
    trekMinus=trek;
    PeakN=size(PeakInd,1);
    GoodPeakN=size(GoodPeakInd,1);
    FitPointsIdx=[];TIdx=[];
    for k=1:TauFitN-1 FitPointsInterp(1:PulseFitN-1,k)=interp1(PulseFit,2-k/TauFitN:1:PulseFitN-k/TauFitN,'spline')';end;
    dT=tau/TauFitN;
    
    for i=1:PeakN
        T=trekMinus(PeakInd(i),1)-tau*(PulseMaxIdx-StartFitPoint+1)+dT:dT:trekMinus(PeakInd(i),1)-tau*(PulseMaxIdx-StartFitPoint-3);
        %figure; hold on;
        %for k=1:TauFitN-1 plot(2-k/TauFitN:1:PulseFitN-k/TauFitN,FitPointsInterp(:,k),'-r.');end;
        %plot(PulseFit,'-go');
        %pause;
        %close(gcf);
        %figure; hold on;
        %for k=1:TauFitN-1 plot(2:PulseFitN,FitPointsInterp(:,k),'-r.');end;
        %plot(PulseFit,'-go');
        %pause;
        %close(gcf);

        A=[];B=[];Sum1=[];Sum2=[];Sum3=[];SigmaFit=[];
        BFit=mean(trekMinus(PeakInd(i)-StartBFitPoint-BFitPointsN+1:PeakInd(i)-StartBFitPoint,2));
        %figure; hold on;
        %[EndIdx,M]=min([PeakInd(i)+PulseN,trekSize]);
        %plot(trekMinus(PeakInd(i)-10:EndIdx,1),trekMinus(PeakInd(i)-10:EndIdx,2),'-b.');
        SigmaSum=zeros(fix(size(T',1)/TauFitN),1);
        n=0;
        for k=1:size(T',1); 
            n=n+1;
            TIdx(k)=fix((T(k)-MinTime+0.0001)/tau);
            %TIdx(k)=round((T(k)-MinTime)/tau);
            %TIdx(k)=ceil((T(k)-MinTime)/tau);
            %fix(TauFitN*mod(T(k),tau)/tau+0.00001)
            if n==TauFitN; 
                FitPoints(1:PulseFitN-1,k)=PulseFit(2:PulseFitN)';
                n=0;
            else 
               FitPoints(1:PulseFitN-1,k)=FitPointsInterp(1:PulseFitN-1,n); 
            end;
            %FitPoints(k,1:PulseFitN-1)=PulseFit(1:PulseFitN-1)*mod(T(k),tau)/tau+PulseFit(2:PulseFitN)*(1-mod(T(k),tau)/tau);
            Sum1(k)=sum(FitPoints(:,k).*trekMinus(TIdx(k)+1:TIdx(k)+PulseFitN-1,2));
            Sum2(k)=sum(FitPoints(:,k));
            Sum3(k)=sum(FitPoints(:,k).*FitPoints(:,k));
            B(k)=BFit;
            %B(k)=sum(trekMinus(TIdx(k)+1:TIdx(k)+PulseFitN-1,2)-FitPoints(k,:)'*Sum1(k)/Sum3(k))/sum(ones(1,PulseFitN-1)-FitPoints(k,:)*Sum2(k)/Sum3(k));
            A(k)=(Sum1(k)-B(k)*Sum2(k))/Sum3(k);
            SigmaFit(k)=sum((trekMinus(TIdx(k)+1:TIdx(k)+PulseFitN-1,2)-A(k)*FitPoints(:,k)-B(k)).^2);
            SigmaSum(ceil(k/TauFitN))=SigmaSum(ceil(k/TauFitN))+SigmaFit(k);
            %plot(trekMinus(TIdx(k)+1:TIdx(k)+PulseFitN-1,1),A(k)*FitPoints(:,k)+B(k),'-r.');    
            %plot(T(k):tau:T(k)+(PulseFitN-2)*tau,A(k)*PulseFit(2:PulseFitN)+B(k),'-go');    
            %pause;    
        end;
        %close(gcf);
        [MinSigmaSum,MinSigmaSumIdx]=min(SigmaSum);
        [MinSigma(i),MinSigmaIdx(i)]=min(SigmaFit((MinSigmaSumIdx-1)*TauFitN+1:MinSigmaSumIdx*TauFitN));
        MinSigmaIdx(i)=MinSigmaIdx(i)+(MinSigmaSumIdx-1)*TauFitN;
        %PolySigma=[];
        %PolySigma=polyfit((MinSigmaIdx(i)-2:1:MinSigmaIdx(i)+2),SigmaFit(MinSigmaIdx(i)-2:MinSigmaIdx(i)+2),2);
       
        FitPulse=[];
        FitPulse(1:PulseN-1)=A(MinSigmaIdx(i))*(Pulse(1:end-1)*mod(T(MinSigmaIdx(i)),tau)/tau+Pulse(2:end)*(1-mod(T(MinSigmaIdx(i)),tau)/tau))+B(MinSigmaIdx(i));
        FitPulseM=[];
        FitPulseM(1:PulseN-1)=A(MinSigmaIdx(i))*(Pulse(1:end-1)*mod(T(MinSigmaIdx(i)),tau)/tau+Pulse(2:end)*(1-mod(T(MinSigmaIdx(i)),tau)/tau));
        
        
            %figure; hold on;
            %figure; 
            %subplot(2,1,1);hold on;
            % plot(SigmaFit/((PulseFitN-1)*StdVal^2),'-b.');
            % plot(MinSigmaIdx(i),SigmaFit(MinSigmaIdx(i))/((PulseFitN-1)*StdVal^2),'ro');
            %subplot(2,1,2); hold on;
            %plot(trekMinus(PeakInd(i),1),trekMinus(PeakInd(i),2),'md');
         [EndIdx,M]=min([PeakInd(i)+PulseN,trekSize]);
            %plot(trekMinus(PeakInd(i)-10:EndIdx,1),trekMinus(PeakInd(i)-10:EndIdx,2),'-b.');
            %plot(T(MinSigmaIdx(i))-tau:tau:T(MinSigmaIdx(i))+tau*(PulseFitN-2),A(MinSigmaIdx(i))*PulseFit+B(MinSigmaIdx(i)),'-ro','LineWidth',2);
            %plot(trekMinus(TIdx(MinSigmaIdx(i))+1:TIdx(MinSigmaIdx(i))+PulseFitN-1,1),A(MinSigmaIdx(i))*FitPoints(:,MinSigmaIdx(i))+B(MinSigmaIdx(i)),'-md');
         [EndIdx,M]=min([TIdx(MinSigmaIdx(i))-StartFitPoint+PulseN,trekSize]);
            %plot(trekMinus(TIdx(MinSigmaIdx(i))-StartFitPoint+2:EndIdx,1),FitPulse(1:EndIdx-(TIdx(MinSigmaIdx(i))-StartFitPoint+1)),'-g>');         
            %plot(trekMinus(TIdx(MinSigmaIdx(i))-StartFitPoint+2:EndIdx,1),FitPulseM(1:EndIdx-(TIdx(MinSigmaIdx(i))-StartFitPoint+1)),'-k');
            %plot([trekMinus(TIdx(MinSigmaIdx(i))-StartFitPoint+2,1),trekMinus(EndIdx,1)],[B(MinSigmaIdx(i)),B(MinSigmaIdx(i))],'-k');
         if MinSigma(i)/((PulseFitN-1)*StdVal^2)<SigmaThr
             trekMinus(TIdx(MinSigmaIdx(i))-StartFitPoint+2:EndIdx,2)=trekMinus(TIdx(MinSigmaIdx(i))-StartFitPoint+2:EndIdx,2)-FitPulseM(1:EndIdx-(TIdx(MinSigmaIdx(i))-StartFitPoint+1))';   
         end;
         [EndIdx,M]=min([PeakInd(i)+PulseN,trekSize]);
            %plot(trekMinus(PeakInd(i)-10:EndIdx,1),trekMinus(PeakInd(i)-10:EndIdx,2),'-r');
            %pause;
            %close(gcf);

    end;
  figure(hp);       
  plot(trekMinus(:,1),trekMinus(:,2),'-r'); 
  SF=figure;
  plot(trek(PeakInd(:),1),MinSigma(:)/((PulseFitN-1)*StdVal^2),'-m.');
  pause;
  close(SF);
  close(hp);
  
  PeakPolarity=1;
  trekOld=trek;
  trek=trekMinus;
  NoiseArray=logical(ones(trekSize,1));  % first, all measurements are considered as noise
  [MeanVal,StdVal,PeakPolarity,NoiseArray]=MeanSearch(trek,OverSt,NoiseArray,0,0); 
 
 if PeakPolarity==1 trek(:,2)=trek(:,2)-MeanVal;  else trek(:,2)=MeanVal-trek(:,2); end;    
 PolyZero=polyfit(trek(NoiseArray,1),trek(NoiseArray,2),2); 

 fprintf('Mean search  =                         %7.4f  sec\n', toc); tic;
 fprintf('  Previous mean   = %6.4f\n', MeanVal);
 fprintf('  Standard deviat = %6.4f\n', StdVal);


 if Plot1  hp=figure;                 
   if isstr(FileName) set(hp,'name',FileName); else set(hp,'name','array');   end; 
     hold on; grid on; 
     TrekPlot0=plot(trek(:,1),trek(:,2),'-b');
     plot(trek(1:1000:end,1),PolyZero(1)*trek(1:1000:end,1).^2+PolyZero(2)*trek(1:1000:end,1)+PolyZero(3),'-.g','LineWidth',1);
     plot([trek(1,1),trek(end,1)],[OverSt*StdVal,OverSt*StdVal],'-r','LineWidth',1);
     xlabel('t, us');
end;    
 trek(:,2)=trek(:,2)-(PolyZero(1)*trek(:,1).^2+PolyZero(2)*trek(:,1)+PolyZero(3));
 [MeanVal,StdVal,PeakPolarity,NoiseArray]=MeanSearch(trek,OverSt,NoiseArray,0,0); 
 %fprintf(' PeakPolarity = %2.0f\n', PeakPolarity);
 if PeakPolarity==1 trek(:,2)=trek(:,2)-MeanVal;  else trek(:,2)=MeanVal-trek(:,2); end;    

 % search the standard deviation of trekD noises 

    trekR=circshift(trek(:,2),Dshift);   for i=1:Dshift   trekR(i)=trek(i,2);   end; 
    trekL=circshift(trek(:,2),-Dshift);  for i=1:Dshift   trekL(end+1-i)=trek(end+1-i,2);   end; 
    trekD=trek(:,2)-trekR;
    LD=length(trekD);
    trekDR=circshift(trekD,Dshift);   for i=1:Dshift   trekDR(i)=trekD(i);   end; 
    trekDL=circshift(trekD,-Dshift);  for i=1:Dshift   trekDL(end+1-i)=trekD(end+1-i);   end; 
    trekD2=trekD-trekDR;
    LD=length(trekD); 
    %[MeanValD,StdValD,PeakPolarity,NoiseArrayD]=MeanSearch(trek,OverSt,NoiseArray,0,0,trekD);
    StdValD=std(trekD(NoiseArray));
    MeanValD=mean(trekD(NoiseArray));
        
    ThresholdD=StdValD*PeakSt; 
    %ThresholdD=21
    Noise=(abs(trekD)<ThresholdD)&NoiseArray;    
    % !!! remove noises as much as possible, 
    %     but peaks started under Treshold may be missed!!!
    
    % Signal=(abs(trekD)>ThresholdD)|not(NoiseArray); %  remain signals as much as possible
    
    StartSignal=[];EndSignal=[];StartNoise=[];EndNoise=[];
    %All in start noise    
    NoiseR=circshift(Noise,1);   NoiseR(1)=1;     NoiseL=circshift(Noise,-1);  NoiseL(end)=1; 
    StartNoise=find(Noise-NoiseR==1);   EndNoise=find(Noise-NoiseL==1);  % Noise intervals
    
    if  StartNoise(1)<EndNoise(1)       StartNoise(1)=[];   end;
    if  StartNoise(end)<EndNoise(end)   EndNoise(end)=[];   end;
    %¬се что вначале трека в шум, чтоб не было пиков без началала
    Noise(1:EndNoise(1))=true;  
    %¬се что находитс€ в конце трека в шум, чтоб не было незаконченных пиков  
    Noise(StartNoise(end):end)=true; 
    
    %   Signals intervals (include noise edges)
    StartSignal=EndNoise(1:end);   EndSignal=StartNoise(1:end); 
    
    % remove short signal intervals:  
    MoveToNoise=find((EndSignal-StartSignal<2+MinFrontN+MinTailN));
    SizeMoveToNoise=size(MoveToNoise,1);
    for i=1:SizeMoveToNoise; Noise(StartSignal(MoveToNoise(i)):EndSignal(MoveToNoise(i)))=true; end;    
    StartSignal(MoveToNoise)=[]; EndSignal(MoveToNoise)=[];
    SignalN=size(StartSignal,1);
    fprintf('   %3.0f    short signals are removed\n', SizeMoveToNoise); 
    
    % new noise intervals:
    StartNoise=[1;EndSignal];  EndNoise=[StartSignal;trekSize];  
    %remove single noise points: 
    MoveToSignal=find(EndNoise==StartNoise); SizeMoveToSignal=size(MoveToSignal,1);
    for i=1:SizeMoveToSignal; Noise(StartNoise(MoveToSignal(i)))=false; end; 
    StartNoise(MoveToSignal)=[]; EndNoise(MoveToSignal)=[];
    % new Signal intervals:
    StartSignal=EndNoise(1:end-1);   EndSignal=StartNoise(2:end); 
    SignalN=size(StartSignal,1);
   
    clear Slow;    
    %remove slow signals: 
    for i=1:SignalN 
        Slow(i)=(size(find(trekD(StartSignal(i):EndSignal(i))>ThresholdD),1)<2);                  
    end; 
    SlowInd=find(Slow); SlowN=size(SlowInd,2);
    for i=1:size(SlowInd,2); Noise(StartSignal(SlowInd(i)):EndSignal(SlowInd(i)))=true; end; 
    if ~isempty(Slow)  StartSignal(Slow)=[]; EndSignal(Slow)=[]; SignalN=size(StartSignal,1);end;

    fprintf('   %3.0f    slow signals are removed\n', SlowN);
    
    %remove small signals
    Threshold=StdVal*PeakSt;
    for i=1:SignalN; Range(i)=max(trek(StartSignal(i):EndSignal(i),2))-min(trek(StartSignal(i):EndSignal(i),2)); end;
    MoveToNoise=[]; MoveToNoise=find((Range<Threshold)); 
    SizeMoveToNoise=size(MoveToNoise,2);
    for i=1:SizeMoveToNoise; Noise(StartSignal(MoveToNoise(i)):EndSignal(MoveToNoise(i)))=true; end; 
    StartSignal(MoveToNoise)=[]; EndSignal(MoveToNoise)=[];
    SignalN=size(StartSignal,1);
    fprintf('   %3.0f    small signals are removed\n', SizeMoveToNoise); 
    
    plot(trek(StartSignal,1),trek(StartSignal,2),'g>');
    plot(trek(EndSignal,1),trek(EndSignal,2),'r<');
    fprintf('Pause. look at the figure and press any key\n');
    pause;
    

 
    
    AllSignals=not(Noise); 
    % expansion of peak fronts:
    AllSignals(StartSignal)=true;
    Noise=[]; 
    %Test for matching noise, AllSignals and StartSignal EndSignal    
    
    %Search for max inside signal intervals: 
    PeakInd=[];PeakVal=[];GoodPeakInd=[];GoodPeakVal=[];  
    for i=1:SignalN         
        S=StartSignal(i); E=EndSignal(i);
        %Ќужно различать просто ¬идимые максимумы, коих много и хорошие
        %максимумы. ¬ стандартные пики должны попадать только те, где и видимый
        %и хороший один
        VisiblePeakInd=find((trek(S:E,2)>=trek(S+1:E+1,2))&...
                            (trek(S:E,2)>trek(S-1:E-1,2))&...            
                            (trek(S-1:E-1,2)>trek(S-2:E-2,2)));  % preceeding                
       GoodVisiblePeakInd=find((trek(S:E,2)>=trek(S+1:E+1,2))&...
                            (trek(S:E,2)>trek(S-1:E-1,2))&...            
                            (trek(S-1:E-1,2)>trek(S-2:E-2,2))&...
                            (trek(S:E,2)>trek(S-MinFrontN:E-MinFrontN,2)+MinFrontN*ThresholdD)&...
                            (trek(S:E,2)>trek(S+2:E+2,2)+2*ThresholdD));  % preceeding                
        NumPeaks(i)=size(VisiblePeakInd,1); 
        NumGoodPeaks(i)=size(VisiblePeakInd,1); 
        if NumPeaks(i)==0 [Max,VisiblePeakInd]=max(trek(S:E,2));  end; 
        
        PeakInd=[PeakInd;S+VisiblePeakInd-1];        
        GoodPeakInd=[GoodPeakInd;S+GoodVisiblePeakInd-1];        
        PeakVal=[PeakVal;trek(S+VisiblePeakInd-1,2)]; 
        GoodPeakVal=[GoodPeakVal;trek(S+VisiblePeakInd-1,2)]; 
        [MaxPeak(i),Ind]=max(trek(S+VisiblePeakInd-1,2)); % max signal between S and E
        MaxPeakInd(i)=S+VisiblePeakInd(Ind)-1; 
    end; 
    plot(trek(PeakInd,1),trek(PeakInd,2),'kd');
    plot(trek(GoodPeakInd,1),trek(GoodPeakInd,2),'mo');
    fprintf('Pause. look at the figure and press any key\n');
    pause;
   
    
    trekMinus=trek;
    PeakN=size(PeakInd,1);
    GoodPeakN=size(GoodPeakInd,1);
    FitPointsIdx=[];TIdx=[];
    for k=1:TauFitN-1 FitPointsInterp(1:PulseFitN-1,k)=interp1(PulseFit,2-k/TauFitN:1:PulseFitN-k/TauFitN,'spline')';end;
    dT=tau/TauFitN;
    
    for i=1:PeakN
        T=trekMinus(PeakInd(i),1)-tau*(PulseMaxIdx-StartFitPoint+1)+dT:dT:trekMinus(PeakInd(i),1)-tau*(PulseMaxIdx-StartFitPoint-3);
        %figure; hold on;
        %for k=1:TauFitN-1 plot(2-k/TauFitN:1:PulseFitN-k/TauFitN,FitPointsInterp(:,k),'-r.');end;
        %plot(PulseFit,'-go');
        %pause;
        %close(gcf);
        %figure; hold on;
        %for k=1:TauFitN-1 plot(2:PulseFitN,FitPointsInterp(:,k),'-r.');end;
        %plot(PulseFit,'-go');
        %pause;
        %close(gcf);

        A=[];B=[];Sum1=[];Sum2=[];Sum3=[];SigmaFit=[];
        BFit=mean(trekMinus(PeakInd(i)-StartBFitPoint-BFitPointsN+1:PeakInd(i)-StartBFitPoint,2));
        %figure; hold on;
        %[EndIdx,M]=min([PeakInd(i)+PulseN,trekSize]);
        %plot(trekMinus(PeakInd(i)-10:EndIdx,1),trekMinus(PeakInd(i)-10:EndIdx,2),'-b.');
        SigmaSum=zeros(fix(size(T',1)/TauFitN),1);
        n=0;
        for k=1:size(T',1); 
            n=n+1;
            TIdx(k)=fix((T(k)-MinTime+0.0001)/tau);
            %TIdx(k)=round((T(k)-MinTime)/tau);
            %TIdx(k)=ceil((T(k)-MinTime)/tau);
            %fix(TauFitN*mod(T(k),tau)/tau+0.00001)
            if n==TauFitN; 
                FitPoints(1:PulseFitN-1,k)=PulseFit(2:PulseFitN)';
                n=0;
            else 
               FitPoints(1:PulseFitN-1,k)=FitPointsInterp(1:PulseFitN-1,n); 
            end;
            %FitPoints(k,1:PulseFitN-1)=PulseFit(1:PulseFitN-1)*mod(T(k),tau)/tau+PulseFit(2:PulseFitN)*(1-mod(T(k),tau)/tau);
            Sum1(k)=sum(FitPoints(:,k).*trekMinus(TIdx(k)+1:TIdx(k)+PulseFitN-1,2));
            Sum2(k)=sum(FitPoints(:,k));
            Sum3(k)=sum(FitPoints(:,k).*FitPoints(:,k));
            B(k)=BFit;
            %B(k)=sum(trekMinus(TIdx(k)+1:TIdx(k)+PulseFitN-1,2)-FitPoints(k,:)'*Sum1(k)/Sum3(k))/sum(ones(1,PulseFitN-1)-FitPoints(k,:)*Sum2(k)/Sum3(k));
            A(k)=(Sum1(k)-B(k)*Sum2(k))/Sum3(k);
            SigmaFit(k)=sum((trekMinus(TIdx(k)+1:TIdx(k)+PulseFitN-1,2)-A(k)*FitPoints(:,k)-B(k)).^2);
            SigmaSum(ceil(k/TauFitN))=SigmaSum(ceil(k/TauFitN))+SigmaFit(k);
            %plot(trekMinus(TIdx(k)+1:TIdx(k)+PulseFitN-1,1),A(k)*FitPoints(:,k)+B(k),'-r.');    
            %plot(T(k):tau:T(k)+(PulseFitN-2)*tau,A(k)*PulseFit(2:PulseFitN)+B(k),'-go');    
            %pause;    
        end;
        %close(gcf);
        [MinSigmaSum,MinSigmaSumIdx]=min(SigmaSum);
        [MinSigma(i),MinSigmaIdx(i)]=min(SigmaFit((MinSigmaSumIdx-1)*TauFitN+1:MinSigmaSumIdx*TauFitN));
        MinSigmaIdx(i)=MinSigmaIdx(i)+(MinSigmaSumIdx-1)*TauFitN;
        %PolySigma=[];
        %PolySigma=polyfit((MinSigmaIdx(i)-2:1:MinSigmaIdx(i)+2),SigmaFit(MinSigmaIdx(i)-2:MinSigmaIdx(i)+2),2);
       
        FitPulse=[];
        FitPulse(1:PulseN-1)=A(MinSigmaIdx(i))*(Pulse(1:end-1)*mod(T(MinSigmaIdx(i)),tau)/tau+Pulse(2:end)*(1-mod(T(MinSigmaIdx(i)),tau)/tau))+B(MinSigmaIdx(i));
        FitPulseM=[];
        FitPulseM(1:PulseN-1)=A(MinSigmaIdx(i))*(Pulse(1:end-1)*mod(T(MinSigmaIdx(i)),tau)/tau+Pulse(2:end)*(1-mod(T(MinSigmaIdx(i)),tau)/tau));
        
        
            figure; hold on;
            %figure; 
            subplot(2,1,1);hold on;
             plot(SigmaFit/((PulseFitN-1)*StdVal^2),'-b.');
             plot(MinSigmaIdx(i),SigmaFit(MinSigmaIdx(i))/((PulseFitN-1)*StdVal^2),'ro');
            subplot(2,1,2); hold on;
            plot(trekMinus(PeakInd(i),1),trekMinus(PeakInd(i),2),'md');
         [EndIdx,M]=min([PeakInd(i)+PulseN,trekSize]);
            plot(trekMinus(PeakInd(i)-10:EndIdx,1),trekMinus(PeakInd(i)-10:EndIdx,2),'-b.');
            plot(T(MinSigmaIdx(i))-tau:tau:T(MinSigmaIdx(i))+tau*(PulseFitN-2),A(MinSigmaIdx(i))*PulseFit+B(MinSigmaIdx(i)),'-ro','LineWidth',2);
            plot(trekMinus(TIdx(MinSigmaIdx(i))+1:TIdx(MinSigmaIdx(i))+PulseFitN-1,1),A(MinSigmaIdx(i))*FitPoints(:,MinSigmaIdx(i))+B(MinSigmaIdx(i)),'-md');
         [EndIdx,M]=min([TIdx(MinSigmaIdx(i))-StartFitPoint+PulseN,trekSize]);
            plot(trekMinus(TIdx(MinSigmaIdx(i))-StartFitPoint+2:EndIdx,1),FitPulse(1:EndIdx-(TIdx(MinSigmaIdx(i))-StartFitPoint+1)),'-g>');         
            plot(trekMinus(TIdx(MinSigmaIdx(i))-StartFitPoint+2:EndIdx,1),FitPulseM(1:EndIdx-(TIdx(MinSigmaIdx(i))-StartFitPoint+1)),'-k');
            plot([trekMinus(TIdx(MinSigmaIdx(i))-StartFitPoint+2,1),trekMinus(EndIdx,1)],[B(MinSigmaIdx(i)),B(MinSigmaIdx(i))],'-k');
         if MinSigma(i)/((PulseFitN-1)*StdVal^2)<SigmaThr
             trekMinus(TIdx(MinSigmaIdx(i))-StartFitPoint+2:EndIdx,2)=trekMinus(TIdx(MinSigmaIdx(i))-StartFitPoint+2:EndIdx,2)-FitPulseM(1:EndIdx-(TIdx(MinSigmaIdx(i))-StartFitPoint+1))';   
         end;
         [EndIdx,M]=min([PeakInd(i)+PulseN,trekSize]);
            plot(trekMinus(PeakInd(i)-10:EndIdx,1),trekMinus(PeakInd(i)-10:EndIdx,2),'-r');
            pause;
            close(gcf);

    end;
  figure(hp);       
  plot(trekMinus(:,1),trekMinus(:,2),'-r'); 
  SF=figure;
  plot(trek(PeakInd(:),1),MinSigma(:)/((PulseFitN-1)*StdVal^2),'-m.');
  pause;
  close(SF);
  close(hp);

  
%peak amplitude histogram
MaxAmpl=max(peaks(:,5));
MinAmpl=0; %min(peaks(:,4));
PeakAmplRange=MaxAmpl-MinAmpl; 
HistIntervalA=HistInterval; %   =PeakAmplRange/HistN;       % interval for amplitudes
%HistN=fix(NPeaks/AveragN);  
HistN=fix(PeakAmplRange/HistIntervalA)+1;  
if HistN==0; HistN=1; end;     % the number of intervals 

for i=1:HistN
    HistA(i,1)=MinAmpl+(i-0.5)*HistIntervalA; 
    HistBool=(peaks(:,5)<HistA(i,1)+HistIntervalA/2)&...
             (peaks(:,5)>=HistA(i,1)-HistIntervalA/2);
    HistA(i,2)=size(peaks(HistBool,1),1);  %peak aplitude
    HistA(i,3)=sqrt(HistA(i,2));           %peak aplitude error
end;
% ZeroBool=HistA(:,2)==0; 
% HistA(ZeroBool,:)=[]; 


%peak interval histogram
MaxT=max(peaks(:,3));
MinT=min(peaks(:,3));
PeakTRange=MaxT-MinT; 
HistIntervalT=PeakTRange/HistN;          % interval for T
for i=1:HistN
    HistT(i,1)=MinT+(i-0.5)*HistIntervalT;
    HistBool=(peaks(:,3)<HistT(i,1)+HistIntervalT/2)&...
             (peaks(:,3)>=HistT(i,1)-HistIntervalT/2);
    HistT(i,2)=size(peaks(HistBool,1),1);    %peak-to-peak intervals    
end;
ZeroBool=HistT(:,2)==0; 
HistT(ZeroBool,:)=[];

%peak 'charge'  histogram
MaxC=max(peaks(:,6));
MinC=0; %   min(peaks(:,6));
PeakCRange=MaxC-MinC; 
HistIntervalC=HistInterval; %  =PeakCRange/HistN;          % Charge
HistN=fix(PeakCRange/HistIntervalC)+1;  
for i=1:HistN
    HistC(i,1)=MinC+(i-0.5)*HistIntervalC; 
    HistBool=(peaks(:,6)<HistC(i,1)+HistIntervalC/2)&...
             (peaks(:,6)>=HistC(i,1)-HistIntervalC/2);
    HistC(i,2)=size(peaks(HistBool,1),1);    % peak charge
    HistC(i,3)=sqrt(HistC(i,2));             %peak charge error
end;
% ZeroBool=HistC(:,2)==0; 
% HistC(ZeroBool,:)=[];


%Poisson interval distribution
test=rand(NPeaks,1)*(trek(end,1)-trek(1,1));
Poisson=sort(test); 
Poisson=circshift(Poisson,-1)-Poisson;
MeanP=mean(Poisson(1:end-1));
Poisson(end)=MeanP; 
MaxP=max(Poisson);
MinP=min(Poisson);
PeakPRange=MaxP-MinP; 
HistIntervalP=HistIntervalT;                   % interval for T
for i=1:HistN
    HistP(i,1)=MinP+(i-0.5)*HistIntervalP; 
    HistBool=(Poisson<HistP(i,1)+HistIntervalP/2)&...
             (Poisson>=HistP(i,1)-HistIntervalP/2);
    HistP(i,2)=size(Poisson(HistBool),1);           %peak-to-peak intervals
end;
if Plot2   
  subplot(2,1,2); hold on; grid on; 
                semilogy(peaks(:,2),peaks(:,2)-peaks(:,1),'-r.');  %front
                %semilogy(peaks(:,1),peaks(:,7),'-y.');             %peak or front duration, us
                semilogy(peaks(:,1),peaks(:,3),'-b.');             %peak-to-peak
                semilogy(peaks(:,1),(peaks(:,8)-1),'md','MarkerFaceColor','y','MarkerSize',5);  % combined peaks                                           
                x=[trek(1,1),trek(end,1)]; 
                y=[tau,tau]; semilogy(x,y,'-g','LineWidth',1.5);                
                y=[ChargeTime,ChargeTime]; semilogy(x,y,'-g','LineWidth',1.5);                
                axis([MinTime,MaxTime,tau,1.2*max(peaks(:,3))]);
                set(gca,'ytick',[0.01 0.1 1 10 100 1000])
                xlabel('t, us'); ylabel('front & interval, us');                 
                legend('front', 'duration', 'interval to next',0);
end; 

hp=figure; 
if isstr(FileName) set(hp,'name',[FileName,' spectra'] );  else
                   set(hp,'name','array spectra');   end; 
% subplot(3,2,1); plot(trek(:,2),trek(:,5),'-b'); hold on; grid on; 
%                 plot(peaks(:,1),peaks(:,2),'ro');
%                 plot(trek(:,1),EdgeBool*50,'-g');
%                 x=[trek(1,1),trek(end,1)];
%                 Threshold=[Threshold,Threshold];
%                 plot(x,Threshold,'-m');
%                 plot(x,-Threshold,'-m');
%                 axis([MinTime,MaxTime,-StdVal*PeakSt,MaxAmp+StdVal*PeakSt]);
%                 xlabel('t, us'); ylabel('counts');                 
                
subplot(2,2,1); semilogy(HistA(:,1),HistA(:,2),'-ro'); hold on; grid on; 
                x=[Threshold,Threshold]; y=[1,max(HistA(:,2))];
                semilogy(x,y,'-b');
                axis([0,max(HistA(:,1)),1,1.2*max(HistA(:,2))]);
                xlabel('peak, counts'); ylabel('numbers');                                
                                       
subplot(2,2,2); semilogy(peaks(:,5),peaks(:,2)-peaks(:,1),'r^','MarkerFaceColor','r','MarkerSize',4);    % peak front(peak amplitude)
                grid on; hold on;      
                semilogy(peaks(:,5),peaks(:,7),'yd','MarkerFaceColor','y','MarkerSize',4);   % peak or front durat (peak amplitude)                
                semilogy(peaks(:,5),circshift(peaks(:,3),1),'b^','MarkerSize',4);     % peak interval (peak amplitude)                
                semilogy(peaks(:,6),circshift(peaks(:,3),1),'m^','MarkerSize',4);     % peak interval (peak amplitude)                                
                x=[0,max(max(peaks(:,5)),max(peaks(:,6)))]; 
                y=[tau,tau];   semilogy(x,y,'-r','LineWidth',1.5);                
                y=[ChargeTime,ChargeTime]; semilogy(x,y,'-g','LineWidth',1.5);                
                y=[Period,Period]; semilogy(x,y,'-b','LineWidth',1.5);                                
                axis([0,max(max(peaks(:,5)),max(peaks(:,6))),0.01,1.2*max(max(peaks(:,2)-peaks(:,1)),max(peaks(:,3)))]);
                xlabel('peak, counts'); ylabel('front & intervals, us'); 
                legend('front', 'duration', 'preceed interval',0); 
              
subplot(2,2,3); %Preceed=circshift(peaks(:,4),1);  Preceed(1)=0; 
                %semilogy(peaks(:,2),Preceed(:),'go');  grid on; hold on;   % preceed peak interval(peak amplitude)
                %semilogy(peaks(:,2),peaks(:,5),'bo');  grid on; hold on;   % peak interval(peak amplitude)                
                %x=[min(peaks(:,2)),max(trek(:,2))]; y=[tau,tau];
                %semilogy(x,y,'-r'); 
                %y=[Period,Period];
                %semilogy(x,y,'-r');                
                %axis([0,max(peaks(:,2)),tau,1.5*max(Preceed)]);
                %xlabel('peak, counts'); ylabel('peak-to-peak & interval, us');                 
                
                semilogy(HistC(:,1),HistC(:,2),'-ro'); grid on; 
                axis([0,max(HistC(:,1)),1,1.2*max(HistC(:,2))]);
                xlabel('charge, a.u.'); ylabel('numbers');                 

subplot(2,2,4); semilogy(HistT(:,1),HistT(:,2),'-go'); grid on; hold on; 
                semilogy(HistP(:,1),HistP(:,2),'-r');    
                x=[(trek(end,1)-trek(1,1))/NPeaks,(trek(end,1)-trek(1,1))/NPeaks];
                y=[1,NPeaks*HistIntervalP/Period];
                semilogy(x,y,'-r^');
                axis([0,max(HistT(:,1)),1,1.2*max([max(HistT(:,2)),max(HistP(:,2)),y(2)])]);
                xlabel('peak interval, us'); ylabel('exp & Poisson, numbers');                 
fprintf('---------------------\n');                
fprintf('Peak threshold =  %3.3f\n', Threshold);
fprintf('The number of peaks =  %5.0f\n', NPeaks);
fprintf('The period of peaks =  %6.4f ms\n', Period/1000);
fprintf('Resolution in the peak amplitude histogram=  %3.3f counts\n', HistIntervalA);
fprintf('Resolution in the peak interval histogram=  %3.3f us\n', HistIntervalT);
fprintf('Expected number of double peaks for 0.025 us = %3.3f \n', NPeaks*0.025/Period);
fprintf('Expected number of double peaks for %5.3f us = %5.3f \n', MinInterval, NPeaks*MinInterval/Period);
%fprintf('Detected number of double peaks for %5.3f us = %5.3f \n', MinInterval, size(find(peaks(:,end)==2)));
fprintf('Expected number of triple peaks for %5.3f us = %5.3f \n', MinInterval, NPeaks*(MinInterval/Period)^2/2);
%fprintf('Detected number of triple peaks for %5.3f us = %5.3f \n', MinInterval, size(find(peaks(:,end)==2)));
fprintf('The selected number of double peaks for %5.3f us = %3.0f \n', MinInterval, DoublePeakNum);
fprintf('The selected number of triple peaks for %5.3f us = %3.0f \n', MinInterval, TriplePeakNum);
fprintf('=====================\n');                

if isstr(FileName) HistAFile=FileName; HistAFile(1:4)='hisA'; 
   else HistAFile='HistA.dat'; end; 
fid=fopen(HistAFile,'w'); 
fprintf(fid,'%6.2f %3.0f %5.2f\n' ,HistA');
fclose(fid);    
if isstr(FileName) HistCFile=FileName; HistCFile(1:4)='hisC'; 
   else HistCFile='HistC.dat'; end; 
fid=fopen(HistCFile,'w'); 
fprintf(fid,'%6.2f %3.0f %5.2f\n' ,HistC');
fclose(fid);    

if isstr(FileName) PeakFile=FileName;  PeakFile(1:4)='peak'; 
   else PeakFile='peaks.dat'; end; 
%if isstr(FileName)&&strcmp(PeakFile,FileName) PeakFile=['Peaks',FileName]; end; 

fid=fopen(PeakFile,'w');
fprintf(fid,'start       peak      interv      zero  ampl    charge duration CombN\n'); 
fprintf(fid,'%10.3f %10.3f %9.3f %7.2f %7.2f %7.2f %5.3f %2.0f \n' ,peaks');
fclose(fid);    




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [MeanVal,StdVal,PP,Noise]=MeanSearch(tr,OverSt,Noise,Plot1,Plot2,trD);    
% search the signal pedestal and make it zero
           % Input parameters: tr or trD - input measurements, Over St (see above), Noise - assumed initial noise array  
           % Output parameters: MeanValue, Standad deviation, Pulse polarity, Noise - residual noise array
if nargin<4     Plot1=false;    Plot2=false;    end;  
if nargin<5     Plot2=false;    end;  
trSize=size(tr(:,1)); %  (N,1) dimension
trSize=trSize(1);

% if nargin==6    MaxVal=max(trD);     MinVal=min(trD);     DeltaM=MaxVal-MinVal; 
%          else   MaxVal=max(tr(:,2)); MinVal=min(tr(:,2)); DeltaM=MaxVal-MinVal;  end; 
% if nargin==6    M =mean(trD);     St=std(trD);     
%          else   M =mean(tr(:,2)); St=std(tr(:,2));   end; 

if nargin==6    M =mean(trD);     St=std(trD);
         else   M =mean(tr(:,2)); St=std(tr(:,2));   end;

if nargin==6    Positive=size(find(trD-(M+5*St)>0),1);  Negative=size(find(trD-(M-5*St)<0),1); 
                MaxVal=max(trD);     MinVal=min(trD);   DeltaM=MaxVal-MinVal; 
         else   Positive=size(find(tr(:,2)-(M+5*St)>0),1);  
                Negative=size(find(tr(:,2)-(M-5*St)<0),1); 
                MaxVal=max(tr(:,2)); MinVal=min(tr(:,2)); DeltaM=MaxVal-MinVal;  end;

if Positive>Negative PeakPolarity=1; else PeakPolarity=-1;  end; 

NoisePoints=size(find(Noise),1); 
if Plot1    figure; 
    if nargin==6    plot(tr(:,1),trD,'-r'); hold on; grid on; 
        else        plot(tr(:,1),tr(:,2)); hold on; grid on;     end; 
end; 
while DeltaM>0.1
    if nargin==6  M =[M,mean(trD(Noise))];   St=[St,std(trD(Noise))]; 
           else   M =[M,mean(tr(Noise,2))];  St=[St,std(tr(Noise,2))];  end;           
    L=length(M);    
    if L>2   DeltaM=abs(M(L)-M(L-1));  else     DeltaM=10;    end; 
    NoiseLevel=M(L)+PeakPolarity*OverSt*St(L);    
    if nargin==6        
        if PeakPolarity==1 Noise=(trD<NoiseLevel); else Noise=(trD>NoiseLevel);  end;          %(abs(M(L)-tr(:,2))<OverSt*St(L));
    else
        if PeakPolarity==1 Noise=(tr(:,2)<NoiseLevel); else; Noise=(tr(:,2)>NoiseLevel); end;  %(abs(M(L)-tr(:,2))<OverSt*St(L));
    end; 
    if Plot1   plot(tr(:,1),M(L)-OverSt*St(L)+Noise*OverSt*St(L), '-r');    end; 
    NoisePoints=[NoisePoints,size(find(Noise),1)];
    %if St(L)==0 DeltaM=0;end;
end; 
    NoiseL=circshift(Noise,-1);   NoiseL(end)=Noise(end);     
    NoiseR=circshift(Noise,1);    NoiseR(1)=Noise(1);
    SingleNoise=not(Noise)&NoiseR&NoiseL;           %search alone peaks above the NoiseLevel
    Noise(SingleNoise)=true;                        %the alone peaks are brought to the Noise array
    
if Plot1  plot(tr(:,1),M(L)-OverSt*St(L)+Noise*OverSt*St(L), '-g');    end; 
MeanVal=M(L); StdVal=St(L); PP=PeakPolarity;
%M(1)=[];  St(1)=[]; L=L-1; 
if Plot2
    figure;
    subplot(3,1,1); plot(M-M(L),'-or');  grid on; title('means');
    subplot(3,1,2); plot(St,'-*b'); grid on;  title('Std''s');
    subplot(3,1,3); plot(NoisePoints,'-or'); grid on;  title('Noise points');
    
end;
