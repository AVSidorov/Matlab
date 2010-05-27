function [peaks,trekMinus]=GetPeaks(FileName,PassNumber,PeakSet);
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

% The spectrum is found from peaks by Hist.m program 

Text  = false;    % switch between text and bin files
tau=0.025;        % us digitizing time
MinFront=0.05;    % minimal peak front, us
MaxFront=0.125;   % maximal peak front, us
MinTail=0.05;     % minimal peak tail, us
MaxTail=0.8;      % maximal peak tail, us

BckgFitN=2;       %number of points for background fitting
InterpN=8;        %number of extra intervals for interpolation of Standard Pulse in fitting
FineInterpN=40;   %number of extra intervals for fine interpolation of Standard Pulse in fitting

%StandardPulseFile='D:\MK\matlab\SXR\Standard Pulse.dat';    % tact 25 ns
StandardPulseFile= 'D:\!SCN\EField\StandPeakAnalys\StPeak20ns_2.dat';  % tact 20 ns

PulsePlotBool= false;   % Plot fitting pulses or not

% MaxFrontN=round(MaxFront/tau); MaxTailN=round(MaxTail/tau);
% MinTailN=round(MinTail/tau);
MinFrontN=round(MinFront/tau);
TrekName=inputname(1);

if not(isstr(FileName)); 
    trek=FileName;  
    if size(trek,2)==2; trek(:,1)=[]; end;
else
    if Text;  trek=load(FileName); else
        fid = fopen(FileName); trek = fread(fid,inf,'int16'); fclose(fid); clear fid;
    end;
    if size(trek,2)==2; trek(:,1)=[]; end;
    bool=(trek>4095)|(trek<0); OutRangeN=size(find(bool),1);
    if OutRangeN>0; fprintf('%7.0f  points out of the ADC range  \n',OutRangeN); end;
    trek(bool)=[];  clear bool;
    MeanTr=mean(trek);
    if size(find(trek>MeanTr),1)>size(find(trek<MeanTr),1)
       trek=MeanTr-trek;  else trek=trek-MeanTr;  end;         
end;

trekSize=size(trek,1);

% Interpolation of the standard pulse:
%intervals for pulse fitting:

StandardPulseNorm=load(StandardPulseFile);
[PulseInterpFine,PulseInterp]=...
    InterpStanrdadPulse(BckgFitN,InterpN,FineInterpN,0,StandardPulseNorm);

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

