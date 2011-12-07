function OverlapedPulsesTest;

 t=timer('StartDelay',0.01,'TimerFcn',';');

TrekSet.FileType='single';      %choose file type for precision in fread function 
TrekSet.tau=0.02;               %ADC period
TrekSet.StartOffset=0;       %in us old system was Tokamak delay + 1.6ms
TrekSet.OverSt=3;               %uses in StdVal
TrekSet.StandardPulseFile='D:\!SCN\EField\StandPeakAnalys\StPeakAmp4_20ns_3.dat';
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
TrekSet.trek=[];
TrekSet.PeakOnFrontInd=[];
TrekSet.LongFrontInd=[];
TrekSet.PeakOnTailInd=[];
TrekSet.SelectedPeakInd=[];
TrekSet.SelectedPeakFrontN=[];
TrekSet.BreakPointsInd=[];

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
TrekSet.size=2*PulseN;

%emulating noise Amp4 Thr~50 StdVal~10
trek=-17+2*17*rand(2*PulseN,1);
TrekSet.StdVal=std(trek);
TrekSet.MeanVal=0;
TrekSet.Threshold=max([(max(trek)-min(trek)),50]);

StpR=circshift(TrekSet.StandardPulse,1);
StpL=circshift(TrekSet.StandardPulse,-1);
MinCurve=[StpR(1:MaxInd-1);TrekSet.StandardPulse(MaxInd);StpL(MaxInd+1:end)]';
MaxCurve=[StpL(1:MaxInd-1);TrekSet.StandardPulse(MaxInd);StpR(MaxInd+1:end)]';


ShiftInTrek=100; %Number of points for shifting pulse in trek

% sh=[0:0.2:FrontN+TailInd];
% sh=linspace(0.5,10,21);
sh=[0.5:0.1:9];
%ratio of peak Amplitudes max counts is 4095/2.5(ADC range in V)* 
%*2(Amplifier  max Amplitude in V)/20 (Threshold at Amp 3) ~=100
%  rat=[0.03,0.04,0.05,0.65,0.08,0.1,0.125,0.15,0.2,0.25,0.33,0.5,0.66,0.75,1,1.5,2,3,4,5,7.5,10,15,20,25,30,40];
rat=logspace(-1,1,21);
tb=zeros(1,13);
tb(1:11)=[0,0,1,MaxInd,1,MaxInd,1,MaxInd,1,FrontN,TailInd-BckgFitN];
% for i=1:5
%     f(i)=figure;
%     grid on; hold on;
%     title([' Front length is ',num2str(3+i),' points']);
% end;

for ri=1:numel(rat);
    for shi=1:numel(sh);
        PulseShifted=rat(ri)*interp1([1:PulseN],TrekSet.StandardPulse,[1:PulseN]-(sh(shi)-fix(sh(shi))),'spline',0)';
        PulseShifted(1:BckgFitN)=0;
        PulseShifted(find(PulseShifted(1:MaxInd)<0))=0;
        PulseShifted(end)=0;
        Stp=zeros(PulseN+fix(sh(shi)),1);
        Stp(1:PulseN)=TrekSet.StandardPulse;
        Stp([1:PulseN]+fix(sh(shi)))=Stp([1:PulseN]+fix(sh(shi)))+PulseShifted;
        StpR=circshift(Stp,1);
        StpL=circshift(Stp,-1);
        maxI=find(Stp>StpR&Stp>StpL);
        maxI(maxI>=MaxInd+sh(shi)+2)=[];
        maxN=numel(maxI);

%         plot(Stp);
%         grid on; hold on;
%         axis([1,TailInd,min(Stp),max(Stp)]);
%         plot(TrekSet.StandardPulse,'r');
%         plot([1:PulseN]+fix(sh(shi)),PulseShifted,'k');
%           start(t);
%           wait(t);
%           stop(t);
% %          pause;
%          hold off;   

        [StpMax,StpMaxI]=max(Stp);
        frontN=maxI(1)-BckgFitN;
        tailInd=find(Stp<=0);
        tailInd(tailInd<maxI(1))=[];
        tailInd=tailInd(1);
       Amp=[abs(TrekSet.MaxSignal/StpMax-1.2*(TrekSet.Threshold+17)/min(1,rat(ri)))/2];

%          Amp=[1.2*(TrekSet.Threshold+17)/min(1,rat(ri)):abs(TrekSet.MaxSignal/StpMax-1.2*(TrekSet.Threshold+17)/min(1,rat(ri)))/5:3270/StpMax];
%1.2 is neccesary for sure overhead Threshold
          for ami=1:numel(Amp)
             
                 tb(end+1,1)=rat(ri);
                 tb(end,2)=sh(shi);
                 tb(end,3)=StpMax;
                 tb(end,4)=StpMaxI;
                 tb(end,5)=maxN;
                 tb(end,6)=maxI(1);
                 tb(end,7)=Stp(maxI(1));                 
                 tb(end,8)=maxI(end);
                 tb(end,9)=Stp(maxI(end));                 
                 tb(end,10)=frontN;
                 tb(end,11)=tailInd-BckgFitN;
