function [peaks,HistA]=Peaks(FileName);
%[peaks,HistA]=Peaks(FileName); gets peaks from plasma x-ray trek.

Text=0;           % switch between text and binary input files
Delta=0;          % if Delta=1 then trekD is used for peak detection, else the peaks are detected from the trek.  
Fourie=0;         %if Fourie=1 then performes Fourie transformation of the signal. 
FrontCharge=0;    % if FrontCharge=1 then the cahrge is calculated till peak maximum else charge is calculated within ChargeTime
DeadAfter=1;      % if DeadAfter=1 then all pulses during DeadTime after peaks exceeding MaxSignal are eliminated (to avoied excited noises) 

SmoothGate=10;    % the numeber of points for NOISE smoothing; 
OverSt=2;         % noise regection threshold, in standard deviations    
PeakSt=5;         % peak threshold, in standard deviations   
MinFront=0.03;    % minimal front edge of peaks, us
MaxFront=0.4;     % maximal front edge of peaks, us
AverageGate=0.076;% Averaging gate
MinDuration=0.02; % minimal peak duration, us. Shorter peaks are eliminated 
MaxDuration=20.0; % maximal peak duration, us. Longer peaks are eliminated. 
MinAmp=4096;      % Minimal peak amplitude 
Dshift=1;         %circshift(trek(:,2),Dshift); 
ZeroPoints=3;     % for avaraging peak zero level
MinInterval=0.1;  % minimum peak-to-peak interval,  us
MaxCombined=30;   % maximum combined peaks allowed for MinInterval
AveragN=20;       % Averaged number of peaks in histogram interval  

HistInterval=20;  % count interval for amplitude and cahrge histograms
ChargeTime=0.5;   % us
DeadTime=1.6;     % us 
tau=0.025;        % us digitizing time
lowf=5;           % MHz,  frequencies higher than lowf may be cut by digital filter


%   frequency range after the fft transformation 
%   N - the number of points in a trek
%   tau  - measurement period
%   fft(trek,N) -> N points in the spectrum in the range grom 0 to 1/tau
%   and distanced by 1/tau/N-1. Only (0-1/2/tau) range can be taken into
%   account!!!



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

trekSize=size(trek(:,1)); %  (N,1) dimension
trekSize=trekSize(1);

% search the signal pedestal and standard deviation 
NoiseArray=logical(ones(trekSize,1));  % all measurements, first, are assumed to be noise
[MeanVal,StdVal,PeakPolarity,NoiseArray]=MeanSearch(trek,OverSt,NoiseArray,0,0);       
if PeakPolarity==1 trek(:,2)=trek(:,2)-MeanVal;  else trek(:,2)=MeanVal-trek(:,2); end;    
fprintf('Mean search  =                         %7.4f\n', toc); tic;
fprintf('  Previous mean   = %6.4f\n', MeanVal);
fprintf('  Standard deviat = %6.4f\n', StdVal);

if Fourie
    spectr=fft(trek(:,2),trekSize)/trekSize; 
    spectr(:,2)=spectr(:,1); 
    spectr(:,1)=(0:1/tau/(trekSize-1):1/tau)';
    spectr(:,3)=abs(spectr(:,2));        
end; 
hp=figure;                 
if isstr(FileName)  set(hp,'name',FileName);  else
                    set(hp,'name','array');   end; 

subplot(2,1,1);
    TrekPlot0=plot(trek(:,1),trek(:,2),'-b'); hold on; grid on; 
   % plot([trek(1,1),trek(end,1)],[OverSt*StdVal,OverSt*StdVal],'-b','LineWidth',2);
    xlabel('t, us');
if Fourie 
    MaxSpectr0=max(spectr(:,3)); 
    subplot(2,1,2);     
    plot(spectr(:,1),spectr(:,3),'-r'); grid on; hold on; 
    plot([lowf,lowf],[0,1.1*MaxSpectr0],'-g'); 
    axis([0 1/2/tau 0 max(spectr(:,3))]);    xlabel('f, MHz');
    fprintf('fft  =                                 %7.4f\n', toc); tic;    
