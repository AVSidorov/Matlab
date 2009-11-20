function [peaks,trekMinus]=GetPeaks(FileName,PassNumber,PeakSet,StandardPulseIN);
%[peaks,trekMinus]=GetPeaks(trek,Pass,PeakSet)
%FileName - file or array of row trek data
%PassNumber is the number of passes 
%PeakSet -> [SelectedPeakInd,PeakOnFrontInd,Threshold]
%PeakSet is calculated with Tops.m from raw trek 
%   OR  if PeakSet=[] then it is calculated here:  PeakSet=Tops(trek,1); 

%trek - track of row data 
%PeakInd - indexes of peak tops
%PeakOnFrontInd - indexes of peak tops which appeared on another peak front
% StandardPulse - standard pulse extracted from the track
% Threshold - threshold for peak amplitude (see Tops.m for details)

Text  = false;    % switch between text and bin files
tau=0.020;        % us digitizing time
MinFront=0.05;    % minimal peak front, us
MaxFront=0.125;   % maximal peak front, us
MinTail=0.05;     % minimal peak tail, us
MaxTail=0.8;      % maximal peak tail, us

MaxSignal=4095;   % maximal signal whithout distortion
notProcessTail=8; % number of points after exceeding of Maxsignal, which will'nt be processed
OverSt=1.1;      % noise regection threshold, in standard deviations

SmoothParam=1;    % number of points for smoothing


BckgFitN=2;       %number of points for background fitting
InterpN=8;        %number of extra intervals for interpolation of Standard Pulse in fitting
FineInterpN=40;   %number of extra intervals for fine interpolation of Standard Pulse in fitting
StandardPulseFile='D:\!SCN\EField\StandPeakAnalys\StPeak20ns_2.dat';
PulsePlotBool= false;   % Plot fitting pulses or not


% MaxFrontN=round(MaxFront/tau); MaxTailN=round(MaxTail/tau);
% MinTailN=round(MinTail/tau);
MinFrontN=round(MinFront/tau);
TrekName=inputname(1);

disp('>>>>>>>>Get Peaks started');

if nargin<3;
    [trek,ProcInt,ProcIntTime,StdVal]=PrepareTrek(FileName); 
else
    trek=FileName;
end;


trekSize=size(trek,1);
%Mark interval where signal will be processed
trekProcessBool=trek<MaxSignal;
for i=1:notProcessTail
    trekProcessBoolSh=circshift(trekProcessBool,1);
    trekProcessBoolSh(1)=true;
    trekProcessBool=trekProcessBool&trekProcessBoolSh;
end;
clear trekProcessBoolSh;
trek=smooth(trek,SmoothParam);

if nargin<3|isempty(PeakSet);
    [PeakSet,StandardPulseN]=Tops(trek,1,trekProcessBool);
    StandardPulseIN=StandardPulseN;
    disp('Standard Pulse and Peak Set are taken from ''Tops''');
end;

% Interpolation of the standard pulse:
%intervals for pulse fitting:
if nargin<4|isempty(StandardPulseIN)
  
    Decision='f';
    if exist(StandardPulseFile,'file');
     StandardPulseF=load(StandardPulseFile);
     Decision=input('Press ''F'' to load Standard Pulse from file, any key for Pulse from ''Tops''','s');
     if isempty(Decision); Decision='q'; end;  
    end;

    if Decision=='f'||Decision=='F'
      StandardPulseNorm=StandardPulseF;
      disp(['Standard Pulse is taken from File ',StandardPulseFile]);
    else
      [PeakSet1,StandardPulseNorm]=Tops(trek,1,trekProcessBool);
      clear PeakSet1;
      disp('Standard Pulse is taken from ''Tops''');
    end;
