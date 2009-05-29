function [peaks,HistA]=Peaks1(FileName,Dialog,MaxSignal);
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
OverSt=1;         % noise regection threshold, in standard deviations    
PeakSt=1;         % peak threshold, in standard deviations   
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
    x=[MinTime,MaxTime]; y=[MaxSignal,MaxSignal];   plot(x,y,'-r','LineWidth',2); 
    x=[MinTime,MinTime]; y=[0,MaxSignal];           plot(x,y,'-r','LineWidth',2); 
    x=[MaxTime,MaxTime]; y=[0,MaxSignal];           plot(x,y,'-r','LineWidth',2);     
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


% search the standard deviation of trekD noises 

    trekR=circshift(trek(:,2),Dshift);   for i=1:Dshift   trekR(i)=trek(i,2);   end; 
    trekL=circshift(trek(:,2),-Dshift);  for i=1:Dshift   trekL(end+1-i)=trek(end+1-i,2);   end; 
    trekD=trek(:,2)-trekR;
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
    
    NoiseR=circshift(Noise,1);   NoiseR(1)=1;     NoiseL=circshift(Noise,-1);  NoiseL(end)=1; 
    StartNoise=[1;find(Noise-NoiseR==1)];   EndNoise=find(Noise-NoiseL==1);  % Noise intervals
    % remove the last signal interval:
    if size(StartNoise,1)>size(EndNoise,1)  StartNoise(end)=[]; end;  
    Noise(EndNoise(end):end)=true; EndNoise(end)=trekSize;
    
    %   Signals intervals (include noise edges)
    StartSignal=EndNoise(1:end-1);   EndSignal=StartNoise(2:end); 
    
    % remove short signal intervals:  
    MoveToNoise=find((EndSignal-StartSignal<2+MinFrontN+MinTailN));
    SizeMoveToNoise=size(MoveToNoise,1);
    for i=1:SizeMoveToNoise; Noise(StartSignal(MoveToNoise(i)):EndSignal(MoveToNoise(i)))=true; end;    
    StartSignal(MoveToNoise)=[]; EndSignal(MoveToNoise)=[];
    SignalN=size(StartSignal,1);
    
    % new noise intervals:
    StartNoise=[1;EndSignal];  EndNoise=[StartSignal;trekSize];  
    %remove single noise points: 
    MoveToSignal=find(EndNoise==StartNoise); SizeMoveToSignal=size(MoveToSignal,1);
    for i=1:SizeMoveToSignal; Noise(StartNoise(MoveToSignal(i)))=false; end; 
    StartNoise(MoveToSignal)=[]; EndNoise(MoveToSignal)=[];
    % new Signal intervals:
    StartSignal=EndNoise(1:end-1);   EndSignal=StartNoise(2:end); 
    SignalN=size(StartSignal,1);
    
    %remove small signals
    Threshold=StdVal*PeakSt;
    for i=1:SignalN; Range(i)=max(trek(StartSignal(i):EndSignal(i),2))-min(trek(StartSignal(i):EndSignal(i),2)); end;
    MoveToNoise=[]; MoveToNoise=find((Range<Threshold)); 
    SizeMoveToNoise=size(MoveToNoise,2);
    for i=1:SizeMoveToNoise; Noise(StartSignal(MoveToNoise(i)):EndSignal(MoveToNoise(i)))=true; end; 
    StartSignal(MoveToNoise)=[]; EndSignal(MoveToNoise)=[];
    SignalN=size(StartSignal,1);
    
    %remove slow signals: 
    for i=1:SignalN 
        Slow(i)=(size(find(trekD(StartSignal(i):EndSignal(i))>ThresholdD),1)<2);                  
    end; 
    SlowInd=find(Slow); SlowN=size(SlowInd,2);
    for i=1:size(SlowInd,2); Noise(StartSignal(SlowInd(i)):EndSignal(SlowInd(i)))=true; end; 
    StartSignal(Slow)=[]; EndSignal(Slow)=[]; SignalN=size(StartSignal,1);

    fprintf('   %3.0f    slow signals are removed\n', SlowN); 
    
    AllSignals=not(Noise); 
    % expansion of peak fronts:
    AllSignals(StartSignal)=true;
    Noise=[]; 
    %Search for max inside signal intervals: 
    PeakInd=[];PeakVal=[];  
    for i=1:SignalN         
        S=StartSignal(i); E=EndSignal(i);
        VisiblePeakInd=find((trek(S:E,2)>=trek(S+1:E+1,2))&...
                            (trek(S:E,2)>trek(S-1:E-1,2))&...            
                            (trek(S:E,2)>trek(S-2:E-2,2)+ThresholdD));  % preceeding                
        NumPeaks(i)=size(VisiblePeakInd,1); 
        if NumPeaks(i)==0 [Max,VisiblePeakInd]=max(trek(S:E,2));  end; 
        
        PeakInd=[PeakInd;S+VisiblePeakInd-1];        
        PeakVal=[PeakVal;trek(S+VisiblePeakInd-1,2)]; 
        [MaxPeak(i),Ind]=max(trek(S+VisiblePeakInd-1,2)); % max signal between S and E
        MaxPeakInd(i)=S+VisiblePeakInd(Ind)-1; 
    end; 
    StandardPeaks=find((NumPeaks==1)'&((EndSignal-StartSignal)>=MinFrontN+MinTailN)&(MaxPeak>2*Threshold)');
    StandardPeaksN=size(find(StandardPeaks),1);
    for i=1:StandardPeaksN 
        StandardPulse(:,i)=trek(MaxPeakInd(StandardPeaks(i))-MaxFrontN:MaxPeakInd(StandardPeaks(i))+MaxTailN,2);  
    end;
    %MeanTail=mean(StandardPulse(end-round(MaxTailN/3):end,:),1);
    Pulse=mean(StandardPulse,2);
    SigmaPulse=std(StandardPulse,0,2);
    MeanTail=mean(Pulse(end-round(MaxTailN/3):end));
    Pulse=Pulse-MeanTail;  
    SigmaNormPulse=SigmaPulse/max(Pulse);
    NormPulse=Pulse/max(Pulse);     % normalized standard peak shape
    NormTail=NormPulse(MaxFrontN+1:end); 
    for i=1:MaxFrontN+1  NormFront(i)=max(0,NormPulse(MaxFrontN+2-i));   end;     
    
    
    
