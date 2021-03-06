function PulseTaylorTest;

 t=timer('StartDelay',0.01,'TimerFcn',';');

TrekSet.FileType='single';      %choose file type for precision in fread function 
TrekSet.tau=0.02;               %ADC period
TrekSet.StartOffset=0;       %in us old system was Tokamak delay + 1.6ms
TrekSet.OverSt=3;               %uses in StdVal
TrekSet.StandardPulseFile='D:\!SCN\EField\StandPeakAnalys\StPeakAmp4_20ns_2.dat';
% TrekSet.StandardPulseFile='D:\!SCN\EField\StandPeakAnalys\StPeak20ns_1.dat';
%TrekSet.StandardPulseFile='D:\!SCN\EField\StandPeakAnalys\StPeak.dat';
TrekSet.MaxSignal=4095;
TrekSet.MinSignal=0;
TrekSet.peaks=[];
TrekSet.StdVal=0;
TrekSet.Threshold=[];
TrekSet.StartTime=TrekSet.StartOffset;
% TrekSet.StartTime=3e4;
TrekSet.Plot=false;
TrekSet.type=[];              
TrekSet.FileName='test';
TrekSet.size=[];
TrekSet.name=[];
TrekSet.StandardPulse=[];
TrekSet.MeanVal=[];
TrekSet.PeakPolarity=1;
TrekSet.charge=[];
TrekSet.Date=[];
TrekSet.Shot=[];
TrekSet.Amp=[];
TrekSet.HV=[];
TrekSet.P=[];
TrekSet.Merged=true; %This field is neccessary to avoid repeat merging and Max/MinSignal level changing 

%Loading Standard Pulse
TrekSet=TrekStPLoad(TrekSet);

MaxInd=find(TrekSet.StandardPulse==1); %Standard Pulse must be normalized by Amp
BckgFitInd=find(TrekSet.StandardPulse==0);%Standard Pulse must have several zero point at front end and last zero point
BckgFitInd(end)=[];
BckgFitN=size(BckgFitInd,1); 
FrontN=MaxInd-BckgFitN;
TailInd=find(TrekSet.StandardPulse<=0);
TailInd(TailInd<MaxInd)=[];
TailInd=TailInd(1);

%This part is neccessary if shifted pulse moves in both sides from base
%peak. It's more useful to make base pulse in any case first like in trek
%proccesing

% if BckgFitN<=FrontN
%     TrekSet.StandardPulse=[zeros(FrontN-BckgFitN+1,1);TrekSet.StandardPulse];
%     MaxInd=MaxInd+FrontN-BckgFitN+1;
%     BckgFitN=FrontN+1;
%     TailInd=TailInd+FrontN-BckgFitN+1;
% end;

PulseN=numel(TrekSet.StandardPulse);
TrekSet.size=PulseN;

%emulating noise Amp4 Thr~50 StdVal~10
trek=-17+2*17*rand(PulseN,1);
TrekSet.StdVal=std(trek);
TrekSet.MeanVal=0;
TrekSet.Threshold=max([(max(trek)-min(trek)),50]);
PulseD=diff(TrekSet.StandardPulse);
PulseDD=diff(TrekSet.StandardPulse,2);

sh=[0:0.2:FrontN+TailInd];
% sh=[0:0.2:2*FrontN];
%ratio of peak Amplitudes max counts is 4095/2.5(ADC range in V)* 
%*2(Amplifier  max Amplitude in V)/20 (Threshold at Amp 3) ~=100
 rat=[0.03,0.04,0.05,0.65,0.08,0.1,0.125,0.15,0.2,0.25,0.33,0.5,0.66,0.75,1,1.5,2,3,4,5,7.5,10,15,20,25,30,40];
% rat=[0.1,0.15,0.2,0.25,0.33,0.5,0.66,0.75,1,2,3,5,10];
tb=zeros(1,13);
tb(1:11)=[0,0,1,MaxInd,1,MaxInd,1,MaxInd,1,FrontN,TailInd-BckgFitN];

for ri=1:numel(rat);
    for shi=1:numel(sh);
        PulseShifted=rat(ri)*interp1([1:PulseN],TrekSet.StandardPulse,[1:PulseN]-sh(shi),'spline',0)';
        PulseShifted(1:BckgFitN+fix(sh(shi)))=0;
        PulseShifted(end)=0;
        Stp=(TrekSet.StandardPulse+PulseShifted);
        StpR=circshift(Stp,1);
        StpL=circshift(Stp,-1);
        maxI=find(Stp>StpR&Stp>StpL);
%         maxI(maxI>=TailInd|maxI<=BckgFitN)=[];
        maxN=numel(maxI);
%         if maxN>1
%             plot(Stp,'m');
%             grid on; hold on;
%             plot(TrekSet.StandardPulse,'b');
%             plot(rat(ri)*interp1([1:PulseN],TrekSet.StandardPulse,[1:PulseN]-sh(shi),'spline',0)','k');
%             plot(maxI,Stp(maxI),'.r');         
%             pause;
%             close(gcf);
%         end;

        [StpMax,StpMaxI]=max(Stp);
        frontN=maxI(1)-BckgFitN;
        tailInd=find(Stp<=0);
        tailInd(tailInd<maxI(1))=[];
        tailInd=tailInd(1);

             
%                  tb(end+1,1)=rat(ri);
%                  tb(end,2)=sh(shi);
%                  tb(end,3)=StpMax;
%                  tb(end,4)=StpMaxI;
%                  tb(end,5)=maxN;
%                  tb(end,6)=maxI(1);
%                  tb(end,7)=Stp(maxI(1));                 
%                  tb(end,8)=maxI(end);
%                  tb(end,9)=Stp(maxI(end));                 
%                  tb(end,10)=frontN;
%                  tb(end,11)=tailInd-BckgFitN;
          StpT=interp1([1:PulseN],TrekSet.StandardPulse,[1.5:PulseN-0.5],'linear')'*(1+rat(ri))+rat(ri)*sh(shi)*PulseD;
          StpT1=interp1([1.5:PulseN-0.5],StpT,[1:PulseN],'spline',0)';
                 
%                
               


%             trek=[trek;Amp(ami)*Stp+TrekSet.trek];
        subplot(2,1,1);
             plot(Stp,'.r-');
             grid on; hold on;
             plot(StpT1,'.m-');           
             plot([1.5:PulseN-0.5],StpT,'.-','color',[0.7,0.1,0]);             
             
             plot(TrekSet.StandardPulse,'-b.');
             plot(PulseShifted,'.k-');
             plot([1.5:PulseN-0.5],interp1([1:PulseN],TrekSet.StandardPulse,[1.5:PulseN-0.5],'linear')'*rat(ri)+rat(ri)*sh(shi)*PulseD,'.-','color',[0.1,0.2,0.3]);            

            subplot(2,1,2);
             plot(Stp-StpT1,'.r-');
             grid on; hold on;
             plot([1.5:PulseN-0.5],interp1([1:PulseN],Stp,[1.5:PulseN-0.5],'linear')'-StpT,'.b-');

             pause;
             
             
% 
% 
%              start(t);
%              wait(t);
%              stop(t);
             subplot(2,1,1); hold off;      
             subplot(2,1,2); hold off;      

        if exist('Treks')
            assignin('base','Treks',Treks);
        end;
        if exist('tb')
            assignin('base','tb',tb)
        end;

    end;
end;