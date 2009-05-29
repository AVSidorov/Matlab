function [peaks,trekMinus]=GetPeaks_my(trek,PeakSet,Pass,FileName)
%PeakSet ->  PeakInd,PeakOnFrontInd,StandardPulse,Threshold
%PeakSet ->  SelectedPeakInd,PeakOnFrontInd,StandardPulseNorm,Threshold
% PeakSet is calculated with Tops.m from raw trek.

%trek - track of data of positive (!) pulses
%PeakInd - indexes of peak tops
%PeakOnFrontInd - indexes of peak tops which appeared on another peak front
% StandardPulse - standard pulse extracted from the track
% Threshold - threshold for peak amplitude (see Tops.m for details)

tau=0.025;        % us digitizing time

MinFront=0.05;    % minimal peak front, us
MaxFront=0.125;    % maximal peak front, us
MinTail=0.05;     % minimal peak tail, us
MaxTail=0.8;      % maximal peak tail, us

BckgFitN=2;       %number of points for background fitting
InterpN=8;        %number of extra intervals for interpolation of Standard Pulse in fitting
FineInterpN=40;   %number of extra intervals for fine interpolation of Standard Pulse in fitting

PulsePlotBool= false;   % Plot fitting pulses or not

MaxFrontN=round(MaxFront/tau); MaxTailN=round(MaxTail/tau);
MinFrontN=round(MinFront/tau); MinTailN=round(MinTail/tau);

TrekName=inputname(1);

% Interpolation of the standard pulse:
%intervals for pulse fitting:
trekSize=size(trek,1);
PeakN=size(PeakSet.SelectedPeakInd,1);
SampleN=size(PeakSet.StandardPulseNorm,1);
FirstNonZero=find(PeakSet.StandardPulseNorm>0,1,'first');
LastNonZero=find(PeakSet.StandardPulseNorm>0,1,'last');
[MaxStandardPulse,MaxStandardPulseIndx]=max(PeakSet.StandardPulseNorm);


FitPulseInterval=[FirstNonZero:MaxStandardPulseIndx+2]';
if FirstNonZero>BckgFitN
   FitBackgndInterval=[FirstNonZero-BckgFitN,FirstNonZero-1]';
else
   FitBackgndInterval=[1,FirstNonZero]'; 
end;   
FitN=size(FitPulseInterval,1);

PulseInterp(:,1)=(1:1/InterpN:SampleN)';
SampleInterpN=size(PulseInterp,1);

PulseInterpFine(:,1)=(1:1/FineInterpN:SampleN)';
SampleInterpFineN=size(PulseInterpFine,1);

PulseInterp(:,2)=interp1(PeakSet.StandardPulseNorm,PulseInterp(:,1),'spline')';

FirstNonZeroInterp=(FirstNonZero-1)*InterpN+1;           %expected from StandardPulseNorm
LastNonZeroInterp =(LastNonZero-1)*InterpN+1;            %expected from StandardPulseNorm
MaxPulseInterpIndx=(MaxStandardPulseIndx-1)*InterpN+1;   %expected from StandardPulseNorm
%corrections:
FirstNonZeroInterp=find(PulseInterp(1:FirstNonZeroInterp,2)<=0,1,'last')+1;
LastNonZeroInterp=find(PulseInterp(LastNonZeroInterp:end,2)<=0,1,'first')+LastNonZeroInterp-2;
PulseInterp(1:FirstNonZeroInterp-1,2)=0;
PulseInterp(LastNonZeroInterp+1:end,2)=0;
[MaxPulseInterp,Indx]=max(PulseInterp(:,2));
PulseInterp(:,2)=PulseInterp(:,2)/MaxPulseInterp;
%PulseInterp(:,2)=circshift(PulseInterp(:,2),MaxPulseInterpIndx-Indx);


FitInterpPulseInterval=(FitPulseInterval-1)*InterpN+1;
FitInterpPulseInterval=[FitInterpPulseInterval(1):FitInterpPulseInterval(end)];

PulseInterpFine(:,2)=interp1(PeakSet.StandardPulseNorm,PulseInterpFine(:,1),'spline')';

FirstNonZeroInterpFine=(FirstNonZero-1)*FineInterpN+1;           %expected from PeakSet.StandardPulseNorm
LastNonZeroInterpFine =(LastNonZero-1)*FineInterpN+1;            %expected from PeakSet.StandardPulseNorm
MaxPulseInterpFineIndx=(MaxStandardPulseIndx-1)*FineInterpN+1;   %expected from PeakSet.StandardPulseNorm

