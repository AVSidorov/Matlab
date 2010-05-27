function TrekSet=TrekGetPeaks(TrekSetIn,Pass);

TrekSet=TrekSetIn;

disp('>>>>>>>>Get Peaks started');

MinFront=0.05;    % minimal peak front, us
MaxFront=0.125;   % maximal peak front, us
MinTail=0.05;     % minimal peak tail, us
MaxTail=0.8;      % maximal peak tail, us

notProcessTail=8; % number of points after exceeding of Maxsignal, which will'nt be processed

BckgFitN=2;       %number of points for background fitting
InterpN=8;        %number of extra intervals for interpolation of Standard Pulse in fitting
FineInterpN=40;   %number of extra intervals for fine interpolation of Standard Pulse in fitting

PulsePlotBool= false;   % Plot fitting pulses or not
EndPlotBool=TrekSet.Plot;       % Plot after proccessing




trek=TrekSet.trek;
tau=TrekSet.tau;
OverSt=TrekSet.OverStStd;      % noise regection threshold, in standard deviations
TrekName=TrekSet.name;
trekSize=TrekSet.size;
StandardPulseNorm=TrekSet.StandardPulse;
MaxSignal=TrekSet.MaxSignal;
PeakN=size(TrekSet.SelectedPeakInd,1);    

if nargin<2
    Pass=1;
end;



% MaxFrontN=round(MaxFront/tau); MaxTailN=round(MaxTail/tau);
% MinTailN=round(MinTail/tau);
MinFrontN=round(MinFront/tau);




%Mark interval where signal will be processed
trekProcessBool=trek<MaxSignal;
for i=1:notProcessTail
    trekProcessBoolSh=circshift(trekProcessBool,1);
    trekProcessBoolSh(1)=true;
    trekProcessBool=trekProcessBool&trekProcessBoolSh;
end;
clear trekProcessBoolSh;



% Interpolation of the standard pulse:
%intervals for pulse fitting:



[PulseInterpFine,PulseInterp]=...
    InterpStanrdadPulse(BckgFitN,InterpN,FineInterpN,0,StandardPulseNorm);
PulseInterp(:,2)=smooth(PulseInterp(:,2),InterpN);
PulseInterpFine(:,2)=smooth(PulseInterpFine(:,2),FineInterpN);

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




trekMinus=trek;
i=0;  
peaks=zeros(PeakN,7);  

KhiCoeff(1)=1/FitN;     %/TrekSet.Threshold^2;      %full fit
KhiCoeff(2)=1/(FitN-1); %/TrekSet.Threshold^2;  %middle fit
KhiCoeff(3)=1/(FitN-2); %/TrekSet.Threshold^2;  %short fit
FitBackgndInterval=FitBackgndInterval-MaxStandardPulseIndx;
FitPulseInterval=FitPulseInterval-MaxStandardPulseIndx;
StartFitPoint=FitPulseInterval(1);
NPeaksSubtr=0; 


%figure; plot(trek(1:1000,2));
if not(isempty(TrekSet.SelectedPeakInd))
    FitSignalStart=TrekSet.SelectedPeakInd+StartFitPoint;
    if FitSignalStart(1)<1
        FitSignalStart(1)=[];
        TrekSet.SelectedPeakInd(1)=[]; PeakN=PeakN-1;
    end;
    disp(['>>>>>>>>> scan the trek, pass # ', num2str(Pass)]); tic;
    if PulsePlotBool;  PulsePlot=figure; end; 
end;

% NullLine=zeros(treksize,1);