end;     
MaxSignal = input('Input the maximum signal level. Higher signals will be cut: \n');  
if isempty(MaxSignal) MaxSignal = 1.1*max(trek(:,2)); end;
MaxAmp=MaxSignal; 
MinTime = input('Input the minimum time.  Peaks before this time will be cut: \n');  
if isempty(MinTime) MinTime=trek(1,1); end;
MaxTime = input('Input the maximum time.  Peaks after this time will be cut: \n');  
if isempty(MaxTime) MaxTime=trek(end,1); end;
subplot(2,1,1);                
    x=[MinTime,MaxTime]; y=[MaxSignal,MaxSignal];   plot(x,y,'-r','LineWidth',2); 
    x=[MinTime,MinTime]; y=[0,MaxSignal];           plot(x,y,'-r','LineWidth',2); 
    x=[MaxTime,MaxTime]; y=[0,MaxSignal];           plot(x,y,'-r','LineWidth',2); 
if Fourie
    MaxSpectr = input('     Input the maximum peak amplitude in the high frequency part of the spectrum \n     Peaks will be restricted by this value: \n');  
    if isempty(MaxSpectr)  MaxSpectr=MaxSpectr0; end;
    subplot(2,1,2);                
    x=[lowf,1/2/tau]; y=[MaxSpectr,MaxSpectr];   plot(x,y,'-g'); 
else
    MaxSpectr=1; MaxSpectr0=0.5;  
end;     
OutLimits=(trek(:,1)>MaxTime)|(trek(:,1)<MinTime);   %|(trek(:,2)>MaxSignal);
trek(OutLimits,:)=[]; NoiseArray(OutLimits,:)=[];
trekSize=size(trek(:,1)); %  (N,1) dimension
trekSize=trekSize(1);
    
if MaxSpectr<MaxSpectr0 
    DumpFilter=(spectr(:,1)>lowf)&(spectr(:,3)>MaxSpectr); 
    spectrFilter=spectr; 
    spectrFilter(DumpFilter,2)=MaxSpectr*spectr(DumpFilter,2)./spectr(DumpFilter,3);
            %trekFilter=trek;     trekFilter(:,2)=ifft(spectrFilter(:,2),trekSize); 
    trek(:,2)=ifft(spectrFilter(:,2),trekSize); 
    subplot(2,1,1);                
        RealTrekPlot=plot(trek(:,1),real(trek(:,2)),'-r'); hold on; 
        ImagTrekPlot=plot(trek(:,1),1000*imag(trek(:,2)),'-m');
        MaxImag=max(imag(trek(:,2))); 
       
    fprintf('Maximum absolute imaganary part of the filtered signal = %10.5f\n ',MaxImag);  
    fprintf('Imaganary part of the filtered signal will be put zero \n ');  
    fprintf('Pause. look at the filtered signals and press any key  \n');
    pause;  
    tic; 
    trek(:,2)=real(trek(:,2));   
    [MeanVal,StdVal,PeakPolarity,NoiseArray]=MeanSearch(trek,OverSt,NoiseArray,0,0);
    if PeakPolarity==1 trek(:,2)=trek(:,2)-MeanVal;  else  trek(:,2)=MeanVal-trek(:,2); end;  
    fprintf('New mean search  =                 %7.4f\n', toc); tic;
    fprintf('  Previous mean       = %6.4f\n', MeanVal);
    fprintf('  New standard deviat = %6.4f\n', StdVal);    
    subplot(2,1,1);              
end; 
fprintf('Pause. look at the figure and press any key\n');
pause; 
    %noise smoothing
subplot(2,1,1);     
SmoothGate=round(AverageGate/tau);
%SmoothedNoise=filter(ones(1,SmoothGate)/SmoothGate,1,trek(NoiseArray,2));
%trek(NoiseArray,2)=SmoothedNoise; 
SmoothedNoise=filter(ones(1,SmoothGate)/SmoothGate,1,trek(:,2));
trek(:,2)=SmoothedNoise; 
[MeanVal,StdVal,PeakPolarity,NoiseArray]=MeanSearch(trek,OverSt,NoiseArray,0,0);    
if PeakPolarity==1 trek(:,2)=trek(:,2)-MeanVal;  else trek(:,2)=MeanVal-trek(:,2); end;    
SmoothedNoiseTrekPlot=plot(trek(:,1),real(trek(:,2)),'-g','LineWidth',2);
 
