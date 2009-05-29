function [peaks,HistA]=Peaks3(FileName,Dialog,MaxSignal)
%[peaks,HistA]=Peaks(FileName); gets peaks from plasma x-ray trek.

Text=false;           % switch between text and binary input files
Fourie=0;         %if Fourie=1 then performes Fourie transformation of the signal. 
                  % there are bugs in Fourie still. scale etc... 
Plot1=1;          % if 1 then trek plot is active                  
Plot2=0;          % if 1 then interval plot is active

AverageGate=0.025; % Averaging gate, us  (there is a 1 point shift between PeakInd and trek at 0.05 )
NoiseAverN=30;    % the number of points for noise (ONLY) averaging
OverSt=2;         % noise regection threshold, in standard deviations    
PeakSt=2;         % peak threshold, in standard deviations   
MinFront=0.05;    % minimal front edge of peaks, us
MaxFront=0.125;    % maximal front edge of peaks, us
MinTail=0.05;     % minimal tail edge of peaks, us
MaxTail=0.4;      % maximal tail edge of peaks, us
Dshift=1;         %circshift(trek(:,2),Dshift); 

HistInterval=20;  % count interval for amplitude and cahrge histograms
ChargeTime=0.5;   % us
tau=0.025;        % us digitizing time
lowf=5;           % MHz,  frequencies higher than lowf may be cut by digital filter

BFitSignalN=2;    %number of points for background fitting
BeyondMaxN=2;     %number of points beyond the maximum for signal fitting
InterpN=4;        %number of extra intervals for intrpolation of Standard Pulse in fitting
FineInterpN=40;   %number of extra intervals for fine intrpolation of Standard Pulse in fitting
Khi2Thr=5;        %Sigma^2 threshold in pulsefiting;      
SecondPassFull=false; %Second Pass of rejection with new noise etc. 
                      %search or with old values StdVal etc.
MaxPass=1;        % the max number of passes; 

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

if nargin<2; Dialog=true; MaxSignal=4095;  end; 

tic;

if not(isstr(FileName)); trek=FileName; else
   if Text;  trek=load(FileName);  else  
      fid = fopen(FileName); trek = fread(fid,inf,'int16'); fclose(fid); clear fid; 
end; end; 

if size(trek,2)==1; trek(:,2)=trek; trek(:,1)=(0:tau:tau*(size(trek,1)-1))'; end; 
bool=(trek(:,2)>4095)|(trek(:,2)<0); OutRangeN=size(find(bool),1); 
if OutRangeN>0; fprintf('%7.0f  points out of the ADC range  \n',OutRangeN); end; 
trek(bool,:)=[];  clear bool; 
trekSize=size(trek(:,1),1);
fprintf('Loading time =                                %7.4f  sec\n', toc); tic; 

NPeaks=0;  DeltaNPeaks=1;   Pass=1;

while (DeltaNPeaks>0.1*NPeaks)&&(Pass<=MaxPass)
   
  if Pass==2; trekStart=trek(:,2); end;
  if Pass>1; trek=trekMinus; end;  
  NPeaks1=NPeaks;
  
  if SecondPassFull||Pass==1
      clear ThresholdD Threshold StdValD StdVal StartSignal EndSignal...
          SlowN SlowInd Slow SizeMoveToSignal SignalN;

      % search the signal pedestal and standard deviation
      NoiseArray=logical(true(trekSize,1));  % first, all measurements are considered as noise
      [MeanVal,StdVal,PeakPolarity,NoiseArray]=MeanSearch(trek,OverSt,NoiseArray,0,0);
      if PeakPolarity==1; trek(:,2)=trek(:,2)-MeanVal;  else trek(:,2)=MeanVal-trek(:,2); end;
      trekStart=trek;
      fprintf('First mean search  =                        %7.4f  sec\n', toc); tic;
      fprintf('  Standard deviat = %6.4f\n', StdVal);

      %remove fast oscillations of zero level:
      fprintf('Removing zero level oscillations...\n');
      Std0=StdVal; DeltaStd=1;
      while DeltaStd>0.1
          NoiseAver=filter(ones(1,NoiseAverN)/NoiseAverN,1,trek(NoiseArray,2));
          NoiseInterp=interp1(trek(NoiseArray,1),NoiseAver,trek(:,1),'linear');