%                  if maxN==1
%                      figure(f(maxI(1)-6));
%                      plot([1:PulseN]+StpMaxI-MaxInd,Stp./StpMax);
%                  end;

                  tb(end,12)=Amp(ami);
                  tb(end,13)=Amp(ami)*rat(ri);
 
                  
                     %for every case new noise
                     TrekSet.trek=(-17+2*17*rand(2*PulseN,1));
                     TrekSet.StdVal=std(TrekSet.trek);
                     TrekSet.MeanVal=0;
                     TrekSet.Threshold=max([(max(TrekSet.trek)-min(TrekSet.trek)),50]);
                     
                     
                    
                     
                    TrekSet.trek(ShiftInTrek+1:ShiftInTrek+PulseN+fix(sh(shi)))=Amp(ami)*Stp+TrekSet.trek(ShiftInTrek+1:ShiftInTrek+PulseN+fix(sh(shi)));
                    TrekSet.peaks=[];
%                     TrekSet=TrekPeakSearch(TrekSet);

                    
%                     TrekSet.Threshold=TrekSet.Threshold/2;
%                     tb(end,14)=maxI(1)-find(Amp(ami)*Stp>=TrekSet.Threshold,1,'first'); %Front length above noise in clear pulse 
                                                                                        %Here beacause Threshold is changed in PeakSearch
                     
%                     FitInd=ShiftInTrek+1:ShiftInTrek+PulseN;
%                     FitIndPulse=[1:PulseN];
 
%                       ex=1;
%                       while ex>0
%                          A=sum(TrekSet.StandardPulse(FitIndPulse).*TrekSet.trek(FitInd))/sum(TrekSet.StandardPulse(FitIndPulse).^2);
%                          B=0;
%  
%                          bool=(MaxCurve(FitIndPulse)*A+B+TrekSet.Threshold-TrekSet.trek(FitInd)')>=0&...
%                               (TrekSet.trek(FitInd)'-(MinCurve(FitIndPulse)*A+B-TrekSet.Threshold))>=0;
%                          % points from next pulse on tail can increase A&B so iterations are
%                          % necessary
%                          % but in iterations we reduce points only on tail
%                           if not(isempty(find(not(bool),1,'first')))
%                              tb(end,15)=find(not(bool),1,'first');
%                           else
%                               tb(end,15)=0;
%                           end;
%                           if isempty(find(not(bool|FitIndPulse<=MaxInd))) 
%                               ex=0; 
%                           else
%                          %  reduce points out of Min/MaxCurve corridor but not at front    
%                               FitIndPulse=FitIndPulse(bool|FitIndPulse<=MaxInd);
%                               FitInd=FitIndPulse+ShiftInTrek;
%                           end;
%                      end;


                    


                                                                                       
%                     TrekSet=TrekBreakPoints(TrekSet);
%                     if not(isempty(find(abs(TrekSet.SelectedPeakInd-ShiftInTrek-maxI(1))<=1)))
%                        Ind=find(abs(TrekSet.SelectedPeakInd-ShiftInTrek-maxI(1))<=1); %is neccessary if founded more one ind
%                        Ind=round(mean(Ind));
%                        tb(end,15)=TrekSet.SelectedPeakInd(Ind)-ShiftInTrek;
%                        tb(end,16)=TrekSet.SelectedPeakFrontN(Ind);
%                        tb(end,17)=TrekSet.SelectedPeakInd(Ind)-find(TrekSet.trek(1:TrekSet.SelectedPeakInd(Ind))<TrekSet.Threshold,1,'last')-1;%Front length above noise in trek
%                    else
%                        tb(end,15)=0;                      
%                    end;
%                    if not(isempty(find(abs(TrekSet.SelectedPeakInd-ShiftInTrek-maxI(end))<=1)))
%                        Ind=find(abs(TrekSet.SelectedPeakInd-ShiftInTrek-maxI(end))<=1); %is neccessary if founded more one ind
%                        Ind=round(mean(Ind));
%                        tb(end,18)=TrekSet.SelectedPeakInd(Ind)-ShiftInTrek;
%                    else
%                        tb(end,18)=0;
%                    end;

%                    if maxN==2;
                       TrekSet=TrekPeakSearch(TrekSet);
                       TrekSet=TrekBreakPoints(TrekSet);
                       TrekSet=TrekGetPeaksSid(TrekSet);
                       TrekSet.Threshold=TrekSet.Threshold*2;
%                    end;
%                       if numel(find(TrekSet.peaks(:,7)==1))<maxN
%                         TrekSet.Plot=true;
%                         TrekSet=TrekGetPeaksSid(TrekSet);                
%                         TrekSet.Plot=false;                       
%                     end;
      
                                    
%                      TrekSet.Threshold=TrekSet.Threshold*2;
                     Treks(1)=TrekSet;
                     Treks(end+1)=TrekSet;
                
               


%             trek=[trek;Amp(ami)*Stp+TrekSet.trek];

%             plot(Amp(ami)*Stp+TrekSet.trek,'m');
%             grid on; hold on;
%             plot(Amp(ami)*Stp,'r');
%             plot(Amp(ami)*TrekSet.StandardPulse,'b');
%             plot(Amp(ami)*rat(ri)*interp1([1:PulseN],TrekSet.StandardPulse,[1:PulseN]-sh(shi),'spline',0)','k');
%             axis([0,TailInd,min(Amp(ami)*Stp+TrekSet.trek),max(Amp(ami)*Stp+TrekSet.trek)]);
% %             pause;
% 
% 
%              start(t);
%              wait(t);
%              stop(t);
%             hold off;      
         end;
         if exist('Treks')
             assignin('base','Treks',Treks);
         end;
        if exist('tb')
            assignin('base','tb',tb)
        end;

    end;
end;