%     AllSignalsL=circshift(AllSignals,-1);   AllSignalsL(end)=AllSignals(end); 
%     PeakBool=(AllSignals-AllSignalsL==1);   
   
         
%     EdgeBoolD=trekD>ThresholdD; % marks all points above the threshold    
%     EdgeBoolD(1)=0; EdgeBoolD(end)=0; 
%     EdgeBool=trek(:,2)>Threshold; % marks all points above the threshold 
%     EdgeBool(1)=0; EdgeBool(end)=0; 
    
    if Plot2|Fourie subplot(2,1,1);  end;   
    if Dialog delete(TrekPlot0); SmoothedNoiseTrekPlot=plot(trek(:,1),real(trek(:,2)),'-g','LineWidth',1); end; 
    if Plot1 
      plot([trek(1,1),trek(end,1)],[Threshold,Threshold],'-g','LineWidth',2);
      plot([trek(1,1),trek(end,1)],[ThresholdD,ThresholdD],'-m','LineWidth',2);
      %  plot(trek(EdgeBoolD,1),trek(EdgeBoolD,2),'om');        plot(trek(EdgeBool,1),trek(EdgeBool,2),'oc');        
    end; 

fprintf('trekD=                                 %7.4f  sec\n', toc); tic;  
fprintf('  Standard deviat for trekD = %6.4f\n', StdValD);

%varying zero level. Look at trek037.dat of 040603. 