while (i<PeakN)&&not(isempty(TrekSet.SelectedPeakInd))
    i=i+1;
    A=[];Khi2Fit=[];FitSignal=[];
    MinKhi2=-1;MinKhi2Idx=-1;
    BckgIndx=TrekSet.SelectedPeakInd(i)+FitBackgndInterval;  BckgIndx(BckgIndx<1)=1;
    B=mean(trekMinus(BckgIndx));
    
    if trekMinus(TrekSet.SelectedPeakInd(i))-B>TrekSet.Threshold

        ShortFit=not(isempty(find(TrekSet.PeakOnFrontInd==TrekSet.SelectedPeakInd(i),1)));
        MiddleFit= trekMinus(TrekSet.SelectedPeakInd(i)+1)<...
                   trekMinus(TrekSet.SelectedPeakInd(i)+2)&not(ShortFit);
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
                Ampl=10*TrekSet.Threshold; % do not subtract this peak! 
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
            plot(FitBackgndInterval,trekMinus(TrekSet.SelectedPeakInd(i)+FitBackgndInterval),'-ko');
            if MinKhi2Idx<=1
                plot([1:FitNi]'+StartFitPoint-1,A(2)*FitPulsesEdge+B,'-mo');
                [Min,k]=min([Khi2Fit(1),1000000,Khi2Fit(3)]);
                plot([1:FitNi]'+StartFitPoint-1,A(k)*FitPulsesEdge+B,'-g.');
            end;
            if MinKhi2Idx>=InterpRange
                plot([1:FitNi]'+StartFitPoint-1,A(2)*FitPulsesEdge+B,'-mo');
                [Min,k]=min([Khi2Fit(end-2),1000000,Khi2Fit(end)]);
                plot([1:FitNi]'+StartFitPoint-1,A(k)*FitPulsesEdge+B,'-g.');
            end;
            if MinKhi2Idx<InterpRange&MinKhi2Idx>1
                plot([1:FitNi]'+StartFitPoint-1,A(2)*FitPulses(1:FitNi,MinKhi2Idx)+B,'-mo');
                [Min,k]=min([Khi2Fit(MinKhi2Idx-1),1000000,Khi2Fit(MinKhi2Idx+1)]);
                plot([1:FitNi]'+StartFitPoint-1,A(k)*FitPulses(1:FitNi,MinKhi2Idx+k-2)+B,'-g.');
            end;

            plot(PulseInterpFine(:,1),Ampl*PulseInterpFineShifted+B,'-r');
            
%             text(FitNi+StartFitPoint,A(2),num2str(Khi2Fin1),'Color','k');
%             text(FitNi+StartFitPoint,50,num2str(Khi2Fin2),'Color','g');           

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
        
        St=find(FitIdx==StartFitPoint);        
        KhiReal=sum((NetFitSignal'-SubtractedPulse(St:St+FitNi-1)).^2)/(FitNi*Ampl^2);
        MinKhiNrm=MinKhi2/Ampl^2;
%                 FitSignal(1:FitNi)=trekMinus(FitSignalStart(i):FitSignalStart(i)+FitNi-1);
%         NetFitSignal=FitSignal(1:FitNi)-B;

        
        FitIdx=TrekSet.SelectedPeakInd(i)+PulseInterpFine(1:FineInterpN:end,1);
        FitIdxOk=(FitIdx<trekSize-1)&(FitIdx>1+MinFrontN);

        
        MinusOk=false;
        
        if (Ampl>TrekSet.Threshold)&((Ampl+B)<MaxSignal)&...
             (abs(trekMinus(TrekSet.SelectedPeakInd(i))-Ampl-B)<OverSt*TrekSet.Threshold)           %%%&&((Ampl/TrekSet.Threshold)^2>*MinKhi2); %(MinKhi2<Khi2Thr)&;
            MinusOk=true;
        end;
%          if (Ampl>TrekSet.Threshold)&((Ampl+B)<MaxSignal)&not(MinusOk)&...
%               ((trekMinus(TrekSet.SelectedPeakInd(i))-Ampl-B)<OverSt*TrekSet.Threshold)%%%&&((Ampl/TrekSet.Threshold)^2>*MinKhi2); %(MinKhi2<Khi2Thr)&;
%              figure;
%              plot(FitIdx(FitIdxOk),trekMinus(FitIdx(FitIdxOk)));
%              grid on; hold on;
%              plot(FitIdx(FitIdxOk),SubtractedPulse(FitIdxOk)+B,'.r');
%              plot(FitIdx(FitIdxOk),trekMinus(FitIdx(FitIdxOk))-SubtractedPulse(FitIdxOk),'g-');
%              pause;
%              close(gcf);           
%          end;
        if MinusOk
            trekMinus(FitIdx(FitIdxOk))=trekMinus(FitIdx(FitIdxOk))-SubtractedPulse(FitIdxOk);
            NPeaksSubtr=NPeaksSubtr+1;
            peaks(NPeaksSubtr,1)=TrekSet.SelectedPeakInd(i);             %TrekSet.SelectedPeakInd Max initial
            peaks(NPeaksSubtr,2)=TrekSet.StartTime+TrekSet.SelectedPeakInd(i)*tau+dtau;  %Peak Max Time fitted
            peaks(NPeaksSubtr,3)=peaks(NPeaksSubtr,2);     % for peak-to-peak interval
            peaks(NPeaksSubtr,4)=B;                        %Peak Zero Level
            peaks(NPeaksSubtr,5)=Ampl;                     %Peak Amplitude
            peaks(NPeaksSubtr,6)=MinKhi2 ;%MinKhi2;% /Ampl;% KhiMin
            peaks(NPeaksSubtr,7)=Pass;                     % number of Pass in which peak finded
        end;  %(MinKhi2>0)&(MinKhi2<Khi2Thr)&(Ampl>0);
    end;  %if trekMinus(TrekSet.SelectedPeakInd(i))-B>TrekSet.Threshold    
end;  %while

%   TrekFg=figure; plot(trek); hold on;
%   title([TrekName,':  tracks. Pass=', num2str(Pass)]);
%   plot(trekMinus,'y');  grid on; hold on; 
%   plot(peaks(:,2)/tau,peaks(:,4)+peaks(:,5),'r^')
%   plot(peaks(:,2)/tau,peaks(:,4),'g>');
%   legend('trek','trekMinus','Amplitude+Zero','Zero');
%   pause;
%   close(TrekFg);  
% 

disp(['=======Search Peak finished. Elapsed time is ', num2str(toc),' sec']);



Ind=[NPeaksSubtr+1:PeakN];
peaks(Ind,:)=[]; 
PeakN=NPeaksSubtr;
  
TrekSet.trek=trekMinus;

if PeakN>1
  peaks=sortrows(peaks,2); 
  peaks(1:end-1,3)=diff(peaks(:,3)); peaks(end,3)=trek(end)-peaks(end,2); 
 
  TrekSet.peaks=[TrekSet.peaks;peaks];
  TrekSet.peaks=sortrows(TrekSet.peaks,2); 
end; 

fprintf('=====  Found pulses      ==========\n');
fprintf('The number of measured points  = %7.0f during %7.0f us \n',trekSize,trekSize*tau);
fprintf('The total number of peaks = %7.0f \n',PeakN);


fprintf('Last threshold = %7.0f \n',TrekSet.Threshold);


if EndPlotBool  
 if PeakN>1
  
    figure; hold on; 
        title([TrekName,': Chi^2 versus peak amplitude. Pass=', num2str(Pass)]);
          plot(peaks(:,5),peaks(:,6),'r.');
          xlabel('Peak Amplitude');  ylabel('Chi^2');
  
  
     TrekFg=figure; plot(trek); hold on; grid on;
         title([TrekName,':  tracks. Pass=', num2str(Pass)]);
          plot((peaks(:,2)-TrekSet.StartTime)/tau,peaks(:,4)+peaks(:,5),'r^');
          plot((peaks(:,2)-TrekSet.StartTime)/tau,peaks(:,4),'g>');
          plot(TrekSet.SelectedPeakInd,trek(TrekSet.SelectedPeakInd),'.r');
          plot(trekMinus,'y'); 
          legend('trek','Amplitude+Zero','Zero','Selected Peak Ind','trekMinus');

          dt=[];
          for i=1:NPeaksSubtr
            FitIdx=peaks(i,1)+PulseInterpFine(1:FineInterpN:end,1);
            dtau=peaks(i,2)-TrekSet.StartTime-peaks(i,1)*tau;
            FineShift=round(dtau/tau*FineInterpN);
            PulseInterpFineShifted=circshift(PulseInterpFine(:,2),FineShift);

            mark='.';    
            point=['k',mark];

            if dtau<-tau; point=['b',mark]; end;
            if dtau>tau; point=['r',mark]; end;

            plot(FitIdx,peaks(i,5)*PulseInterpFineShifted(1:FineInterpN:end)+peaks(i,4),point);
          end; 
            plot(trekMinus,'y'); 


 
    CloseGraphs;

 end;
end;

disp('>>>>>>>>Get Peaks finished');
 