if MaxSpectr<MaxSpectr0     delete(TrekPlot0);      delete(ImagTrekPlot);    end; 
tic;

% search the standard deviation of trekD noises 

    trekR=circshift(trek(:,2),Dshift);   for i=1:Dshift   trekR(i)=trek(i,2);   end; 
    trekD=trek(:,2)-trekR;
    LD=length(trekD); 
%    [MeanValD,StdValD,PeakPolarity,NoiseArray]=MeanSearch(trek,OverSt,NoiseArray,0,0,trekD);
    StdValD=std(trekD(NoiseArray));
    MeanValD=mean(trekD(NoiseArray));
    ThresholdD=StdValD*PeakSt; 
    EdgeBoolD=trekD>ThresholdD; % marks all points above the threshold 
    EdgeBoolD(1)=0; EdgeBoolD(end)=0;

    Threshold=StdVal*PeakSt; 
    EdgeBool=trek(:,2)>Threshold; % marks all points above the threshold 
    EdgeBool(1)=0; EdgeBool(end)=0;    

    plot([trek(1,1),trek(end,1)],[Threshold,Threshold],'-g','LineWidth',2);
    plot([trek(1,1),trek(end,1)],[ThresholdD,ThresholdD],'-m','LineWidth',2);
    %  plot(trek(EdgeBoolD,1),trek(EdgeBoolD,2),'om');        plot(trek(EdgeBool,1),trek(EdgeBool,2),'oc');        

fprintf('trekD=                                 %7.4f\n', toc); tic;  
fprintf('  Standard deviat for trekD = %6.4f\n', StdValD);

%make varying zerto level. Look at trek037.dat of 040603. 

EdgeBoolL=circshift(EdgeBool,-1);   EdgeBoolL(end)=EdgeBool(end); 
EdgeBoolR=circshift(EdgeBool,1);    EdgeBoolR(1)=EdgeBool(1); 
EdgeBoolDL=circshift(EdgeBoolD,-1);   EdgeBoolDL(end)=EdgeBoolD(end); 
EdgeBoolDR=circshift(EdgeBoolD,1);    EdgeBoolDR(1)=EdgeBoolD(1); 
SinglePeaks=EdgeBool&not(EdgeBoolL)&not(EdgeBoolR);               %search for alone peaks 
SinglePeaksD=EdgeBoolD&not(EdgeBoolDL)&not(EdgeBoolDR);           %search for alone peaks 

EdgeBool(SinglePeaks)=false;                                      %the alone peaks are taken out
EdgeBoolD(SinglePeaksD)=false;                                    %the alone peaks are taken out
EdgeBoolL=circshift(EdgeBool,-1);   EdgeBoolL(end)=EdgeBool(end); 
EdgeBoolDL=circshift(EdgeBoolD,-1);   EdgeBoolDL(end)=EdgeBoolD(end); 

StartBool=(EdgeBoolDL-EdgeBoolD==1);  %marks peak starts (first approximation)
PeakBool=(EdgeBoolD-EdgeBoolDL==1);   %marks peak tops (first approximation) 
EndBool=(EdgeBool-EdgeBoolL==1);   %marks peak ends (first approximation) 
StartAbsBool=(EdgeBoolL-EdgeBool==1);   %marks peak abs start (first approximation) 

FS=find(StartBool); FP=find(PeakBool); FE=find(EndBool); FAS=find(StartAbsBool);      % indexes 
EndBeforeStart=FE<FS(1); 
EndBool(FE(EndBeforeStart))=[];  
FE=find(EndBool); 
% bring StartBool, PeakBool and EndBool in accordence
SizeFS=size(FS,1);
for i=1:SizeFS
    if i<SizeFS NextStart=FS(i+1); else NextStart=trekSize; end; 
    ExistEnds=find((FE>FS(i))&(FE<NextStart)); 
    if isempty(ExistEnds) 
        [NewEnd,NewEndInd]=min(trek(FP(i):NextStart,2));
        EndBool(FP(i)+NewEndInd-1)=true; 
    else 
        HowManyEnds=size(ExistEnds); 
        if HowManyEnds(1)>1 
            EndBool(FE(ExistEnds(2)):FE(ExistEnds(end)))=false; % exclude surplus ends  or...
                                                                %additional starts and peaks (collects too much noises!):         