% EdgeBoolL=circshift(EdgeBool,-1);   EdgeBoolL(end)=EdgeBool(end); 
% EdgeBoolR=circshift(EdgeBool,1);    EdgeBoolR(1)=EdgeBool(1); 
% EdgeBoolDL=circshift(EdgeBoolD,-1);   EdgeBoolDL(end)=EdgeBoolD(end); 
% %EdgeBoolDNegL=circshift(EdgeBoolDNeg,-1);   EdgeBoolDNegL(end)=EdgeBoolDNeg(end); 
% EdgeBoolDR=circshift(EdgeBoolD,1);    EdgeBoolDR(1)=EdgeBoolD(1); 
% SinglePeaks=EdgeBool&not(EdgeBoolL)&not(EdgeBoolR);               %search for alone peaks 
% SinglePeaksD=EdgeBoolD&not(EdgeBoolDL)&not(EdgeBoolDR);           %search for alone peaks 
% 
% EdgeBool(SinglePeaks)=false;                                      %alone peaks are taken out
% EdgeBoolD(SinglePeaksD)=false;                                    %alone peaks are taken out
% EdgeBoolL=circshift(EdgeBool,-1);   EdgeBoolL(end)=EdgeBool(end); 
% EdgeBoolDL=circshift(EdgeBoolD,-1); EdgeBoolDL(end)=EdgeBoolD(end); 

%marks peak starts (first approximation) 
%front rise & 2-nd point after start is above threshold:
%StartBool=(EdgeBoolDL-EdgeBoolD==1)&circshift(EdgeBool,-2); %%%???????

%marks peak tops (first approximation) 
% pulse top and preceeding point are above threshold:  
%PeakBool=(EdgeBoolD-EdgeBoolDL==1); %   &EdgeBool&circshift(EdgeBool,1);  

%marks peak ends (first approximation) 
% may be several ends because of oscillations:
%EndBool=(EdgeBool-EdgeBoolL==1);        %marks peak ends (first approximation) 

%StartAbsBool=(EdgeBoolL-EdgeBool==1);   %marks peak abs start (first approximation) 

%FP=find(PeakBool); %FS=find(StartBool);  FE=find(EndBool); FAS=find(StartAbsBool);      % indexes 
% BeforeFS1=FP<FS(1); PeakBool(BeforeFS1)=false; FP(BeforeFS1)=[];  
% AfterFP=FS>FP(end); StartBool(AfterFP)=false; FS(AfterFP)=[]; 
SizeFP=size(FP,1);  %SizeFS=size(FS,1);  SizeFE=size(FE,1);

%corrections to the peak tops
%Search for higher forward points:
IndPR=FP; IndPNext=FP+1; 
if IndPNext(end)>trekSize IndPNext(end)=trekSize; end;
CorrBool=trek(FP,2)<trek(IndPNext,2);    
while not(isempty(find(CorrBool)))
    IndPR=IndPR+CorrBool;   IndPNext=IndPR+1; 
    if IndPNext(end)>trekSize IndPNext(end)=trekSize; end;
    CorrBool=trek(IndPR,2)<trek(IndPNext,2);    
    %   plot(trek(IndPR,1),trek(IndPR,2),'r^','MarkerSize',4); 
end;
FP=IndPR; 
%Search for higher preceeding points
IndPL=FP; 
IndPPre=IndPL-1; 
if IndPPre(1)<1 IndPPre(1)=1; end;
CorrBool=trek(IndPPre,2)>trek(IndPL,2);    
while not(isempty(find(CorrBool)))
    IndPL=IndPL-CorrBool;   IndPPre=IndPL-1; 
    if IndPPre(1)<1 IndPPre(1)=1; end;
    CorrBool=trek(IndPPre,2)>trek(IndPL,2);    
    %  plot(trek(IndPL,1),trek(IndPL,2),'r^','MarkerSize',4);     
end;
FP=IndPL; 