%          StartNoise=find(NoiseArray==1,1,'first');   EndNoise=find(NoiseArray==1,1,'last');
          StartNoise=min(find(NoiseArray==1));   EndNoise=max(find(NoiseArray==1));
          NoiseInterp(1:StartNoise)=NoiseInterp(StartNoise);
          NoiseInterp(EndNoise+1:trekSize)=NoiseInterp(EndNoise);
          trek(:,2)=trek(:,2)-NoiseInterp;
          NoiseArray=logical(true(trekSize,1));
          [MeanVal,StdVal,PeakPolarity,NoiseArray]=MeanSearch(trek,OverSt,NoiseArray,0,0);
          trek(:,2)=trek(:,2)-MeanVal;
          DeltaStd=(Std0-StdVal)/StdVal;   Std0=StdVal;
      end;

      fprintf('  Final mean search  =                      %7.4f  sec\n', toc); tic;
      fprintf('  Standard deviat = %6.4f\n', StdVal);

      if Plot1;  TrekFigure0=figure;
          if isstr(FileName); set(TrekFigure0,'name',FileName); 
                        else; set(TrekFigure0,'name','array'); end;
          if Plot2||Fourie; subplot(3,1,1); else; subplot(2,1,1);end;
          hold on; grid on; xlabel('t, us');
          if Dialog; TrekPlot0=plot(trekStart(:,1),trekStart(:,2),'-b');   end;
          plot([trek(1,1),trek(end,1)],[StdVal,StdVal],'-r','LineWidth',1);
          plot([trek(1,1),trek(end,1)],[0,0],'-k','LineWidth',1);
          if Plot2||Fourie; subplot(3,1,2); else; subplot(2,1,2);end;
          hold on; grid on; xlabel('t, us');
          if Dialog; TrekPlot1=plot(trek(:,1),trek(:,2),'-b'); end;
          plot([trek(1,1),trek(end,1)],[StdVal,StdVal],'-r','LineWidth',1);
          plot([trek(1,1),trek(end,1)],[0,0],'-k','LineWidth',1);
      end;
      clear trekStart;

      if Dialog&&(Pass==1)
          MaxSignal = input('Input the maximum signal level. Higher signals will be cut: \n');
          if isempty(MaxSignal); MaxSignal = 1.1*max(trek(:,2)); end;
          MaxAmp=MaxSignal;
          MinTime = input('Input the minimum time.  Peaks before this time will be cut: \n');
          if isempty(MinTime); MinTime=trek(1,1); end;
          MaxTime = input('Input the maximum time.  Peaks after this time will be cut: \n');
          if isempty(MaxTime); MaxTime=trek(end,1); end;
          x=[MinTime,MaxTime]; y=[MaxSignal,MaxSignal];   FR1=plot(x,y,'-r','LineWidth',2);
          x=[MinTime,MinTime]; y=[0,MaxSignal];           FR2=plot(x,y,'-r','LineWidth',2);
          x=[MaxTime,MaxTime]; y=[0,MaxSignal];           FR3=plot(x,y,'-r','LineWidth',2);
          %%  Move OutLimits before PolyZero  ????
          OutLimits=(trek(:,1)>MaxTime)|(trek(:,1)<MinTime);   %|(trek(:,2)>MaxSignal);
          trek(OutLimits,:)=[];  NoiseArray(OutLimits,:)=[];
          trekSize=size(trek(:,1),1);
          clear OutLimits;  tic;
          if Fourie
              spectr=fft(trek(:,2),trekSize)/trekSize;
              spectr(:,1)=(0:1/tau/(trekSize-1):1/tau)';
              spectr(:,2)=spectr(:,1); spectr(:,3)=abs(spectr(:,2));
              MaxSpectr0=max(spectr(:,3));
              subplot(3,1,2);  xlabel('f, MHz');
              plot(spectr(:,1),spectr(:,3),'-r'); grid on; hold on;
              plot([lowf,lowf],[0,1.1*MaxSpectr0],'-g');
              axis([0 1/2/tau 0 max(spectr(:,3))]);    
              fprintf('fft  =                               %7.4f  sec\n', toc); 
              MaxSpectr = input('     Input the maximum peak amplitude in the high frequency part of the spectrum \n     Peaks will be restricted by this value: \n');
              if isempty(MaxSpectr);  MaxSpectr=MaxSpectr0; end;
              x=[lowf,1/2/tau]; y=[MaxSpectr,MaxSpectr];   plot(x,y,'-g');
          else
              MaxSpectr=1; MaxSpectr0=0.5;
          end;  
      else
          MaxAmp=MaxSignal;  MinTime=trek(1,1);  MaxTime=trek(end,1);
          MaxSpectr=1; MaxSpectr0=0.5;
      end;
      tic;

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
          fprintf('New mean search  =                                          %7.4f  sec\n', toc); tic;
          fprintf('  New mean            = %6.4f\n', MeanVal);
          fprintf('  New standard deviat = %6.4f\n', StdVal);
      end;
      fprintf('Pause. look at the figure and press any key\n');
      if Dialog pause;  end;
      %noise smoothing^

      if (Pass==1)&(AverageGate>=0.05)
          tic;
          SmoothGate=round(AverageGate/tau);
          %SmoothedNoise=filter(ones(1,SmoothGate)/SmoothGate,1,trek(NoiseArray,2));
          %trek(NoiseArray,2)=SmoothedNoise;
          SmoothedNoise=filter(ones(1,SmoothGate)/SmoothGate,1,trek(:,2));
          trek(:,2)=SmoothedNoise;
          [MeanVal,StdVal,PeakPolarity,NoiseArray]=MeanSearch(trek,OverSt,NoiseArray,0,0);
          %fprintf(' PeakPolarity = %2.0f\n', PeakPolarity);
          if PeakPolarity==1 trek(:,2)=trek(:,2)-MeanVal;  else trek(:,2)=MeanVal-trek(:,2); end;
          fprintf('Smoothed mean search  =                                                %7.4f  sec\n', toc);
          fprintf('  Smoothed mean            = %6.4f\n', MeanVal);
          fprintf('  Smoothed standard deviat = %6.4f\n', StdVal);
          clear SmoothGate SmoothedNoise;
      end;

      %if MaxSpectr<MaxSpectr0     delete(TrekPlot0);      delete(ImagTrekPlot);    end;

      %delete(TrekPlot0);delete(FR1);delete(FR2);delete(FR3);
      clear x y FR1 FR2 FR3;
      %TrekPlot0=plot(trek(:,1),trek(:,2),'-b');
      %fprintf('Pause. look at the figure and press any key\n');
      %pause;
      tic;
      % search the standard deviation of trekD noises

      trekR=circshift(trek(:,2),Dshift);   for i=1:Dshift   trekR(i)=trek(i,2);   end;
      trekL=circshift(trek(:,2),-Dshift);  for i=1:Dshift   trekL(end+1-i)=trek(end+1-i,2);   end;
      trekD=trek(:,2)-trekR;
      %plot(trek(:,1),trekD,'-m');
      LD=length(trekD);
      %[MeanValD,StdValD,PeakPolarity,NoiseArrayD]=MeanSearch(trek,OverSt,NoiseArray,0,0,trekD);
      StdValD=std(trekD(NoiseArray));
      MeanValD=mean(trekD(NoiseArray));

      clear trekR trekL trekDR trekDR;
      ThresholdD=StdValD*PeakSt;
      %ThresholdD=21
      Noise=(abs(trekD)<ThresholdD)&NoiseArray;
      % !!! remove noises as much as possible,
      %     but peaks started under Treshold may be missed!!!

      % Signal=(abs(trekD)>ThresholdD)|not(NoiseArray); %  remain signals as much as possible

      clear NoiseArray;

      %All in start noise
      NoiseR=circshift(Noise,1);   NoiseR(1)=1;     NoiseL=circshift(Noise,-1);  NoiseL(end)=1;
      StartNoise=find(Noise-NoiseR==1);   EndNoise=find(Noise-NoiseL==1);  % Noise intervals

      if  StartNoise(1)<EndNoise(1)       StartNoise(1)=[];   end;
      if  StartNoise(end)<EndNoise(end)   EndNoise(end)=[];   end;
      %Все что вначале трека в шум, чтоб не было пиков без началала
      Noise(1:EndNoise(1))=true;
      %Все что находится в конце трека в шум, чтоб не было незаконченных пиков
      Noise(StartNoise(end):end)=true;



      %   Signals intervals (include noise edges)
      StartSignal=EndNoise(1:end);   EndSignal=StartNoise(1:end);

      clear NoiseR NoiseL;

      % remove short signal intervals:
      MoveToNoise=find((EndSignal-StartSignal<2+MinFrontN+MinTailN));
      SizeMoveToNoise=size(MoveToNoise,1);
      for i=1:SizeMoveToNoise;
          Noise(StartSignal(MoveToNoise(i)):EndSignal(MoveToNoise(i)))=true;
      end;
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

      clear EndNoise StartNoise MoveToSignal;


      %remove slow signals:
      Slow=logical(zeros(1,SignalN));
      for i=1:SignalN
          Slow(i)=(size(find(trekD(StartSignal(i):EndSignal(i))>ThresholdD),1)<2);
      end;
      SlowInd=find(Slow); SlowN=size(SlowInd,2);
      for i=1:SlowN; Noise(StartSignal(SlowInd(i)):EndSignal(SlowInd(i)))=true; end;
      StartSignal(Slow)=[]; EndSignal(Slow)=[]; SignalN=size(StartSignal,1);

      fprintf('   %3.0f    slow signals are removed\n', SlowN);

      %remove small signals
      Threshold=StdVal*PeakSt;
      Range=zeros(1,SignalN);
      for i=1:SignalN; Range(i)=max(trek(StartSignal(i):EndSignal(i),2))-min(trek(StartSignal(i):EndSignal(i),2)); end;
      MoveToNoise=[]; MoveToNoise=find((Range<Threshold));
      SizeMoveToNoise=size(MoveToNoise,2);
      for i=1:SizeMoveToNoise; Noise(StartSignal(MoveToNoise(i)):EndSignal(MoveToNoise(i)))=true; end;
      StartSignal(MoveToNoise)=[]; EndSignal(MoveToNoise)=[];
      SignalN=size(StartSignal,1);
      fprintf('   %3.0f    small signals are removed\n', SizeMoveToNoise);

      clear MoveToNoise SizeMoveToNoise;
      clear Noise;
      plot(trek(StartSignal,1),trek(StartSignal,2),'g>');
      plot(trek(EndSignal,1),trek(EndSignal,2),'r<');
      fprintf('Signal intervals search  =                                            %7.4f  sec\n', toc);

      %fprintf('Pause. look at the figure and press any key\n');
      %pause;
  end;%if SecondPassFull|Pass==1
  tic;
  if Pass>1 
      Pass=Pass;
  end;
  %Test for matching noise, AllSignals and StartSignal EndSignal
  %Search for max inside signal intervals:
  PeakInd=[];PeakVal=[];GoodPeakInd=[];GoodPeakVal=[];PeakOnFrontInd=[];
  %NumPeaks=zeros(1,SignalN); MaxPeak=zeros(1,SignalN); FrontSignalN=zeros(1,SignalN);
  for i=1:SignalN
      S=StartSignal(i); E=EndSignal(i);
      %Нужно различать просто Видимые максимумы, коих много и хорошие
      %максимумы. В стандартные пики должны попадать только те, где и видимый
      %и хороший один
      if Pass==1
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
          [MaxPeak(i,1),Ind]=max(trek(S+VisiblePeakInd-1,2)); % max signal between S and E
          MaxPeakInd(i,1)=S+VisiblePeakInd(Ind)-1;
          FrontSignalN(i)=VisiblePeakInd(1);                  %from MK
      else
          VisiblePeakInd=find((trek(S:E,2)>=trek(S+1:E+1,2))&...
              (trek(S:E,2)>trek(S-1:E-1,2))&...
              (trek(S-1:E-1,2)>trek(S-2:E-2,2))&...
              (trek(S:E,2)>trek(S+2:E+2,2)+2*ThresholdD));  % preceeding
          NumPeaks(i)=size(VisiblePeakInd,1);
          if NumPeaks(i)==0 [Max,VisiblePeakInd]=max(trek(S:E,2));  end;

          PeakInd=[PeakInd;S+VisiblePeakInd-1];
          [MaxPeak(i,1),Ind]=max(trek(S+VisiblePeakInd-1,2)); % max signal between S and E
          MaxPeakInd(i,1)=S+VisiblePeakInd(Ind)-1;
          FrontSignalN(i)=VisiblePeakInd(1);                  %from MK
      end;
  end;   %for i=1:SignalN

  PeakN=size(PeakInd,1);
  GoodPeakN=size(GoodPeakInd,1);
  fprintf('Peak search  =                             %7.4f  sec\n', toc); tic;
  fprintf('Number of peaks before Double front search= %3.0f\n',PeakN);
  if Pass==1 fprintf('Number of Good peaks before Double front search= %3.0f\n',GoodPeakN);end;


  DoubleFrontInd=find(FrontSignalN>1.5*MaxFrontN);        %from MK
  DoubleFrontSize=size(DoubleFrontInd,2);                 %from MK
  % Search first peak in double fronts:                   %from MK
  if DoubleFrontSize>0                                    %from MK
      for i=1:DoubleFrontSize                             %from MK
          S=StartSignal(DoubleFrontInd(i))+1;             %from MK
          E=StartSignal(DoubleFrontInd(i))+FrontSignalN(DoubleFrontInd(i))-1;%from MK
          PeakSpanInd=find((trekD(S:E)<=trekD(S+1:E+1))&...
              (trekD(S:E)<trekD(S-1:E-1)));               %from MK
          if ~isempty(PeakSpanInd)
              PeakInd=[PeakInd;max(S+PeakSpanInd(1)-1,S)];    %from MK
              PeakOnFrontInd=[PeakOnFrontInd;max(S+PeakSpanInd(1)-1,S)];
              NumPeaks(DoubleFrontInd(i))=NumPeaks(DoubleFrontInd(i))+1; %from MK
              FrontSignalN(DoubleFrontInd(i))=NumPeaks(DoubleFrontInd(i))+1;%from MK
          end;
      end;                                                %from MK
      PeakInd=sort(PeakInd);                              %from MK
  end;                                                    %from MK

  PeakN=size(PeakInd,1);
  fprintf('Double Front search  =                                          %7.4f  sec\n', toc);
  fprintf('Number of peaks with Double fronts = %3.0f\n',PeakN);

  if Pass==1 
      plot(trek(GoodPeakInd,1),trek(GoodPeakInd,2),'mo');
      plot(trek(PeakInd,1),trek(PeakInd,2),'kd');
  end;

  %fprintf('Pause. look at the figure and press any key\n');
  %pause;
  tic;

  if Pass==1
      StandardPeaks=find((NumPeaks==1)'&(NumGoodPeaks==1)'&...
          ((EndSignal-StartSignal)>=MinFrontN+MinTailN)&...
          ((MaxPeakInd-StartSignal)>=MinFrontN)&...
          ((MaxPeakInd-StartSignal)<=MaxFrontN)&...
          (MaxPeak-trek(StartSignal,2)>=3*Threshold)&...
          (MaxPeak-trek(StartSignal,2)<MaxSignal)&MaxPeak<MaxSignal);
      StandardPeaksN=size(find(StandardPeaks),1);
      plot(trek(MaxPeakInd(StandardPeaks),1),trek(MaxPeakInd(StandardPeaks),2),'^r');
      %         figure; hold on;
      %         for i=1:StandardPeaksN
      %             plot(trek(StartSignal(StandardPeaks(i)):EndSignal(StandardPeaks(i)),2));
      %         end;
      %pause;
      fprintf('StandardPeaks  search  =                                    %7.4f  sec\n', toc);tic;
      fprintf('Number of StandardPeaks = %3.0f\n',StandardPeaksN);

      %Synhronize standard peaks using two highest points:

      AscendTop=trek(MaxPeakInd(StandardPeaks)-1)>=trek(MaxPeakInd(StandardPeaks)+1);
      SampleFront=2*MaxFrontN;  SampleTail=2*MaxTailN;
      SampleN=SampleFront+SampleTail+1;

      if MaxPeakInd(StandardPeaks(end))-AscendTop(end)+SampleTail>trekSize
          StandardPeaksN=StandardPeaksN-1; StandardPeaks(end)=[]; end;
      if MaxPeakInd(StandardPeaks(1))-AscendTop(1)-SampleFront<1; 
          StandardPeaksN=StandardPeaksN-1; StandardPeaks(1)=[]; end;
      
      StandardPulse=zeros(SampleFront+SampleTail+1,StandardPeaksN);
      
      for i=1:StandardPeaksN;
          NN=MaxPeakInd(StandardPeaks(i))-AscendTop(i);
          StandardPulse(:,i)=trek(NN-SampleFront:NN+SampleTail,2);
      end;
      SignalsOk=StandardPulse<MaxSignal;
      for i=1:SampleN
          SelectedStandrdPulse=StandardPulse(i,SignalsOk(i,:));
          MeanStandardPulse(i,1)=mean(SelectedStandrdPulse);
          stdStandardPulse(i,1)=std(SelectedStandrdPulse);
          SelectedN(i,1)=sum(SignalsOk(i,:));
      end;
      figure;
      subplot(2,1,1);  hold on;
      %plot(StandardPulse);
      %MeanStandardPulse=mean(StandardPulse,2);
      %stdStandardPulse=std(StandardPulse,0,2);
      x=[1:SampleN]';
      for i=1:StandardPeaksN
          plot(x(SignalsOk(:,i)),StandardPulse(SignalsOk(:,i),i));
      end;
      plot(MeanStandardPulse,'-co'); plot(stdStandardPulse,'-m.');
      grid on;
      [MinStdLeft,LeftMin]=min(stdStandardPulse(1:SampleFront));
      [MinStdRight,RightMin]=min(stdStandardPulse(SampleFront+1:end));
      RightMin=RightMin+SampleFront-1;

      DeltaMean=(StandardPulse-repmat(MeanStandardPulse,1,StandardPeaksN));

      SignalsLeftOk=DeltaMean(1:LeftMin,:)<=2*MinStdLeft;
      SignalCenterOk=logical(ones(RightMin-LeftMin-1,StandardPeaksN));
      SignalsRightOk=DeltaMean(RightMin:end,:)<=2*MinStdRight;
      SignalsOk=SignalsOk&[SignalsLeftOk;SignalCenterOk;SignalsRightOk];

      x=[1:SampleN]';
      subplot(2,1,2);   hold on;
      for i=1:StandardPeaksN
          plot(x(SignalsOk(:,i)),StandardPulse(SignalsOk(:,i),i));
      end;

      clear  SignalsLeftOk SignalCenterOk SignalsRightOk;

      for i=1:SampleN
          SelectedStandrdPulse=StandardPulse(i,SignalsOk(i,:));
          MeanStandardPulse(i,1)=mean(SelectedStandrdPulse);
          stdStandardPulse(i,1)=std(SelectedStandrdPulse);
          SelectedN(i,1)=sum(SignalsOk(i,:));
      end;
      plot(stdStandardPulse,'-m.');
      x=[1:SampleFront+1-MaxFrontN,SampleN-SampleTail+MaxTailN:SampleN]';
      Zero=polyfit(x,MeanStandardPulse(x),1);
      x=[1:SampleN]';
      MeanStandardPulse=MeanStandardPulse-(Zero(1)*x+Zero(2));
      stdStandardPulse= stdStandardPulse./(SelectedN-1).^0.5;
      ToZero=MeanStandardPulse<stdStandardPulse;
      MeanStandardPulse(ToZero)=0;
      [MaxStandardPulse,MaxStandardPulseIndx]=max(MeanStandardPulse);
      FirstNonZero=max(find(MeanStandardPulse(1:MaxStandardPulseIndx)==0))+1;
      LastNonZero=min(find(MeanStandardPulse(MaxStandardPulseIndx:end)==0))+MaxStandardPulseIndx;
      MeanStandardPulse(1:FirstNonZero-1)=0;
      MeanStandardPulse(LastNonZero+1:end)=0;
      plot(MeanStandardPulse,'-c');
      for i=1:SampleN
          plot([i,i],[MeanStandardPulse(i)-stdStandardPulse(i),MeanStandardPulse(i)+stdStandardPulse(i)],...
              '-c','LineWidth',2);
      end;
      grid on;

      StandardPulseNorm=MeanStandardPulse/MaxStandardPulse;

      %intervals for pulse fitting:
      FitPulseInterval=[FirstNonZero:MaxStandardPulseIndx+BeyondMaxN]';
      FitBackgndInterval=[FirstNonZero-BFitSignalN,FirstNonZero-1]';
      FitN=size(FitPulseInterval,1);

      PulseInterp(:,1)=(1:1/InterpN:SampleN)';
      SampleInterpN=size(PulseInterp,1);

      PulseInterpFine(:,1)=(1:1/FineInterpN:SampleN)';
      SampleInterpFineN=size(PulseInterpFine,1);

      PulseInterp(:,2)=interp1(StandardPulseNorm,PulseInterp(:,1),'spline');

      FirstNonZeroInterp=(FirstNonZero-1)*InterpN+1;           %expected from StandardPulseNorm
      LastNonZeroInterp =(LastNonZero-1)*InterpN+1;            %expected from StandardPulseNorm
      MaxPulseInterpIndx=(MaxStandardPulseIndx-1)*InterpN+1;   %expected from StandardPulseNorm
      %corrections:
      FirstNonZeroInterp=max(find(PulseInterp(1:FirstNonZeroInterp,2)<=0))+1;
      LastNonZeroInterp=min(find(PulseInterp(LastNonZeroInterp:end,2)<=0))+LastNonZeroInterp-2;
      PulseInterp(1:FirstNonZeroInterp-1,2)=0;
      PulseInterp(LastNonZeroInterp+1:end,2)=0;
      [Max,Indx]=max(PulseInterp(:,2));
      PulseInterp(:,2)=PulseInterp(:,2)/Max;
      PulseInterp(:,2)=circshift(PulseInterp(:,2),MaxPulseInterpIndx-Indx);


      FitInterpPulseInterval=(FitPulseInterval-1)*InterpN+1;
      FitInterpPulseInterval=[FitInterpPulseInterval(1):FitInterpPulseInterval(end)];

      PulseInterpFine(:,2)=interp1(StandardPulseNorm,PulseInterpFine(:,1),'spline');

      FirstNonZeroInterpFine=(FirstNonZero-1)*FineInterpN+1;           %expected from StandardPulseNorm
      LastNonZeroInterpFine =(LastNonZero-1)*FineInterpN+1;            %expected from StandardPulseNorm
      MaxPulseInterpFineIndx=(MaxStandardPulseIndx-1)*FineInterpN+1;   %expected from StandardPulseNorm
      %corrections:
      FirstNonZeroInterpFine=max(find(PulseInterpFine(1:FirstNonZeroInterpFine,2)<=0))+1;
      LastNonZeroInterpFine=min(find(PulseInterpFine(LastNonZeroInterpFine:end,2)<=0))+LastNonZeroInterpFine-2;
      PulseInterpFine(1:FirstNonZeroInterpFine-1,2)=0;
      PulseInterpFine(LastNonZeroInterpFine+1:end,2)=0;
      [Max,Indx]=max(PulseInterpFine(:,2));
      PulseInterpFine(:,2)=PulseInterpFine(:,2)/Max;
      PulseInterpFine(:,2)=circshift(PulseInterpFine(:,2),MaxPulseInterpFineIndx-Indx);
      FirstNonZeroInterpFine=FirstNonZeroInterpFine+MaxPulseInterpFineIndx-Indx;
      LastNonZeroInterpFine=LastNonZeroInterpFine+MaxPulseInterpFineIndx-Indx;


      FitFineInterpPulseInterval=(FitPulseInterval-1)*FineInterpN+1;
      FitFineInterpPulseInterval=[FitFineInterpPulseInterval(1):FitFineInterpPulseInterval(end)];


      %FitN=1+EndFitPoint+StartFitPoint;


      figure; hold on; grid on;
      StandardPulseNorm(:,2)=StandardPulseNorm;
      StandardPulseNorm(:,1)=[1-MaxStandardPulseIndx:SampleN-MaxStandardPulseIndx]';

      PulseInterp(:,1)=[1-MaxPulseInterpIndx:SampleInterpN-MaxPulseInterpIndx]'/InterpN;
      PulseInterpFine(:,1)=[1-MaxPulseInterpFineIndx:SampleInterpFineN-MaxPulseInterpFineIndx]'/FineInterpN;
      plot(PulseInterpFine(:,1),PulseInterpFine(:,2),'-r','LineWidth',2);
      x=[FitFineInterpPulseInterval(1),FitFineInterpPulseInterval(1)];
      plot((x-1)/FineInterpN-MaxStandardPulseIndx+1,[0,1],'-r');
      x=[FitFineInterpPulseInterval(end),FitFineInterpPulseInterval(end)];
      plot((x-1)/FineInterpN-MaxStandardPulseIndx+1,[0,1],'-r');
      plot(PulseInterp(:,1),PulseInterp(:,2),'-g.');
      x=[FitInterpPulseInterval(1),FitInterpPulseInterval(1)];
      plot((x-1)/InterpN-MaxStandardPulseIndx+1,[0,0.5],'-g');
      x=[FitInterpPulseInterval(end),FitInterpPulseInterval(end)];
      plot((x-1)/InterpN-MaxStandardPulseIndx+1,[0,0.5],'-g');
      plot(StandardPulseNorm(:,1),StandardPulseNorm(:,2),'b*');
      plot(FitPulseInterval-MaxStandardPulseIndx,StandardPulseNorm(FitPulseInterval,2),'ms','MarkerSize',8);
      plot(FitBackgndInterval-MaxStandardPulseIndx,StandardPulseNorm(FitBackgndInterval,2),'ks');
      fprintf('Pause. look at the figures and press any key\n');
      pause;

      tic;

      InterpHalfRange=2*InterpN;
      InterpRange=2*InterpHalfRange+1;
      for i=1:InterpRange for k=1:InterpRange DiagLogic(i,k)=i==k; end; end;
      x=FitInterpPulseInterval(1):InterpN:FitInterpPulseInterval(end);
      %x=[MaxPulseInterpIndx-StartFitPoint*InterpN:InterpN:MaxPulseInterpIndx+EndFitPoint*InterpN]';
      for i=1:InterpRange
          PulseInterpShifted=circshift(PulseInterp(:,2),-InterpHalfRange-1+i);
          FitPulses(1:FitN,i)=PulseInterpShifted(x);
          Sums3(i,1)=FitPulses(:,i)'*FitPulses(:,i);
          Sums3Short(i,1)=FitPulses(1:FitN-BeyondMaxN,i)'*FitPulses(1:FitN-BeyondMaxN,i);
      end;
  end;
  PulseInterpFineShifted=PulseInterpFine;
  PulseInterpShiftedTest=PulseInterpShifted;

  trekMinus=trek;
  i=0;
  if Pass==1 peaks=[]; end;
  Khi2Fin=[];
  KhiCoeff=1/FitN/StdVal^2;
  KhiCoeffShort=1/(FitN-BeyondMaxN)/StdVal^2;

  %figure; plot(trek(1:1000,2));

  FitBackgndInterval=FitBackgndInterval-MaxStandardPulseIndx;
  FitPulseInterval=FitPulseInterval-MaxStandardPulseIndx;
  StartFitPoint=FitPulseInterval(1);
  fprintf('scan the trek with Standard pulse...\n');   tic;
  while i<size(PeakInd,1)
      i=i+1;
      A=[];B=[];Sum2=[];Sum3=[];Khi2Fit=[];PolyKhi2=[];FitSignal=[];FitPulseFin=[];
      MinKhi2(i)=-1;
      if Pass==2
          i=i;
      end;
      BckgIndx=PeakInd(i)+FitBackgndInterval;  BckgIndx(BckgIndx<1)=1;
      B(i)=mean(trekMinus(BckgIndx,2));
      ShortFit=not(isempty(find(PeakOnFrontInd==PeakInd(i))));

      FitSignal=[];
      FitSignalStart=PeakInd(i)+StartFitPoint;
      if FitSignalStart(1)>2
          if ShortFit
              FitNi=FitN-BeyondMaxN;
              FitSignal(1:FitNi,:)=trekMinus(FitSignalStart:FitSignalStart+FitNi-1,:);
              NetFitSignal=FitSignal(1:FitNi,2)-B(i);
              Sums1=NetFitSignal'*NetFitSignal;
              Sums2=FitPulses(1:FitNi,:)'*NetFitSignal;
              Khi2Fit=Sums1-(Sums2.^2)./Sums3Short;
              Khi2Fit=Khi2Fit*KhiCoeffShort;
          else
              FitNi=FitN;
              FitSignal(1:FitNi,:)=trekMinus(FitSignalStart:FitSignalStart+FitNi-1,:);
              NetFitSignal=FitSignal(1:FitNi,2)-B(i);
              Sums1=NetFitSignal'*NetFitSignal;
              Sums2=FitPulses'*NetFitSignal;
              Khi2Fit=Sums1-(Sums2.^2)./Sums3;
              Khi2Fit=Khi2Fit*KhiCoeff;
          end;
          %figure; plot(Khi2Fit,'-ko'); hold on;
          [MinKhi2(i),MinKhi2Idx(i)]=min(Khi2Fit);
          CoarseShift=(MinKhi2Idx(i)-InterpHalfRange-1);
          NfromEdge=min(MinKhi2Idx(i)-1,InterpRange-MinKhi2Idx(i));
          if NfromEdge>0
              KhiFitN=min(NfromEdge,2);
              x=[MinKhi2Idx(i)-KhiFitN:1:MinKhi2Idx(i)+KhiFitN]';
              if ShortFit A=Sums2(x)./Sums3Short(x); else A=Sums2(x)./Sums3(x);end;
              PolyKhi2=polyfit(x,Khi2Fit(x),2);
              Khi2MinIdxFine=-PolyKhi2(2)/(2*PolyKhi2(1));
              MinKhi2(i)=PolyKhi2(1)*Khi2MinIdxFine^2+PolyKhi2(2)*Khi2MinIdxFine+PolyKhi2(3);
              %plot(Khi2MinIdxFine,MinKhi2(i),'or');
              Ampl=interp1(x,A,Khi2MinIdxFine,'spline');
              FineShift(i)=round(FineInterpN/InterpN*(Khi2MinIdxFine-MinKhi2Idx(i)));
              FineShift(i)=CoarseShift*FineInterpN/InterpN+FineShift(i);
              PulseInterpFineShifted=circshift(PulseInterpFine(:,2),FineShift(i));
              dt(i)=FineShift(i)/FineInterpN*tau;
          else
              if MinKhi2Idx(i)==1
                  MinKhi2Idx(i)=1; MinKhi2(i)=Khi2Fit(1);
                  Ampl=Sums2(1)/Sums3(1);
                  CoarseShift(i)=(MinKhi2Idx(i)-InterpHalfRange-1);
                  FineShift(i)=0;
                  PulseInterpFineShifted=circshift(PulseInterpFine(:,2),FineShift(i));
                  dt(i)=FineShift(i)/FineInterpN*tau;
              end;
              if MinKhi2Idx(i)==InterpRange
                  MinKhi2Idx(i)=InterpRange;
                  MinKhi2(i)=Khi2Fit(end);
                  Ampl=Sums2(end)/Sums3(end);
                  CoarseShift(i)=(MinKhi2Idx(i)-InterpHalfRange-1);
                  FineShift(i)=0;
                  PulseInterpFineShifted=circshift(PulseInterpFine(:,2),FineShift(i));
                  dt(i)=FineShift(i)/FineInterpN*tau;
              end;
          end;
      else MinKhi2(i)=-1;Ampl=-1; end;
              
               %PulsePlot=figure;   %set(hp,'name',num2str(i));
               %plot([1:FitNi]'+StartFitPoint-1,NetFitSignal+B(i),'-bo'); hold on;
               %plot(FitBackgndInterval,trekMinus(PeakInd(i)+FitBackgndInterval,2),'-ko');
               %if NfromEdge>0
               %    plot([1:FitNi]'+StartFitPoint-1,A(KhiFitN+1)*FitPulses(1:FitNi,MinKhi2Idx(i))+B(i),'-g.');
               %    [Min,k]=min([Khi2Fit(MinKhi2Idx(i)-1),MinKhi2(i)*1000,Khi2Fit(MinKhi2Idx(i)+1)]);
               %    plot([1:FitNi]'+StartFitPoint-1,A(KhiFitN+k-1)*FitPulses(1:FitNi,MinKhi2Idx(i)+k-2)+B(i),'-g.');
               %end;
               %plot(PulseInterpFine(:,1),Ampl*PulseInterpFineShifted+B(i),'-r');
               %pause(0.05);
              
               
      FitIdx=PulseInterpFine(1:FineInterpN:end,1);
      SubtractedPulse=Ampl*PulseInterpFineShifted(1:FineInterpN:end);
      %plot(FitIdx,SubtractedPulse+B(i),'ro');
      %close(PulsePlot);
      FitIdx=PeakInd(i)+PulseInterpFine(1:FineInterpN:end,1);
      FitIdxOk=(FitIdx<trekSize-1)&(FitIdx>1+MinFrontN);


      if (MinKhi2(i)>0)&(Ampl>0);
          if  MinKhi2(i)<Khi2Thr
              trekMinus(FitIdx(FitIdxOk),2)=trekMinus(FitIdx(FitIdxOk),2)-SubtractedPulse(FitIdxOk);

              if Ampl>Threshold
                  NPeaks=NPeaks+1;
                  peaks(NPeaks,1)=trekMinus(PeakInd(i),1)-MinFront;  %Peak Start Time
                  peaks(NPeaks,2)=trekMinus(PeakInd(i),1)+dt(i);     %Peak Max Time
                  peaks(NPeaks,4)=B(i);                              %Peak Zero Level
                  peaks(NPeaks,5)=Ampl;                              %Peak Amplitude
                  peaks(NPeaks,6)=Ampl;                              %FrontCharge
                  peaks(NPeaks,7)=MaxFront+MaxTail;                  % peak or front duration (depending on FrontCharge)
                  peaks(NPeaks,8)=Pass;                              % number of Pass in which peak finded
              end;
              S=min(FitIdx(FitIdxOk)); E=max(FitIdx(FitIdxOk));


              VisiblePeakInd=find((trekMinus(S:E,2)>=trekMinus(S+1:E+1,2))&...
                  (trekMinus(S:E,2)>trekMinus(S-1:E-1,2))&...
                  (trekMinus(S-1:E-1,2)>trekMinus(S-2:E-2,2))&...
                  (trekMinus(S:E,2)>trekMinus(S-MinFrontN:E-MinFrontN,2)+MinFrontN*ThresholdD)&...
                  (trekMinus(S:E,2)>trekMinus(S-MinFrontN:E-MinFrontN,2)+Threshold));  % preceeding
              VisiblePeakN=size(VisiblePeakInd,2);
              if (i<PeakN)&(VisiblePeakN>0)
                  VisiblePeakInd(find(S+VisiblePeakInd-1>=PeakInd(i+1)))=[];
              end;

              if VisiblePeakN>0
                  VisiblePeakInd(find(S+VisiblePeakInd-1<=PeakInd(i)))=[];
                  if numel(VisiblePeakInd)>0
                      PeakInd=[PeakInd;S+VisiblePeakInd(1)-1];
                      PeakN=size(PeakInd,1);
                      PeakInd=sort(PeakInd);
                  end;
                  %      plot(trekMinus(PeakInd(i+1),1),trekMinus(PeakInd(i+1),2),'md');
              end;

          end;
      end;
  end;
  %if size(PeakInd,1)>size(MinSigma,1) PeakInd(end)=[]; end;

  fprintf('trek rejection  =                         %7.4f  sec\n', toc);
  if Pass==1
      TrekFigure1=figure;
      if isstr(FileName); set(TrekFigure1,'name',[FileName, ': rejection of startnard pulses']);
      else; set(TrekFigure1,'name','array: rejection of startnard pulses'); end;
      hold on;
      plot(trek(:,1),trek(:,2),'-b'); plot(trek(PeakInd,1),trek(PeakInd,2),'bo');
      plot(trekMinus(:,1),trekMinus(:,2),'-r');
      plot([trek(1,1),trek(end,1)],[StdVal,StdVal],'-m','LineWidth',1);
  end;
  if Pass==2
      figure(TrekFigure1); hold on; plot(trek(PeakInd,1),trekStart(PeakInd),'r.');
      plot(trekMinus(:,1),trekMinus(:,2),'-k');
      plot([trek(1,1),trek(end,1)],[StdVal,StdVal],'-m','LineWidth',1);
  end;
  SF=figure;    plot(trek(PeakInd(:),1),MinKhi2','-m.');
  Khi2=figure;  plot(MinKhi2Idx-InterpHalfRange);
  Khi3=figure;  plot(MinKhi2Idx-InterpHalfRange,MinKhi2);
  fprintf('Pause. look at the figures and press any key\n');
  pause;
  close(SF);   close(Khi2); close(Khi3); % close(hp);
  tic;
  peaks=sortrows(peaks,2);
  NPeaks=size(peaks,1);
  DeltaNPeaks=NPeaks-NPeaks1;

  if Pass==1
      clear TrekPlot0 TailIdx Tail StandardPulsesNorm StandardPulses StandardPulse StandardPeaksN StandardPeaks StPeakN;
      clear RangeSP Range PolyTail PolyFitLog FitLog PeakVal PeakStart PeakEnd NumGoodPeaks;
      clear MaxPeak MaxPeakInd MaxStPeak MaxStPeakIdx MaxSPInd MaxIndSP MaxSP MinSP MinSPInd MinStPeak;
  end;
  clear k i SF VisiblePeakInd;
  clear Sum3 Sum2 Sum1;
  clear Khi2Fit S PulseOverThr ;
  clear PeakSpanInd PeakOnFrontInd PeakN PeakInd OutRangeN NumPeaks;
  clear MinKhi2Idx MinKhi2 MinInterval M Ind Idx;
  clear GoodPeakN GoodPeakInd GoodPeakVal FrontSignalN FitIdx FPS1  EndIdx E;
  clear DoubleFrontSize DoubleFrontInd A B;
Pass=Pass+1;
end;   %while (DeltaNPeaks>0.1*NPeaks)&&(Pass>MaxPass)

  
  


if NPeaks>1 Period=(peaks(end,1)-peaks(1,1))/NPeaks;  else
              Period=(trek(end,1)-trek(1,1));            end;                        
  peaks(:,3)=circshift(peaks(:,2),-1)-peaks(:,2);   % peak-to-peak interval, us (after peak)
  peaks(end,3)=Period; 
    
  %if size(PeakInd,1)>size(MinSigma,1) PeakInd(end)=[]; end;
  
    
  
  
  
%peak amplitude histogram
MaxAmpl=max(peaks(:,5));
MinAmpl=0; %min(peaks(:,4));
PeakAmplRange=MaxAmpl-MinAmpl; 
HistIntervalA=HistInterval; %   =PeakAmplRange/HistN;       % interval for amplitudes
%HistN=fix(NPeaks/AveragN);  
HistN=fix(PeakAmplRange/HistIntervalA)+1;  
PassN=max(peaks(:,8));
if HistN==0; HistN=1; end;     % the number of intervals 
for p=1:PassN
    PassBool=peaks(:,8)==p;  PassBoolSize=size((find(PassBool)));
    for i=1:HistN
        HistA(p,i,1)=MinAmpl+(i-0.5)*HistIntervalA;
        HistBool=(peaks(:,5)<HistA(p,i,1)+HistIntervalA/2)&...
            (peaks(:,5)>=HistA(p,i,1)-HistIntervalA/2&PassBool);
        HistA(p,i,2)=size(peaks(HistBool),1);  %peak aplitude
        HH=HistA(p,i,2);
        HistA(p,i,3)=sqrt(HistA(p,i,2));           %peak aplitude error
    end;  end;
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
                
subplot(2,2,1); semilogy(HistA(1,:,1),HistA(1,:,2),'-ro'); hold on; grid on; 
                if PassN>1 semilogy(HistA(2,:,1),HistA(2,:,2),'-bo'); end;
                if PassN>2 semilogy(HistA(3,:,1),HistA(3,:,2),'-go'); end;
                if PassN>3 semilogy(HistA(4,:,1),HistA(4,:,2),'-ko'); end;
                x=[Threshold,Threshold]; y=[1,max(HistA(1,:,2))];
                semilogy(x,y,'-k');
                axis([0,max(HistA(1,:,1)),1,1.2*max(HistA(1,:,2))]);
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
%fprintf('Expected number of double peaks for %5.3f us = %5.3f \n', MinInterval, NPeaks*MinInterval/Period);
%fprintf('Detected number of double peaks for %5.3f us = %5.3f \n', MinInterval, size(find(peaks(:,end)==2)));
%fprintf('Expected number of triple peaks for %5.3f us = %5.3f \n', MinInterval, NPeaks*(MinInterval/Period)^2/2);
%fprintf('Detected number of triple peaks for %5.3f us = %5.3f \n', MinInterval, size(find(peaks(:,end)==2)));
%fprintf('The selected number of double peaks for %5.3f us = %3.0f \n', MinInterval, DoublePeakNum);
%fprintf('The selected number of triple peaks for %5.3f us = %3.0f \n', MinInterval, TriplePeakNum);
fprintf('=====================\n');                

if isstr(FileName) HistAFile=FileName; HistAFile(1:4)='hisA'; 
   else HistAFile='HistA.dat'; end; 
% fid=fopen(HistAFile,'w'); 
% fprintf(fid,'%6.2f %3.0f %5.2f\n' ,HistA');
% fclose(fid);    
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
if isstr(FileName) end;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [MeanVal,StdVal,PP,Noise]=MeanSearch(tr,OverSt,Noise,Plot1,Plot2,trD);    
% search the signal pedestal and make it zero
           % Input parameters: tr or trD - input measurements, Over St (see above), Noise - assumed initial noise array  
           % Output parameters: MeanValue, Standad deviation, Pulse polarity, Noise - residual noise array
if nargin<4     Plot1=false;    Plot2=false;    end;  
if nargin<5     Plot2=false;    end;  
trSize=size(tr(:,1),1); %  (N,1) dimension


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
    NoiseIndx=find(Noise);
    Noise(1:NoiseIndx(1))=1;  Noise(NoiseIndx(end):end)=1;
if Plot1  plot(tr(:,1),M(L)-OverSt*St(L)+Noise*OverSt*St(L), '-g');    end; 
MeanVal=M(L); StdVal=St(L); PP=PeakPolarity;
%M(1)=[];  St(1)=[]; L=L-1; 
if Plot2
    figure;
    subplot(3,1,1); plot(M-M(L),'-or');  grid on; title('means');
    subplot(3,1,2); plot(St,'-*b'); grid on;  title('Std''s');
    subplot(3,1,3); plot(NoisePoints,'-or'); grid on;  title('Noise points');    
end;
clear NoiseIndx NoiseL NoiseR SingleNoise;