else
    StandardPulseIND=diff(StandardPulseIN);
    StandardPulseIND(end+1)=StandardPulseIND(end);
    StandardPulseINDD=diff(StandardPulseIN,2);
    StandardPulseINDD(end+1)=StandardPulseINDD(end);
    StandardPulseINDD(end+1)=StandardPulseINDD(end);
    StandardPulseINF=-20*StandardPulseIND.^2.*StandardPulseINDD;

    figure;
    plot(StandardPulseIN,'-r.'); grid on; hold on;
    plot(StandardPulseINF,'-b.');
    
    [StPMax,StPMaxInd]=max(StandardPulseIN);
    [StPMax1,StPMax1Ind]=max(StandardPulseIN(StandardPulseIN<StPMax));
    StPFitInd=min(StPMaxInd,StPMax1Ind);

    Decision='q';
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
        plot([(StPFitInd-StPFFitInd)+1:(StPFitInd-StPFFitInd)+size(StandardPulseNormFile,1)],StandardPulseNormFile,'-ro'); grid on;  hold on;
        plot([(StPFitInd-StPFFitInd)+1:(StPFitInd-StPFFitInd)+size(StandardPulseNormFile,1)],StandardPulseNormFileF,'-bo');
        legend('Standard Pulse','Standard Pulse F','File Standard Pulse','File Standard Pulse F');

        Decision=input('Press ''F'' to load Standard Pulse from file, any key for inputed pulse \n','s');
        if isempty(Decision); Decision='q'; end;  
    end;
  
    if Decision=='f'||Decision=='F'
      StandardPulseNorm=StandardPulseNormFile;
      disp(['Standard Pulse is taken from file ', StandardPulseFile]);
    else
        StandardPulseNorm=StandardPulseIN;
        disp('Standard Pulse is taken from function input');
    end;
  
end;

[PulseInterpFine,PulseInterp]=...
    InterpStanrdadPulse(BckgFitN,InterpN,FineInterpN,0,StandardPulseNorm);
PulseInterp(:,2)=smooth(PulseInterp(:,2),SmoothParam*InterpN);
PulseInterpFine(:,2)=smooth(PulseInterpFine(:,2),SmoothParam*FineInterpN);

FirstNonZero=find(StandardPulseNorm>0,1,'first');
[MaxStandardPulse,MaxStandardPulseIndx]=max(StandardPulseNorm);
FitPulseInterval=[FirstNonZero:MaxStandardPulseIndx+2]';
if FirstNonZero>BckgFitN
   FitBackgndInterval=[FirstNonZero-BckgFitN,FirstNonZero-1]';
else
   FitBackgndInterval=[1,FirstNonZero]'; 
end;   
FitN=size(FitPulseInterval,1);
FitInterpPulseInterval=(FitPulseInterval-1)*InterpN+1;



InterpHalfRange=2*InterpN;
InterpRange=2*InterpHalfRange+1;
%for i=1:InterpRange; for k=1:InterpRange; DiagLogic(i,k)=i==k; end; end;
xInterp=FitInterpPulseInterval(1):InterpN:FitInterpPulseInterval(end); % full fit
% xInterpMiddle=xInterp(1:end-1);                                        % middle fit
% xInterpShort=xInterp(1:end-2);                                         % short fit
%xInterp=[MaxPulseInterpIndx-StartFitPoint*InterpN:InterpN:MaxPulseInterpIndx+EndFitPoint*InterpN]';
for i=1:InterpRange
    PulseInterpShifted=circshift(PulseInterp(:,2),-InterpHalfRange-1+i);
    FitPulses(1:FitN,i)=PulseInterpShifted(xInterp);
    Sums3(i,1)=FitPulses(:,i)'*FitPulses(:,i);  % full fit
    Sums3(i,2)=FitPulses(1:FitN-1,i)'*FitPulses(1:FitN-1,i); % middle fit
    Sums3(i,3)=FitPulses(1:FitN-2,i)'*FitPulses(1:FitN-2,i); % short fit
end;

PulseInterpFineShifted=PulseInterpFine;




PeakN=size(PeakSet.SelectedPeakInd,1);
trekMinus=trek;
i=0;  peaks=[];  
KhiCoeff(1)=1/FitN;     %/PeakSet.Threshold^2;      %full fit
KhiCoeff(2)=1/(FitN-1); %/PeakSet.Threshold^2;  %middle fit
KhiCoeff(3)=1/(FitN-2); %/PeakSet.Threshold^2;  %short fit
FitBackgndInterval=FitBackgndInterval-MaxStandardPulseIndx;
FitPulseInterval=FitPulseInterval-MaxStandardPulseIndx;
StartFitPoint=FitPulseInterval(1);
NPeaksSubtr=0; 