%                 StartBool(FAS(ExistEnds(2)):FAS(ExistEnds(end)))=StartAbsBool(FAS(ExistEnds(2)):FAS(ExistEnds(end)));
%                 for k=2:HowManyEnds(1) 
%                    [NewPeak,NewPeakInd]=max(trek(FAS(ExistEnds(k)):FE(ExistEnds(k)),2)); 
%                    PeakBool(FAS(ExistEnds(k))+NewPeakInd-1)=true;
%                 end;            
        end; 
    end; 
end; 
FS=find(StartBool); FP=find(PeakBool); FE=find(EndBool); FAS=find(StartAbsBool);      % renew indexes 


plot(trek(StartBool,1),trek(StartBool,2),'k>','MarkerFaceColor','g','MarkerSize',6);    % peak starts (first approximation)
plot(trek(PeakBool,1), trek(PeakBool,2), 'k^','MarkerFaceColor','r','MarkerSize',6);    % peak tops (first approximation)
plot(trek(EndBool,1),trek(EndBool,2),    'kv','MarkerFaceColor','b','MarkerSize',6);    % peak ends (first approximation)

IndS = find(StartBool);
IndP = find(PeakBool);  
IndE = find(EndBool);
IndPR=IndP; 
IndS0=IndS; 
fprintf('first mark peak edges=                 %7.4f\n', toc); tic; 

%corrections to the peak tops
%Search for higher forward points

IndPNext=IndP+1; 
if IndPNext(end)>trekSize IndPNext(end)=trekSize; end;
CorrBool=trek(IndP,2)<trek(IndPNext,2);    
while not(isempty(find(CorrBool)))
    IndPR=IndPR+CorrBool; 
    plot(trek(IndPR,1),trek(IndPR,2),'r^','MarkerSize',4); 
    IndPNext=IndPR+1; 
    if IndPNext(end)>trekSize IndPNext(end)=trekSize; end;
    CorrBool=trek(IndPR,2)<trek(IndPNext,2);    
end;

% Search for double peaks  
SR=size(IndPR,1);
for i=1:SR-1 if IndPR(i)==IndPR(i+1) IndPR(i)=0;  end;   end;
DoublePeakRBool=IndPR==0; 
%IndPR(DoublePeakRBool)=[];
%IndS(DoublePeakRBool)=[];
%IndE(DoublePeakRBool)=[];
%IndS0=IndS; 
%IndP=IndPR; 
%Search for higher preceeding points
IndPL=IndP; 
IndPPre=IndPL-1; 
if IndPPre(1)<1 IndPPre(1)=1; end;
CorrBool=trek(IndPPre,2)>trek(IndPL,2);    
while not(isempty(find(CorrBool)))
    IndPL=IndPL-CorrBool; 
    plot(trek(IndPL,1),trek(IndPL,2),'r^','MarkerSize',4); 
    IndPPre=IndPL-1; 
    if IndPPre(1)<1 IndPPre(1)=1; end;
    CorrBool=trek(IndPPre,2)>trek(IndPL,2);    
end;

% Search for double peaks  
SL=size(IndPL,1);
for i=1:SL-1 k=SL-i+1;  if IndPL(k)==IndPL(k-1) IndPL(k)=0;  end;  end;
DoublePeakLBool=IndPL==0; 
%IndPL(DoublePeakLBool)=[];
%IndS(DoublePeakLBool)=[];
%IndE(DoublePeakLBool)=[];
%IndS0=IndS;
%IndP=IndPL; 

DoublePeakBoolForw=DoublePeakRBool&not(DoublePeakLBool);  %peaks combined with higher forward peaks
DoublePeakBoolPrec=DoublePeakLBool&not(DoublePeakRBool);  %peaks combined with higher preceeding peaks
DoublePeakBool=DoublePeakBoolForw|DoublePeakBoolPrec;     %All double peaks
DoublePeakNum=size(find(DoublePeakBool),1); 