%OrderBool=(SizeFS==SizeFE)&(SizeFS==SizeFP);

startPoint=max(1,FP(1)-MaxFrontN); 
[StartVal,Ind]=min(trek(startPoint:FP(1),2));  
%check for long fornt (perhaps, missed peaks): 
if (Ind==1)&(StartVal>Threshold)&AllSignals(startPoint)
   while EdgeBoolD(startPoint+Ind-1) Ind=Ind-1; end; 
end;
FS(i)=startPoint+Ind-1;
EndPoint=min(FP(1)+MaxTailN,FP(2)); 
if StartVal>Threshold [EndVal,Ind]=min(abs(trek(FP(1):EndPoint,2))); 
else [EndVal,Ind]=min(abs(trek(FP(1):EndPoint,2)-StartVal));  end;
FE(1)=FP(1)+Ind-1;
for i=2:SizeFP-1 
    startPoint=max([1,FP(i)-MaxFrontN,FP(i-1),FE(i-1)]); 
    [StartVal,Ind]=min(trek(startPoint:FP(i),2)); 
    %check for long fornt (perhaps, missed peaks): 
    if (Ind==1)&(StartVal>Threshold)&EdgeBoolD(startPoint)
      while EdgeBoolD(startPoint+Ind-1) Ind=Ind-1; end; 
    end;     
    FS(i)=startPoint+Ind-1;
    EndPoint=min([FP(i)+MaxTailN,FP(i+1),trekSize]); 
    if StartVal>Threshold [EndVal,Ind]=min(abs(trek(FP(i):EndPoint,2)));  
    else [EndVal,Ind]=min(abs(trek(FP(i):EndPoint,2)-StartVal)); end;    
    FE(i)=FP(i)+Ind-1;
end; 
i=SizeFP; 
startPoint=max([1,FP(i)-MaxFrontN,FP(i-1),FE(i-1)]); 
[StartVal,Ind]=min(trek(startPoint:FP(i),2)); 
%check for long fornt (perhaps, missed peaks): 
if (Ind==1)&(StartVal>Threshold)&EdgeBoolD(startPoint)
   while EdgeBoolD(startPoint+Ind-1) Ind=Ind-1; end; 
end;     
FS(i)=startPoint+Ind-1;
EndPoint=min(FP(i)+MaxTailN,trekSize);
if StartVal>Threshold [EndVal,Ind]=min(abs(trek(FP(i):EndPoint,2)));    
else [EndVal,Ind]=min(abs(trek(FP(i):EndPoint,2)-StartVal)); end;
FE(i)=FP(i)+Ind-1;
FE=FE'; FS=FS';

%Seach pulse shape:
PulseInd=find(((FP-FS)==MaxFrontN)&((FE-FP)==MaxTailN));
PulseIndN=size(PulseInd,1); 
for i=1:PulseIndN 
    Pulse(:,i)=trek(FP(PulseInd(i))-MaxFrontN:FP(PulseInd(i))+MaxTailN,2); end;