for Pass=1:PassNumber
%figure; plot(trek(1:1000,2));
if not(isempty(PeakSet.SelectedPeakInd))
    FitSignalStart=PeakSet.SelectedPeakInd+StartFitPoint;
    if FitSignalStart(1)<1
        FitSignalStart(1)=[];
        PeakSet.SelectedPeakInd(1)=[]; PeakN=PeakN-1;
    end;
    disp(['>>>>>>>>> scan the trek, pass # ', num2str(Pass)]); tic;
    if PulsePlotBool;  PulsePlot=figure; end; 
end;

while (i<PeakN)&&not(isempty(PeakSet.SelectedPeakInd))
    i=i+1;
    A=[];Khi2Fit=[];FitSignal=[];
    MinKhi2=-1;MinKhi2Idx=-1;
    BckgIndx=PeakSet.SelectedPeakInd(i)+FitBackgndInterval;  BckgIndx(BckgIndx<1)=1;
    B=mean(trekMinus(BckgIndx));
    if trekMinus(PeakSet.SelectedPeakInd(i))-B>PeakSet.Threshold

        ShortFit=not(isempty(find(PeakSet.PeakOnFrontInd==PeakSet.SelectedPeakInd(i),1)));
        MiddleFit= trekMinus(PeakSet.SelectedPeakInd(i)+1)<...
                   trekMinus(PeakSet.SelectedPeakInd(i)+2)&not(ShortFit);
        FitType = 1; % full fit
        if MiddleFit; FitType = 2; end; % short fit
        if ShortFit;  FitType = 3; end; % short fit

        FitNi=FitN-FitType+1;
        FitSignal(1:FitNi)=trekMinus(FitSignalStart(i):FitSignalStart(i)+FitNi-1);
        NetFitSignal=FitSignal(1:FitNi)-B;
        Sums1=NetFitSignal*NetFitSignal';
        Sums2=FitPulses(1:FitNi,:)'*NetFitSignal';
        Khi2Fit=Sums1-(Sums2.^2)./Sums3(:,FitType);
        Khi2Fit=Khi2Fit*KhiCoeff(FitType);

        %====================================
        [MinKhi2,MinKhi2Idx]=min(Khi2Fit);
        
        if (MinKhi2Idx>1)&&(MinKhi2Idx<InterpRange)
            if (ShortFit||MiddleFit)&&MinKhi2Idx>InterpHalfRange+InterpN
                %Shift of PulseInterp must be less then tau!!!
                EdgeFit=true;
                MinKhi2=Khi2Fit(InterpHalfRange+InterpN);
                MinKhi2Idx=InterpHalfRange+InterpN;
                Khi2MinFine=MinKhi2;  Khi2MinIdxFine=MinKhi2Idx;
                Ampl=Sums2(InterpHalfRange+InterpN)./...
                    Sums3(InterpHalfRange+InterpN,FitType);
                CoarseShift=InterpN-1;
                FineShift=CoarseShift*FineInterpN/InterpN;
            else
                EdgeFit=false;
                x=[MinKhi2Idx-1:1:MinKhi2Idx+1]';
                A=Sums2(x)./Sums3(x,FitType);    y=x;
                Khi2Fin1=1/FitNi*sum(((NetFitSignal-A(2)*FitPulses(1:FitNi,MinKhi2Idx)')./A(2)).^2);
            end;
        end;        
        
        if MinKhi2Idx==1
            EdgeFit=false;
            iEdge=-InterpHalfRange;
            Sums3Edge=Sums3(:,FitType);
            while Khi2Fit(1)<=Khi2Fit(2)
                iEdge=iEdge-1;
                PulseInterpShiftedEdge=circshift(PulseInterp(:,2),iEdge);
                FitPulsesEdge=PulseInterpShiftedEdge(xInterp(1:end-FitType+1));
                Sums3Edge=[FitPulsesEdge(1:FitNi)'*FitPulsesEdge(1:FitNi);Sums3Edge];
                Sums2=[FitPulsesEdge'*NetFitSignal';Sums2];
                Sums3Edge(end)=[];  Sums2(end)=[];
                Khi=Sums1-(Sums2(1)^2)./Sums3Edge(1);
                Khi=Khi*KhiCoeff(FitType);
                Khi2Fit=[Khi;Khi2Fit]; Khi2Fit(end)=[];
            end;
            x=[1:3]';
            MinKhi2Idx=InterpHalfRange+iEdge+1;
            MinKhi2=Khi2Fit(2);
            A=Sums2(x)./Sums3Edge(x);
            Khi2Fin1=1/FitNi*sum(((NetFitSignal-A(2)*FitPulsesEdge')./A(2)).^2);
            y=x+MinKhi2Idx-2;
        end;

        if MinKhi2Idx==InterpRange
            if (ShortFit||MiddleFit)
                %Shift of PulseInterp must be less then tau!!!
                EdgeFit=true;  NN=InterpN;
                MinKhi2=Khi2Fit(InterpHalfRange+NN);
                MinKhi2Idx=InterpHalfRange+NN;
                Khi2MinFine=MinKhi2;  Khi2MinIdxFine=MinKhi2Idx;
                Ampl=Sums2(InterpHalfRange+NN)./...
                    Sums3(InterpHalfRange+NN,FitType);
                CoarseShift=NN-1;
                FineShift=CoarseShift*FineInterpN/InterpN;
                Ampl=10*PeakSet.Threshold; % do not subtract this peak! 
            else
                EdgeFit=false;
                iEdge=InterpHalfRange;  Sums3Edge=Sums3(:,FitType);
                while Khi2Fit(end-1)>=Khi2Fit(end)
                    iEdge=iEdge+1;
                    PulseInterpShiftedEdge=circshift(PulseInterp(:,2),iEdge);
                    FitPulsesEdge=PulseInterpShiftedEdge(xInterp(1:end-FitType+1));
                    Sums3Edge=[Sums3Edge;FitPulsesEdge'*FitPulsesEdge];
                    Sums2=[Sums2;FitPulsesEdge'*NetFitSignal'];
                    Sums3Edge(1)=[];  Sums2(1)=[];
                    Khi=Sums1-(Sums2(end)^2)./Sums3Edge(end);
                    Khi=Khi*KhiCoeff(FitType);
                    Khi2Fit=[Khi2Fit;Khi]; Khi2Fit(1)=[];
                end;
                MinKhi2=Khi2Fit(end-1);
                MinKhi2Idx=iEdge+InterpHalfRange;
                x=[InterpRange-2:InterpRange]'; y=x+MinKhi2Idx-InterpRange+1;
                A=Sums2(x)./Sums3Edge(x);
                Khi2Fin1=1/FitNi*sum(((NetFitSignal-A(2)*FitPulsesEdge')./A(2)).^2);
            end;
        end;

        CoarseShift=(MinKhi2Idx-InterpHalfRange-1);
        if not(EdgeFit)
            PolyKhi2=polyfit(y,Khi2Fit(x),2);
            Khi2MinIdxFine=-PolyKhi2(2)/(2*PolyKhi2(1));
            Khi2MinFine=PolyKhi2(1)*Khi2MinIdxFine^2+PolyKhi2(2)*Khi2MinIdxFine+PolyKhi2(3);
            MinKhi2=Khi2MinFine;
            Ampl=interp1(y,A,Khi2MinIdxFine,'spline');
            FineShift=round(FineInterpN/InterpN*(Khi2MinIdxFine-MinKhi2Idx));
            FineShift=CoarseShift*FineInterpN/InterpN+FineShift;
        end;
        PulseInterpFineShifted=circshift(PulseInterpFine(:,2),FineShift);
        dtau=FineShift/FineInterpN*tau;
        


        if PulsePlotBool
            close(PulsePlot);
            PulsePlot=figure;   set(PulsePlot,'name',num2str(i));
            subplot(2,1,1);
            plot([1:FitNi]'+StartFitPoint-1,NetFitSignal+B,'-bo'); hold on;
            plot(FitBackgndInterval,trekMinus(PeakSet.SelectedPeakInd(i)+FitBackgndInterval),'-ko');
            if MinKhi2Idx<=1
                plot([1:FitNi]'+StartFitPoint-1,A(2)*FitPulsesEdge+B,'-ko');
                [Min,k]=min([Khi2Fit(1),1000000,Khi2Fit(3)]);
                plot([1:FitNi]'+StartFitPoint-1,A(k)*FitPulsesEdge+B,'-g.');
                Khi2Fin2=1/FitNi*sum(((NetFitSignal-A(k)*FitPulsesEdge')./A(k)).^2);
            end;
            if MinKhi2Idx>=InterpRange
                plot([1:FitNi]'+StartFitPoint-1,A(2)*FitPulsesEdge+B,'-ko');
                [Min,k]=min([Khi2Fit(end-2),1000000,Khi2Fit(end)]);
                plot([1:FitNi]'+StartFitPoint-1,A(k)*FitPulsesEdge+B,'-g.');
                Khi2Fin2=1/FitNi*sum(((NetFitSignal-A(k)*FitPulsesEdge')./A(k)).^2);
            end;
            if MinKhi2Idx<InterpRange&MinKhi2Idx>1
                plot([1:FitNi]'+StartFitPoint-1,A(2)*FitPulses(1:FitNi,MinKhi2Idx)+B,'-ko');
                [Min,k]=min([Khi2Fit(MinKhi2Idx-1),1000000,Khi2Fit(MinKhi2Idx+1)]);
                plot([1:FitNi]'+StartFitPoint-1,A(k)*FitPulses(1:FitNi,MinKhi2Idx+k-2)+B,'-g.');
                Khi2Fin2=1/FitNi*sum(((NetFitSignal-A(k)*FitPulses(1:FitNi,MinKhi2Idx+k-2)')./A(k)).^2);
            end;

            plot(PulseInterpFine(:,1),Ampl*PulseInterpFineShifted+B,'-r');
            
            text(FitNi+StartFitPoint,A(2),num2str(Khi2Fin1),'Color','k');
            text(FitNi+StartFitPoint,50,num2str(Khi2Fin2),'Color','g');           

            subplot(2,1,2);
            KhiDD=diff(Khi2Fit,2);
            KhiDD=[2*KhiDD(1)-KhiDD(2);KhiDD;2*KhiDD(end)-KhiDD(end-1)];
            plot(Khi2Fit,'-ko'); hold on;  plot(KhiDD,'-bo');
            plot(Khi2MinIdxFine,Khi2MinFine,'r*');
            text(Khi2MinIdxFine,max(Khi2Fit),num2str(Khi2MinFine));
            %%check MinKhi2Idx to be inside the KhiDD index range
            if MinKhi2Idx<1
                text(Khi2MinIdxFine,mean(Khi2Fit),num2str(KhiDD(2)),'color','b');
                text(Khi2MinIdxFine,(mean(Khi2Fit)+max(Khi2Fit))/2,num2str(Khi2MinFine/KhiDD(2)),'color','r');
            end;
            if MinKhi2Idx>InterpRange
                text(Khi2MinIdxFine,mean(Khi2Fit),num2str(KhiDD(end-1)),'color','b');
                text(Khi2MinIdxFine,(mean(Khi2Fit)+max(Khi2Fit))/2,num2str(Khi2MinFine/KhiDD(end-1)),'color','r');
            end;
            if MinKhi2Idx<InterpRange&MinKhi2Idx>1
                text(Khi2MinIdxFine,mean(Khi2Fit),num2str(KhiDD(MinKhi2Idx)),'color','b');
                text(Khi2MinIdxFine,(mean(Khi2Fit)+max(Khi2Fit))/2,num2str(Khi2MinFine/KhiDD(MinKhi2Idx)),'color','r');
            end;
            if ShortFit
                text(Khi2MinIdxFine/2,(mean(Khi2Fit)+max(Khi2Fit))/2,'Short fitting!!!','color','r');
            end;
            pause;
        end;

        FitIdx=PulseInterpFine(1:FineInterpN:end,1);
        SubtractedPulse=Ampl*PulseInterpFineShifted(1:FineInterpN:end);
        %plot(FitIdx,SubtractedPulse+B,'ro');

        FitIdx=PeakSet.SelectedPeakInd(i)+PulseInterpFine(1:FineInterpN:end,1);
        FitIdxOk=(FitIdx<trekSize-1)&(FitIdx>1+MinFrontN);


        if (Ampl>PeakSet.Threshold)&...
              (abs(trekMinus(PeakSet.SelectedPeakInd(i))-Ampl-B)<OverSt*PeakSet.Threshold)&...     %%%&&((Ampl/PeakSet.Threshold)^2>*MinKhi2); %(MinKhi2<Khi2Thr)&;
                ((Ampl+B)<MaxSignal)
%             yi=trekMinus(FitIdx(FitIdxOk));
%             fi=SubtractedPulse(FitIdxOk);
%             Khi2Fin=1/size(FitIdxOk,1)*sum(((yi-fi)./yi).^2);
            trekMinus(FitIdx(FitIdxOk))=trekMinus(FitIdx(FitIdxOk))-SubtractedPulse(FitIdxOk);
            NPeaksSubtr=NPeaksSubtr+1;
            peaks(NPeaksSubtr,1)=PeakSet.SelectedPeakInd(i);             %PeakSet.SelectedPeakInd Max initial
            peaks(NPeaksSubtr,2)=PeakSet.SelectedPeakInd(i)*tau+dtau;      %Peak Max Time fitted
            peaks(NPeaksSubtr,3)=peaks(NPeaksSubtr,2);     % for peak-to-peak interval
            peaks(NPeaksSubtr,4)=B;                        %Peak Zero Level
            peaks(NPeaksSubtr,5)=Ampl;                     %Peak Amplitude
            peaks(NPeaksSubtr,6)=Khi2Fin1 ;%MinKhi2;% /Ampl;% KhiMin
            peaks(NPeaksSubtr,7)=Pass;                     % number of Pass in which peak finded
        end;  %(MinKhi2>0)&(MinKhi2<Khi2Thr)&(Ampl>0);
    end;  %if trekMinus(PeakSet.SelectedPeakInd(i))-B>PeakSet.Threshold    
end;  %while
  TrekFg=figure; plot(trek); hold on;
  title([TrekName,':  tracks. Pass=', num2str(Pass)]);
  plot(trekMinus,'y');  grid on; hold on; 
  plot(peaks(:,2)/tau,peaks(:,4)+peaks(:,5),'r^')
  plot(peaks(:,2)/tau,peaks(:,4),'g>');
  legend('trek','trekMinus','Amplitude+Zero','Zero');
  pause;
  close(TrekFg);  


disp(['=======Pass #',num2str(Pass),' finished. Elapsed time is ', num2str(toc),' sec']);

if (Pass<PassNumber&PassNumber>1)&&not(isempty(PeakSet.SelectedPeakInd)); 
    PeakSetNew=Tops(trekMinus,1,trekProcessBool);
%     if PeakSetNew.Threshold>PeakSet.Threshold; 
%         PeakSetNew.Threshold=PeakSet.Threshold; 
%     end;  
    PeakSet=PeakSetNew;
    PeakN=size(PeakSet.SelectedPeakInd,1);
    i=0;
end;
PeakNumber(Pass)=size(find(peaks(:,end)==Pass),1);

end; % for Pass=1:PassNumber

  
  [PP,SortInd]=sort(peaks(:,2));
  peaks=peaks(SortInd,:); 
  PeakN=size(peaks,1);
  peaks(1:end-1,3)=diff(peaks(:,3)); peaks(end,3)=trek(end)-peaks(end,2); 
  
  
  
  Log10Peaks=log10(peaks(:,5)); Log10Khi=log10(peaks(:,6)); 

  HistPeaks=sid_hist(Log10Peaks);
  HistKhi=sid_hist(Log10Khi);


  HistogramPlot=figure; 
  AmplHistogramPlot=subplot(2,1,1); 
  errorbar(HistPeaks(:,1),HistPeaks(:,2),HistPeaks(:,3),'-r.'); grid on; hold on; 
  title([TrekName,': Peak amplitude histogram. Pass=', num2str(Pass)]);
  xlabel('Lg(Amplitude)');
  subplot(2,1,2); title([TrekName,': Chi^2 histogram']);  hold on; 
  [Max,MaxKhiInd]=max(HistKhi(:,2));
  %KhiThreshold=10^(Hist(MaxKhiInd,3)+1);  
  KhiThreshold=0.01;  
  plot(log10([KhiThreshold,KhiThreshold]),[0,Max/2],'-r','LineWidth',2);
  legend('Chi^2 threshold');
  errorbar(HistKhi(:,1),HistKhi(:,2),HistKhi(:,3),'-b.'); grid on; 
  xlabel('Lg(Chi^2)');
  figure; hold on; title([TrekName,': Chi^2 versus peak amplitude. Pass=', num2str(Pass)]);
  plot(peaks(:,5),peaks(:,6),'r.');
  xlabel('Peak Amplitude');  ylabel('Chi^2');
  
  HighKhiBool=peaks(:,6)>KhiThreshold;

  peaks(peaks(:,6)>KhiThreshold,:)=[];
  peaks(end,3)=mean(peaks(1:end-1,3));  % period of peaks
  for Pass=1:PassNumber
      PeakNumber(Pass)=size(find(peaks(:,end)==Pass),1);
  end; 
   
  NPeaksSubtr=size(peaks,1);
  
  TrekFg=figure; plot(trek); hold on; grid on;
  title([TrekName,':  tracks. Pass=', num2str(Pass)]);
  plot(peaks(:,2)/tau,peaks(:,4)+peaks(:,5),'r^')
  plot(peaks(:,2)/tau,peaks(:,4),'g>');
  legend('trek','trekMinus','Amplitude+Zero','Zero');
  dt=[];
  for i=1:NPeaksSubtr
      FitIdx=peaks(i,1)+PulseInterpFine(1:FineInterpN:end,1);
      dtau=peaks(i,2)-peaks(i,1)*tau;
      FineShift=round(dtau/tau*FineInterpN);
      PulseInterpFineShifted=circshift(PulseInterpFine(:,2),FineShift);
      if peaks(i,6)>KhiThreshold; mark='o'; 
      FitIdxOk=(FitIdx<trekSize-1)&(FitIdx>1+MinFrontN);   
      SubtractedPulse=peaks(i,5)*PulseInterpFineShifted(1:FineInterpN:end);
      trekMinus(FitIdx(FitIdxOk))=trekMinus(FitIdx(FitIdxOk))+SubtractedPulse(FitIdxOk);
      else mark='.'; end;
      %if peaks(i,6)>10; mark='*'; end;      
      point=['k',mark];
      if dtau<-tau; point=['b',mark]; end;
      if dtau>tau; point=['r',mark]; end;
         plot(FitIdx,peaks(i,5)*PulseInterpFineShifted(1:FineInterpN:end)+peaks(i,4),point); 
  end; 
  plot(trekMinus,'y'); 

  Log10Peaks=log10(peaks(:,5)); Log10Khi=log10(peaks(:,6)); 

  HistPeaks=sid_hist(Log10Peaks);
  HistKhi=sid_hist(Log10Khi);

  figure( HistogramPlot);
  subplot(AmplHistogramPlot); errorbar(HistPeaks(:,1),HistPeaks(:,2),HistPeaks(:,3),'-b.'); grid on; hold on; 
  
fprintf('=====  Found pulses      ==========\n');
fprintf('The number of measured points  = %7.0f during %7.0f us \n',trekSize,trekSize*tau);
fprintf('The total number of peaks = %7.0f \n',PeakN);
for Pass=1:PassNumber
    disp(['   The number of peaks found in pass # ', num2str(Pass), '  = ',num2str(PeakNumber(Pass))]);
end;


fprintf('Last threshold = %7.0f \n',PeakSet.Threshold);
CloseGraphs;
disp('========Get Peaks finished');



 