FirstNonZeroInterpFine=find(PulseInterpFine(1:FirstNonZeroInterpFine,2)<=0,1,'last')+1;
LastNonZeroInterpFine=find(PulseInterpFine(LastNonZeroInterpFine:end,2)<=0,1,'first')+LastNonZeroInterpFine-2;
PulseInterpFine(1:FirstNonZeroInterpFine-1,2)=0;
PulseInterpFine(LastNonZeroInterpFine+1:end,2)=0;
[MaxPulseInterpFine,Indx]=max(PulseInterpFine(:,2));
PulseInterpFine(:,2)=PulseInterpFine(:,2)/MaxPulseInterpFine;
%PulseInterpFine(:,2)=circshift(PulseInterpFine(:,2),MaxPulseInterpFineIndx-Indx);

FitFineInterpPulseInterval=(FitPulseInterval-1)*FineInterpN+1;
FitFineInterpPulseInterval=[FitFineInterpPulseInterval(1):FitFineInterpPulseInterval(end)];

PulseInterpFine(PulseInterpFine(:,2)<0,2)=0;
PulseInterp(PulseInterp(:,2)<0,2)=0;

%FitN=1+EndFitPoint+StartFitPoint;


StandardPulsePlot=figure; hold on; grid on;
title([TrekName,':  Standard pulse']);
PeakSet.StandardPulseNorm(:,2)=PeakSet.StandardPulseNorm*2/(MaxPulseInterp+MaxPulseInterpFine);
PeakSet.StandardPulseNorm(:,1)=[1-MaxStandardPulseIndx:SampleN-MaxStandardPulseIndx]';

PulseInterp(:,1)=[1-MaxPulseInterpIndx:SampleInterpN-MaxPulseInterpIndx]'/InterpN;
PulseInterpFine(:,1)=[1-MaxPulseInterpFineIndx:SampleInterpFineN-MaxPulseInterpFineIndx]'/FineInterpN;
plot(PulseInterpFine(:,1),PulseInterpFine(:,2),'-r','LineWidth',2);

plot(PulseInterp(:,1),PulseInterp(:,2),'-g.');
plot(PeakSet.StandardPulseNorm(:,1),PeakSet.StandardPulseNorm(:,2),'b*');

PulseInterpFineD=diff(PulseInterpFine(:,2)); 
PulseInterpFineD(end+1)=PulseInterpFineD(end); 
PulseInterpFineDD=diff(PulseInterpFine(:,2),2); 
PulseInterpFineDD(end+1)=PulseInterpFineDD(end);
PulseInterpFineDD(end+1)=PulseInterpFineDD(end);
PulseInterpFineF=-50000000*PulseInterpFineD.^2.*PulseInterpFineDD;
plot(PulseInterpFine(:,1),PulseInterpFineF,'-m.');

legend('PulseInterpFine','PulseInterp','StandardPulseNorm','PulseInterpFineF');

plot(FitPulseInterval-MaxStandardPulseIndx,PeakSet.StandardPulseNorm(FitPulseInterval,2),'ms','MarkerSize',8);
plot(FitBackgndInterval-MaxStandardPulseIndx,PeakSet.StandardPulseNorm(FitBackgndInterval,2),'ks');

x=[FitFineInterpPulseInterval(1),FitFineInterpPulseInterval(1)];
plot((x-1)/FineInterpN-MaxStandardPulseIndx+1,[0,1],'-r');
x=[FitFineInterpPulseInterval(end),FitFineInterpPulseInterval(end)];
plot((x-1)/FineInterpN-MaxStandardPulseIndx+1,[0,1],'-r');
x=[FitInterpPulseInterval(1),FitInterpPulseInterval(1)];
plot((x-1)/InterpN-MaxStandardPulseIndx+1,[0,0.5],'-g');
x=[FitInterpPulseInterval(end),FitInterpPulseInterval(end)];
plot((x-1)/InterpN-MaxStandardPulseIndx+1,[0,0.5],'-g');
fprintf('Pause. look at the figures and press any key\n');
%pause;
if PulsePlotBool; delete(StandardPulsePlot); end;


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

trekMinus=trek;
i=0;
peaks=[];  
KhiCoeff(1)=1/FitN/PeakSet.Threshold^2;                 %full fit
KhiCoeff(2)=1/(FitN-1)/PeakSet.Threshold^2;  %middle fit
KhiCoeff(3)=1/(FitN-2)/PeakSet.Threshold^2;    %short fit