plot(trek(IndP,1),trek(IndP,2),'r^','MarkerSize',6); 
fprintf('Search for double peaks  =             %7.4f\n', toc); tic;     
fprintf('   the number of double peaks = %3.0f \n', DoublePeakNum); 

%corrections of the peak starts   (look trek007 @5061 us)
IndSL=IndS-1;
if IndSL(1)<1 IndSL(1)=1; end;
CorrBool=trek(IndSL,2)<trek(IndS,2);    
while not(isempty(find(CorrBool)))
    IndS=IndS-CorrBool; 
    plot(trek(IndS,1),trek(IndS,2),'b>','MarkerSize',4); 
    IndSL=IndS-1; 
    if IndSL(1)<1 IndSL(1)=1; end;
    CorrBool=trek(IndSL,2)<trek(IndS,2);        
end; 

% Search for double starts  
S=size(IndSL,1);
for i=1:S-1
    k=S-i+1; 
    if IndSL(k)==IndSL(k-1) IndSL(k)=0;  end; 
end;
DoubleStartBool=IndSL==0; 
IndSL(DoubleStartBool)=[];
IndP(DoubleStartBool)=[];
IndE(DoubleStartBool)=[];
IndS=IndSL+1;                 % corrected start
IndS0(DoubleStartBool)=[];  % initial start
plot(trek(IndS,1),trek(IndS,2),'g>','MarkerFaceColor','g','MarkerSize',6); 
fprintf('    Front duration = %5.3f +/-  %5.3f\n', mean(IndP-IndS)*tau, std(IndP-IndS)*tau);
fprintf('    Pulse duration = %5.3f +/-  %5.3f\n', mean(IndE-IndS)*tau, std(IndE-IndS)*tau);

IndSL=IndS-ZeroPoints+1; 
IndSLOutBool=IndSL<1; 
IndSL(IndSLOutBool)=1; 