if nargin<3|isempty(PeakSet);   PeakSet=Tops(trek,1);  end;

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
                plot([1:FitNi]'+StartFitPoint-1,A(2)*FitPulsesEdge+B,'-g.');
                [Min,k]=min([Khi2Fit(1),1000000,Khi2Fit(3)]);
                plot([1:FitNi]'+StartFitPoint-1,A(k)*FitPulsesEdge+B,'-g.');
            end;
            if MinKhi2Idx>=InterpRange
                plot([1:FitNi]'+StartFitPoint-1,A(2)*FitPulsesEdge+B,'-g.');
                [Min,k]=min([Khi2Fit(end-2),1000000,Khi2Fit(end)]);
                plot([1:FitNi]'+StartFitPoint-1,A(k)*FitPulsesEdge+B,'-g.');
            end;
            if MinKhi2Idx<InterpRange&MinKhi2Idx>1
                plot([1:FitNi]'+StartFitPoint-1,A(2)*FitPulses(1:FitNi,MinKhi2Idx)+B,'-g.');
                [Min,k]=min([Khi2Fit(MinKhi2Idx-1),1000000,Khi2Fit(MinKhi2Idx+1)]);
                plot([1:FitNi]'+StartFitPoint-1,A(k)*FitPulses(1:FitNi,MinKhi2Idx+k-2)+B,'-g.');
            end;

            plot(PulseInterpFine(:,1),Ampl*PulseInterpFineShifted+B,'-r');
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
            pause(0.001);
        end;

        FitIdx=PulseInterpFine(1:FineInterpN:end,1);
        SubtractedPulse=Ampl*PulseInterpFineShifted(1:FineInterpN:end);
        %plot(FitIdx,SubtractedPulse+B,'ro');

        FitIdx=PeakSet.SelectedPeakInd(i)+PulseInterpFine(1:FineInterpN:end,1);
        FitIdxOk=(FitIdx<trekSize-1)&(FitIdx>1+MinFrontN);


        if (Ampl>PeakSet.Threshold)&...
              (abs(trekMinus(PeakSet.SelectedPeakInd(i))-Ampl-B)<3*PeakSet.Threshold)     %%%&&((Ampl/PeakSet.Threshold)^2>*MinKhi2); %(MinKhi2<Khi2Thr)&;
            trekMinus(FitIdx(FitIdxOk))=trekMinus(FitIdx(FitIdxOk))-SubtractedPulse(FitIdxOk);
            NPeaksSubtr=NPeaksSubtr+1;
            peaks(NPeaksSubtr,1)=PeakSet.SelectedPeakInd(i);             %PeakSet.SelectedPeakInd Max initial
            peaks(NPeaksSubtr,2)=PeakSet.SelectedPeakInd(i)*tau+dtau;      %Peak Max Time fitted
            peaks(NPeaksSubtr,3)=peaks(NPeaksSubtr,2);     % for peak-to-peak interval
            peaks(NPeaksSubtr,4)=B;                        %Peak Zero Level
            peaks(NPeaksSubtr,5)=Ampl;                     %Peak Amplitude
            peaks(NPeaksSubtr,6)=MinKhi2;% /Ampl;          % KhiMin
            peaks(NPeaksSubtr,7)=Pass;                     % number of Pass in which peak finded
        end;  %(MinKhi2>0)&(MinKhi2<Khi2Thr)&(Ampl>0);
    end;  %if trekMinus(PeakSet.SelectedPeakInd(i))-B>PeakSet.Threshold    
end;  %while

if (Pass<PassNumber&PassNumber>1)&&not(isempty(PeakSet.SelectedPeakInd)); 
    PeakSetNew=Tops(trekMinus,1);
    if PeakSetNew.Threshold>PeakSet.Threshold; 
        PeakSetNew.Threshold=PeakSet.Threshold; 
    end;  
    PeakSet=PeakSetNew;
    PeakN=size(PeakSet.SelectedPeakInd,1);
    i=0;
end;
PeakNumber(Pass)=size(find(peaks(:,end)==Pass),1);
disp(['=======Pass #',num2str(Pass),' finished']);  toc
end; % for Pass=1:PassNumber

  
  [PP,SortInd]=sort(peaks(:,2));
  peaks=peaks(SortInd,:); 
  PeakN=size(peaks,1);
  peaks(1:end-1,3)=diff(peaks(:,3)); peaks(end,3)=trek(end)-peaks(end,2); 
  
  
%   figure; title([TrekName,':  tracks']);
%   plot(trek); hold on; plot(trekMinus,'r');  
%   plot(peaks(:,2)/tau,peaks(:,4)+peaks(:,5),'r^')
%   plot(peaks(:,2)/tau,peaks(:,4),'g>');
%   legend('trek','trekMinus','Amplitude+Zero','Zero');
%   dt=[];
%   for i=1:NPeaksSubtr
%       FitIdx=peaks(i,1)+PulseInterpFine(1:FineInterpN:end,1);
%       dtau=peaks(i,2)-peaks(i,1)*tau;
%       FineShift=round(dtau/tau*FineInterpN);
%       PulseInterpFineShifted=circshift(PulseInterpFine(:,2),FineShift);
%       point='k.';
%       if dtau<-tau; point='b.'; end;
%       if dtau>tau; point='r.'; end;
%          plot(FitIdx,peaks(i,5)*PulseInterpFineShifted(1:FineInterpN:end)+peaks(i,4),point); 
%   end; 
  
  HistPoints= min(100,round(NPeaksSubtr/4));    % average number of points per an histogram interval
  if HistPoints==0; error('Error:  HistPoints=0'); end; 
  HistN=round(NPeaksSubtr/HistPoints);
  Log10Peaks=log10(peaks(:,5)); Log10Khi=log10(peaks(:,6)); 
  HistPeakStart =min(Log10Peaks);  HistPeakEnd   =max(Log10Peaks);
  HistKhiStart =min(Log10Khi);   HistKhiEnd =max(Log10Khi);  
  HistPeakStep=(HistPeakEnd-HistPeakStart)/(HistN-1);
  HistKhiStep=(HistKhiEnd-HistKhiStart)/(HistN-1);
for i=1:HistN 
    X=HistPeakStart+(i-1)*HistPeakStep;   Hist(i,1)=X;
    Hist(i,2)=size(find((Log10Peaks<=X+HistPeakStep/2)&(Log10Peaks>X-HistPeakStep/2)),1); 
    X=HistKhiStart+(i-1)*HistKhiStep;     Hist(i,3)=X;
    Hist(i,4)=size(find((Log10Khi<=X+HistKhiStep/2)&(Log10Khi>X-HistKhiStep/2)),1); 
end;
  HistogramPlot=figure; 
  AmplHistogramPlot=subplot(2,1,1); 
  errorbar(Hist(:,1),Hist(:,2),Hist(:,2).^0.5,'-r.'); grid on; hold on; 
  title([TrekName,': Peak amplitude histogram. Pass=', num2str(Pass)]);
  xlabel('Lg(Amplitude)');
  subplot(2,1,2); title([TrekName,': Chi^2 histogram']);  hold on; 
  [Max,MaxKhiInd]=max(Hist(:,4));
  KhiThreshold=10^(Hist(MaxKhiInd,3)+2);  
  plot(log10([KhiThreshold,KhiThreshold]),[0,Max/2],'-r','LineWidth',2);
  legend('Chi^2 threshold');
  errorbar(Hist(:,3),Hist(:,4),Hist(:,4).^0.5,'-b.'); grid on; 
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
  
  figure; plot(trek); hold on;
  title([TrekName,':  tracks. Pass=', num2str(Pass)]);
  plot(trekMinus,'r');  grid on; 
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
 
   HistN=round(NPeaksSubtr/HistPoints);
   Log10Peaks=log10(peaks(:,5)); Log10Khi=log10(peaks(:,6));
   HistPeakStart =min(Log10Peaks);  HistPeakEnd   =max(Log10Peaks);
   HistKhiStart =min(Log10Khi);   HistKhiEnd =max(Log10Khi);
   HistPeakStep=(HistPeakEnd-HistPeakStart)/(HistN-1);
   HistKhiStep=(HistKhiEnd-HistKhiStart)/(HistN-1);
   for i=1:HistN
       X=HistPeakStart+(i-1)*HistPeakStep;   Hist(i,1)=X;
       Hist(i,2)=size(find((Log10Peaks<=X+HistPeakStep/2)&(Log10Peaks>X-HistPeakStep/2)),1);
       X=HistKhiStart+(i-1)*HistKhiStep;     Hist(i,3)=X;
       Hist(i,4)=size(find((Log10Khi<=X+HistKhiStep/2)&(Log10Khi>X-HistKhiStep/2)),1);
   end;
  figure( HistogramPlot);
  subplot(AmplHistogramPlot); errorbar(Hist(:,1),Hist(:,2),Hist(:,2).^0.5,'-b.'); grid on; hold on; 
  
fprintf('=====  Found pulses      ==========\n');
fprintf('The number of measured points  = %7.0f during %7.0f us \n',trekSize,trekSize*0.025);
fprintf('The total number of peaks = %7.0f \n',PeakN);
for Pass=1:PassNumber
    disp(['   The number of peaks found in pass # ', num2str(Pass), '  = ',num2str(PeakNumber(Pass))]);
end;

fprintf('Last threshold = %7.0f \n',PeakSet.Threshold);
disp([]);
  
  %%%%%%%%%%%%%%%%%%%%  global PulsePlot isubplot(2,1,1); errorbar(Hist(:,1),Hist(:,2),Hist(:,2).^0.5,'-r.'); grid on; hold on; 
  
    function PulsePlotView(Delay);
        close(PulsePlot);
        PulsePlot=figure;   set(PulsePlot,'name',num2str(i));
        subplot(2,1,1);
        plot([1:FitNi]'+StartFitPoint-1,NetFitSignal+B,'-bo'); hold on;
        plot(FitBackgndInterval,trekMinus(PeakSet.SelectedPeakInd(i)+FitBackgndInterval),'-ko');
        if MinKhi2Idx<=1
            plot([1:FitNi]'+StartFitPoint-1,A(2)*FitPulsesEdge+B,'-g.');
        end;
        if MinKhi2Idx>=InterpRange
            plot([1:FitNi]'+StartFitPoint-1,A(2)*FitPulsesEdge+B,'-g.');
        end;
        if MinKhi2Idx<InterpRange&MinKhi2Idx>1
            plot([1:FitNi]'+StartFitPoint-1,A(2)*FitPulses(1:FitNi,MinKhi2Idx)+B,'-g.');
        end;

        %plot(PulseInterpFine(:,1),Ampl*PulseInterpFineShifted+B,'-r');
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
        if nargin==1; pause(Delay); else; pause; end;
 