MeanTail=mean(Pulse(end-10:end,:),1);
for i=1:PulseIndN Pulse(:,i)=Pulse(:,i)-MeanTail(i); end;
PulseMax=max(Pulse);
for i=1:PulseIndN PulseNorm(:,i)=Pulse(:,i)/PulseMax(i); end;
MeanPulseNorm=mean(PulseNorm,2);
MeanPulseNorm=MeanPulseNorm/max(MeanPulseNorm);
StdTailNorm=std(MeanPulseNorm(end-round(MaxTailN/3):end));
FrontAboveNoise=find(MeanPulseNorm(1:MaxFrontN+1)>StdTailNorm); 
FrontAboveNoiseN=size(FrontAboveNoise,1);
% polynomial fit of the peak top:
MPF=polyfit([-3:3]',MeanPulseNorm(MaxFrontN-2:MaxFrontN+4),4);
x=[-3:0.1:3]'; y=MPF(1)*x.^4+MPF(2)*x.^3+MPF(3)*x^2+MPF(4)*x+MPF(5);
[TopFit,TopInd]=max(y); 
TopX=x(TopInd); y=y/TopFit; 


% linear fit of FrontAboveNoise points at the peak front and tail: 
FrontFit=polyfit([1-FrontAboveNoiseN:0]',MeanPulseNorm(FrontAboveNoise),1);
% x=MaxFrontN+1+[1-FrontAboveNoiseN:0]';
% y=FrontFit(1)*(x-MaxFrontN-1)+FrontFit(2);
TailFit =polyfit([0:FrontAboveNoiseN]',MeanPulseNorm(MaxFrontN+1:MaxFrontN+1+FrontAboveNoiseN),1);
%x=MaxFrontN+1+[0:FrontAboveNoiseN]';
%y=TailFit(1)*(x-MaxFrontN-1)+TailFit(2);
TailSlopeCoeff=-TailFit(1)/FrontFit(1); 
% TailExtrapolate=[];
% for i=1:FrontAboveNoiseN   TailExtrapolate=[TailExtrapolate;...
%         [trek(FP+i,1),trek(FP,2)-(trek(FP,2)-trek(FP-i,2))*TailSlopeCoeff ]];   
% end;
TailExtrapolate=[];
for i=1:FrontAboveNoiseN   TailExtrapolate=[TailExtrapolate;...
        [trek(FP+i,1),trek(FP,2)*MeanPulseNorm(MaxFrontN+1+i)]];   
end;
FrontExtrapolate=[];
for i=1:FrontAboveNoiseN   FrontExtrapolate=[FrontExtrapolate;...
        [trek(FP+i-FrontAboveNoiseN-1,1),...
         trek(FP,2)*MeanPulseNorm(MaxFrontN+i-FrontAboveNoiseN)]];   
end;

%Search for missed peaks at long fronts
LongFrontPulses=find((FP-FS)>MaxFrontN);
for i=1:size(LongForntPulses,1)
   FrontInd=FS(LongFrontPulses(i)):FP(LongFrontPulses(i)); 
   trekDmax=find((trekD(FrontInd)>circshift(trekD(FrontInd),1))&...
                 (trekD(FrontInd)>circshift(trekD(FrontInd),-1)));
   for k=1:size(trekDmax,1)-1
       FS(end+k)=FS(i+k-1);
       FP(end+k)=FP(i)-trekDmax(k)+trekDmax(end);
       [trekDMin,MinInd]=min(trekD(FrontInd(trekDmax(k)):FrontInd(trekDmax(k+1))));
       FE(end+k)=FrontInd(trekDmax(k))+MinInd;
   end;
end; 
% StartBool(:)=false; PeakBool(:)=false; EndBool(:)=false;
% StartBool(FS)=true; PeakBool(FP)=true; EndBool(FE)=true;
%FS=find(StartBool); FP=find(PeakBool); FE=find(EndBool); FAS=find(StartAbsBool);      % renew indexes 
%FN=size(FS,1); 


% plot(trek(FS,1),trek(FS,2),'k>','MarkerFaceColor','g','MarkerSize',4);    % peak starts (first approximation)
% plot(trek(FP,1), trek(FP,2), 'k^','MarkerFaceColor','r','MarkerSize',4);    % peak tops (first approximation)
% plot(trek(FE,1),trek(FE,2),    'kv','MarkerFaceColor','b','MarkerSize',4);    % peak ends (first approximation)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FS = find(StartBool);
% FP = find(PeakBool);  
% FE = find(EndBool);
IndS0=FS; 
fprintf('first mark peak points=                 %7.4f  sec\n', toc); tic; 
fprintf('     %8.0f peaks were selected          \n', SizeFP); 

%    % Search for double peaks  
% SR=size(IndPR,1);
% for i=1:SR-1 if IndPR(i)==IndPR(i+1) IndPR(i)=0;  end;   end;

%  DoublePeakRBool=FP==0;  % 2 previous strings are commented

   %IndPR(DoublePeakRBool)=[];
   %FS(DoublePeakRBool)=[];
   %FE(DoublePeakRBool)=[];
   %IndS0=FS; 
   %FP=IndPR; 



% Search for missed peaks on peak fronts: 

FPR=circshift(FP,1); FPR(1)=1;
SuspectInd=find((trek(FS,2)>Threshold)&((FS-FPR)>MaxTailN)); 
%trek(FS(SuspectInd),2)


% Search for double peaks  
% SL=size(IndPL,1);
% for i=1:SL-1 k=SL-i+1;  if IndPL(k)==IndPL(k-1) IndPL(k)=0;  end;  end;

%DoublePeakLBool=IndPL==0;   % 2 previous strings are commented

  %IndPL(DoublePeakLBool)=[];
  %FS(DoublePeakLBool)=[];
  %FE(DoublePeakLBool)=[];
  %IndS0=FS;
  %FP=IndPL; 

DoublePeakBoolForw=DoublePeakRBool&not(DoublePeakLBool);  %peaks combined with higher forward peaks
DoublePeakBoolPrec=DoublePeakLBool&not(DoublePeakRBool);  %peaks combined with higher preceeding peaks
DoublePeakBool=DoublePeakBoolForw|DoublePeakBoolPrec;     %All double peaks
DoublePeakNum=size(find(DoublePeakBool),1); 

%plot(trek(FP,1),trek(FP,2),'r^','MarkerSize',4); 
fprintf('Search for double peaks and top corrections =             %7.4f  sec\n', toc); tic;     
fprintf('   the number of double peaks = %3.0f \n', DoublePeakNum); 

%corrections of the peak starts   (look trek007 @5061 us)
% IndSL=FS-1;
% if IndSL(1)<1 IndSL(1)=1; end;
% CorrBool=trek(IndSL,2)<trek(FS,2);    
% while not(isempty(find(CorrBool)))
%     FS=FS-CorrBool; 
%     plot(trek(FS,1),trek(FS,2),'b>','MarkerSize',4); 
%     IndSL=FS-1; 
%     if IndSL(1)<1 IndSL(1)=1; end;
%     CorrBool=trek(IndSL,2)<trek(FS,2);        
% end; 

% Search for double starts  
% S=size(IndSL,1);
% for i=1:S-1
%     k=S-i+1; 
%     if IndSL(k)==IndSL(k-1) IndSL(k)=0;  end; 
% end;
% DoubleStartBool=IndSL==0; 
% IndSL(DoubleStartBool)=[];
% FP(DoubleStartBool)=[];
% FE(DoubleStartBool)=[];
% FS=IndSL+1;                 % corrected start
% IndS0(DoubleStartBool)=[];  % initial start


%plot(trek(FS,1),trek(FS,2),'g>','MarkerFaceColor','g','MarkerSize',4); 
fprintf('    Front duration = %5.3f +/-  %5.3f\n', mean(FP-FS)*tau, std(FP-FS)*tau);
fprintf('    Full pulse duration = %5.3f +/-  %5.3f\n', mean(FE-FS)*tau, std(FE-FS)*tau);
%fprintf('    Pulse duration = %5.3f +/-  %5.3f\n', mean(peaks(:,7)), std(peaks(:,7)));

IndSL=FS-ZeroPoints+1; 
IndSLOutBool=IndSL<1; 
IndSL(IndSLOutBool)=1; 

%Zero level calculations
NoiseLevel=StdVal*OverSt; 
for i=1:size(FS,1)
%     if trek(IndSL(i):FS(i),2)<NoiseLevel 
%         Zero(i)=mean(trek(IndSL(i):FS(i),2));
%         fit1(i)=0; fit0(i)=Zero(i);        
%         x=trek(IndSL(i):FS(i),1);
%         y=ones(min(ZeroPoints,FS(i)-IndSL(i)+1),1)*Zero(i);
%     else
        x=trek(IndSL(i):FS(i),1);
        y=trek(IndSL(i):FS(i),2);
        poly = polyfit(x-trek(FS(i),1),y,1);   %   y = fit1*(x-trek(FS(i)) + fit0
        fit1(i)=poly(1); fit0(i)=poly(2);
        if fit1(i)<0                % this is the statisctical important case for plasma measurements
            Zero(i)=fit1(i)*(trek(FP(i),1)-trek(FS(i),1))+fit0(i); 
        else
            Zero(i)=fit0(i);
        end; 
        if Zero(i)<-NoiseLevel Zero(i)=0; end; %no opposite statistical important cases 
%     end;    
    %plot(x,y,'k>','MarkerSize',4);             
end; 
fprintf('Zero level calculations =              %7.4f  sec\n', toc); tic;     

peaks(:,1)=trek(IndS0,1);                           %Start time,  us
peaks(:,2)=trek(FP,1);                            %peak time,  us
NPeaks=size(peaks,1);
if NPeaks>1 Period=(peaks(end,1)-peaks(1,1))/NPeaks;  else
            Period=(trek(end,1)-trek(1,1));            end;                        
peaks(:,3)=circshift(peaks(:,2),-1)-peaks(:,2);   % peak-to-peak interval, us (after peak)
peaks(end,3)=Period; 

peaks(:,4)=Zero';                          %averaged zeros, counts
peaks(:,5)=trek(FP,2)-Zero';             %peak amplitude, counts

% front charge calculations
ChargePoints=ChargeTime/tau;                    % charge time       
for i=1:NPeaks     
    if FrontCharge  
        ends=FP(i);  Tail=0;   % front charge        
    else  
        if i~=NPeaks NextPeakStart=FS(i+1); else NextPeakStart=trekSize; end;       
        ends=min(FS(i)+ChargePoints,trekSize);   Tail=0;                   
        if ends>NextPeakStart 
            ends=NextPeakStart;  
            Tail=trek(ends,2)*(ends-NextPeakStart)/2;      %takes tail into account
%           PreceedTail=
        end; 
    end;           
    x=trek(FS(i):ends,1);
    if isempty(x) fprintf('empty charge: peak= %3.0f time= %9.3f\n',i,peaks(i,1));    end;
    if fit1(i)<0 
        y=fit1(i).*(x-trek(FS(i),1))+fit0(i); y(y<0)=0; 
    else
        y=fit0(i)*ones(ends-FS(i)+1,1);              % removes rising zeros
    end;
    peaks(i,6)=(Tail+sum(trek(FS(i):ends,2)-y));     %/(ends-FS(i));     %    
    plot(x,y,'-k','LineWidth',1.5);
end; 
fprintf('front charge calculations   =          %7.4f  sec\n', toc); tic;     

peaks(:,7)=peaks(:,6)./peaks(:,5);      % peak or front duration (depending on FrontCharge)

peaks(:,8)=1;   % the number of combined peaks in one peak
fprintf('    Pulse duration = %5.3f +/-  %5.3f\n', mean(peaks(:,7)), std(peaks(:,7)));

%search close peaks
ClosePeaksBool=peaks(:,3)<MinInterval;        % all closed peaks
ClosePeaksBoolR=circshift(ClosePeaksBool,1);   ClosePeaksBoolR(1)=false;

CombinedStartBool=ClosePeaksBool&not(ClosePeaksBoolR);
CombinedPeakBool=circshift(not(ClosePeaksBool)&ClosePeaksBoolR,-1);
IndCombinedStart=find(CombinedStartBool);
IndCombinedPeak=find(CombinedPeakBool);
peaks(IndCombinedStart,2)=peaks(IndCombinedPeak,2);

CombPeaksNum=IndCombinedPeak-IndCombinedStart+1;  %the number of combined peaks
peaks(IndCombinedStart,8)=CombPeaksNum;
CombPeakTotal=size(IndCombinedStart,1);
AddAmpl=zeros(CombPeakTotal,1);
AddCharge=zeros(CombPeakTotal,1);
for i=1:CombPeakTotal
    for k=1:CombPeaksNum(i)
        AddAmpl(i)=AddAmpl(i)+peaks(IndCombinedStart(i)+k,5);
        AddCharge(i)=AddCharge(i)+peaks(IndCombinedStart(i)+k,6);       
    end; 
end; 
peaks(IndCombinedStart,5)=peaks(IndCombinedStart,5)+AddAmpl;
peaks(IndCombinedStart,6)=peaks(IndCombinedStart,6)+AddCharge;
peaks(ClosePeaksBoolR,:)=[];
fprintf('   the number of combined peaks =  %4.0f\n', CombPeakTotal);

NPeaks=size(peaks,1);
if NPeaks>1 Period=(peaks(end,1)-peaks(1,1))/NPeaks;  else
            Period=(trek(end,1)-trek(1,1));            end;                        
peaks(:,3)=circshift(peaks(:,2),-1)-peaks(:,2);    % peak-to-peak interval, us (after peak)
peaks(end,3)=Period; 

%for i=1:NPeaks                               % takes much time
%    FS(i)=find(trek(:,1)==peaks(i,1));       % starts in the trek
%    FP(i)=find(trek(:,1)==peaks(i,2));       % peaks in the trek
%end; 
%fprintf('marks trek   =  %7.4f  sec\n', toc); tic;     

for i=1:max(peaks(:,8),[],1)                      
    ExpecetedDoubles(i)=NPeaks*(MinInterval/Period)^i/factorial(i);
end; 
fprintf('ExpecetedDoubles   =                   %7.4f  sec\n', toc); tic;     


if DeadAfter % so far only one peak
    DeadBool=(peaks(:,5)>MaxSignal)&(peaks(:,3)<DeadTime); 
    DeadBoolR=circshift(DeadBool,1); DeadBoolR(1)=false;
    peaks(DeadBool,3)=peaks(DeadBool,3)+peaks(DeadBoolR,3);  % last!
    peaks(DeadBoolR,:)=[];
end; 

SelectedPeakBool=(peaks(:,4)+peaks(:,5)<MaxSignal)&(peaks(:,5)<MaxAmp)&...
                 (peaks(:,2)-peaks(:,1)>MinFront)&(peaks(:,2)-peaks(:,1)<MaxFront)&...
                 (peaks(:,8)<=MaxCombined)&(peaks(:,5)>=ThresholdD)&...
                 (peaks(:,7)>MinDuration)&(peaks(:,7)<MaxDuration); 
peaks(not(SelectedPeakBool),:)=[];

NPeaks=size(peaks,1);
if NPeaks>1 Period=(peaks(end,1)-peaks(1,1))/NPeaks;  else
            Period=(trek(end,1)-trek(1,1));            end; 
peaks(end,3)=Period;        
%MaxPeakAmpl=max(peaks(:,5));
%MaxPeakCharge=max(peaks(:,6));

DoublePeakNum=size(find(peaks(:,end)==2),1);
TriplePeakNum=size(find(peaks(:,end)==3),1);
plot(peaks(:,1),peaks(:,4),'k>','MarkerFaceColor','k','MarkerSize',4);   % peak zero level
plot(peaks(:,2),peaks(:,5),'r^','MarkerFaceColor','r','MarkerSize',4);   % peak amplitude  
plot(peaks(:,1),peaks(:,6),'rd','MarkerFaceColor','y','MarkerSize',4);   % peak charge
%if Dialog&(Delta==1) plot(trek(:,1),trekD,'-m'); end; 
axis([MinTime,MaxTime,min(peaks(:,4)),1.2*max(MaxSignal,max(peaks(:,6)))]);

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