%Zero level calculations
NoiseLevel=StdVal*OverSt; 
for i=1:size(IndS,1)
    if trek(IndSL(i):IndS(i),2)<NoiseLevel 
        Zero(i)=mean(trek(IndSL(i):IndS(i),2));
        fit1(i)=0; fit0(i)=Zero(i);        
        x=trek(IndSL(i):IndS(i),1);
        y=ones(min(ZeroPoints,IndS(i)-IndSL(i)+1),1)*Zero(i);
    else
        x=trek(IndSL(i):IndS(i),1);
        y=trek(IndSL(i):IndS(i),2);
        poly = polyfit(x-trek(IndS(i),1),y,1);   %   y = fit1*(x-trek(IndS(i)) + fit0
        fit1(i)=poly(1); fit0(i)=poly(2);
        if fit1(i)<0                % this is the statisctical important case for plasma measurements
            Zero(i)=fit1(i)*(trek(IndP(i),1)-trek(IndS(i),1))+fit0(i); 
        else
            Zero(i)=fit0(i);
        end; 
        if Zero(i)<-NoiseLevel Zero(i)=0; end; %no opposite statistical important cases 
    end;    
    plot(x,y,'k>','MarkerSize',4);             
end; 
fprintf('Zero level calculations =              %7.4f\n', toc); tic;     

peaks(:,1)=trek(IndS0,1);                           %Start time,  us
peaks(:,2)=trek(IndP,1);                            %peak time,  us
NPeaks=size(peaks,1);
if NPeaks>1 Period=(peaks(end,1)-peaks(1,1))/NPeaks;  else
            Period=(trek(end,1)-trek(1,1));            end;                        
peaks(:,3)=circshift(peaks(:,2),-1)-peaks(:,2);   % peak-to-peak interval, us (after peak)
peaks(end,3)=Period; 

peaks(:,4)=Zero';                             %averaged zeros, counts
peaks(:,5)=trek(IndP,2)-Zero';             %peak amplitude, counts

% front charge calculations
ChargePoints=ChargeTime/tau;                    % charge time       
for i=1:NPeaks     
    if FrontCharge  
        ends=IndP(i);   % front charge        
    else  
        if i~=NPeaks NextPeakStart=IndS(i+1); else NextPeakStart=trekSize; end;       
        ends=min(IndS(i)+ChargePoints,trekSize);   Tail=0;                   
        if ends>NextPeakStart 
            ends=NextPeakStart;  
            Tail=trek(ends,2)*(ends-NextPeakStart)/2;      %takes tail into account
%           PreceedTail=
        end; 
    end;           
    x=trek(IndS(i):ends,1);
    if isempty(x) fprintf('empty charge: peak= %3.0f time= %9.3f\n',i,peaks(i,1));    end;
    if fit1(i)<0 
        y=fit1(i).*(x-trek(IndS(i),1))+fit0(i); y(y<0)=0; 
    else
        y=fit0(i)*ones(ends-IndS(i)+1,1);              % removes rising zeros
    end;
    peaks(i,6)=(Tail+sum(trek(IndS(i):ends,2)-y))/(ends-IndS(i));     %
    
    plot(x,y,'-k','LineWidth',1.5);
end; 
fprintf('front charge calculations   =          %7.4f\n', toc); tic;     

peaks(:,7)=peaks(:,6)./peaks(:,5);      % peak or front duration (depending on FrontCharge)

peaks(:,8)=1;   % number of combined peaks in one peak

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

%for i=1:NPeaks                                   % takes much time
%    IndS(i)=find(trek(:,1)==peaks(i,1));       % starts in the trek
%    IndP(i)=find(trek(:,1)==peaks(i,2));       % peaks in the trek
%end; 
%fprintf('marks trek   =  %7.4f\n', toc); tic;     

for i=1:max(peaks(:,8),[],1)                      % takes much time
    ExpecetedDoubles(i)=NPeaks*(MinInterval/Period)^i/factorial(i);
end; 
fprintf('ExpecetedDoubles   =                   %7.4f\n', toc); tic;     


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
if Delta==1 plot(trek(:,1),trekD,'-m'); end; 
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

subplot(2,1,2); semilogy(peaks(:,2),peaks(:,2)-peaks(:,1),'-ro'); hold on; grid on;    %front
                semilogy(peaks(:,1),peaks(:,7),'-yo');                      %peak or front duration, us
                semilogy(peaks(:,1),peaks(:,3),'-bo');                      %peak-to-peak
                semilogy(peaks(:,1),(peaks(:,8)-1),'md','MarkerFaceColor','y','MarkerSize',6);   % combined peaks                                           
                x=[trek(1,1),trek(end,1)]; 
                y=[tau,tau]; semilogy(x,y,'-g','LineWidth',1.5);                
                y=[ChargeTime,ChargeTime]; semilogy(x,y,'-g','LineWidth',1.5);                
                axis([MinTime,MaxTime,tau,1.2*max(peaks(:,3))]);
                set(gca,'ytick',[0.01 0.1 1 10 100 1000])
                xlabel('t, us'); ylabel('front & interval, us');                 
                legend('front', 'duration', 'interval to next',0);

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

fid=fopen('HistA.dat','w'); 
fprintf(fid,'%6.2f %3.0f %5.2f\n' ,HistA');
fclose(fid);    
fid=fopen('HistC.dat','w'); 
fprintf(fid,'%6.2f %3.0f %5.2f\n' ,HistC');
fclose(fid);    

if isstr(FileName) PeakFile=strrep(FileName,'trek','peaks'); else PeakFile='peaks.dat'; end; 
if isstr(FileName)&&strcmp(PeakFile,FileName) PeakFile=['Peaks',FileName]; end; 

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
if nargin==6    MaxVal=max(trD);     MinVal=min(trD);     DeltaM=MaxVal-MinVal; 
         else   MaxVal=max(tr(:,2)); MinVal=min(tr(:,2)); DeltaM=MaxVal-MinVal;  end; 
if nargin==6    M =mean(trD);     St=std(trD);     
         else   M =mean(tr(:,2)); St=std(tr(:,2));   end; 
if (MaxVal-M)>(M-MinVal) PeakPolarity=1; else PeakPolarity=-1;  end;                   
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