%figure; plot(trek(1:1000,2));

FitBackgndInterval=FitBackgndInterval-MaxStandardPulseIndx;
FitPulseInterval=FitPulseInterval-MaxStandardPulseIndx;
StartFitPoint=FitPulseInterval(1);
FitSignalStart=PeakSet.SelectedPeakInd+StartFitPoint;
if FitSignalStart(1)<1
    FitSignalStart(1)=[];
    PeakSet.SelectedPeakInd(1)=[]; PeakN=PeakN-1;
end;
fprintf('scan the trek with Standard pulse...\n');   tic;
if PulsePlotBool;  PulsePlot=figure; end; 
NPeaksSubtr=0; 
while i<PeakN
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


        if (Ampl>PeakSet.Threshold)     %%%&&((Ampl/PeakSet.Threshold)^2>*MinKhi2); %(MinKhi2<Khi2Thr)&;
            trekMinus(FitIdx(FitIdxOk))=trekMinus(FitIdx(FitIdxOk))-SubtractedPulse(FitIdxOk);
            NPeaksSubtr=NPeaksSubtr+1;
            peaks(NPeaksSubtr,1)=PeakSet.SelectedPeakInd(i);             %PeakSet.SelectedPeakInd Max initial
            peaks(NPeaksSubtr,2)=PeakSet.SelectedPeakInd(i)*tau+dtau;      %Peak Max Time fitted
            peaks(NPeaksSubtr,3)=peaks(NPeaksSubtr,2);     % for peak-to-peak interval
            peaks(NPeaksSubtr,4)=B;                        %Peak Zero Level
            peaks(NPeaksSubtr,5)=Ampl;                     %Peak Amplitude
            peaks(NPeaksSubtr,6)=MinKhi2;% /Ampl;               % KhiMin
            peaks(NPeaksSubtr,7)=Pass;                     % number of Pass in which peak finded
        end;  %(MinKhi2>0)&(MinKhi2<Khi2Thr)&(Ampl>0);
    end;  %if trekMinus(PeakSet.SelectedPeakInd(i))-B>PeakSet.Threshold
end;  %while
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
  
  HistPoints= 100;    % average number of points per an histogram interval
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
  title([TrekName,': Peak amplitude histogram']);
  xlabel('Lg(Amplitude)');
  subplot(2,1,2); title([TrekName,': Chi^2 histogram']);  hold on; 
  [Max,MaxKhiInd]=max(Hist(:,4));
  KhiThreshold=10^(Hist(MaxKhiInd,3)+1);  
  plot(log10([KhiThreshold,KhiThreshold]),[0,Max/2],'-r','LineWidth',2);
  legend('Chi^2 threshold');
  errorbar(Hist(:,3),Hist(:,4),Hist(:,4).^0.5,'-b.'); grid on; 
  xlabel('Lg(Chi^2)');
  figure; hold on; title([TrekName,': Chi^2 versus peak amplitude']);
  plot(peaks(:,5),peaks(:,6),'r.');
  xlabel('Peak Amplitude');  ylabel('Chi^2');
  
  HighKhiBool=peaks(:,6)>KhiThreshold;
  
  figure; title([TrekName,':  tracks']);
  plot(trek); hold on; plot(trekMinus,'r');  
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
   peaks(peaks(:,6)>KhiThreshold,:)=[];
   peaks(end,3)=mean(peaks(1:end-1,3));  % period of peaks
   
   NPeaksSubtr=size(peaks,1);
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
if exist('PEAKS')==7
    PeakFolder=[cd,'\PEAKS\'];
else
    mkdir(cd,'PEAKS');
    PeakFolder=[cd,'\PEAKS\'];
end;
if nargin==4 
 if isstr(FileName) 
     PassStr=num2str(Pass);   
     %[path,name,ext,versn]=fileparts(FileName);
     %PeakFile=[PeakFolder,strrep(name,'trek','peak'),'Pass',PassStr,ext]; 
     PeakFile=[PeakFolder,'Peak',FileName,'Pass',PassStr,'.dat']; 
 end;
 
else 
    PeakFile=[PeakFolder,'peak000.dat']    
end; 
fprintf('Peaks will be writen \n in %s \n file', PeakFile);


fid=fopen(PeakFile,'w');
fprintf(fid,' InitMax   FitMax     interv    zero    ampl    MinKhi  Pass\n'); 
fprintf(fid,'%10.3f %10.3f %9.3f %7.2f %7.2f %7.2f %5.3f\n' ,peaks');
fclose(fid);    
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
 