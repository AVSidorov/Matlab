function TrekSet=TrekGetPeaksSid(TrekSetIn,Pass);
TrekSet=TrekSetIn;
tic;
disp('>>>>>>>>Get Peaks started');

Nfit=10;
FitFast=true; %if fit Fast Peak Zero Level is assumed 0.

EndPlotBool=TrekSet.Plot;
PulsePlot=false;
FitPlot=false;
%
NPeaksSubtr=0;
%
%%
STP=StpStruct(TrekSet.StandardPulse);

if nargin<2
    Pass=1;
end;

PeakN=numel(TrekSet.SelectedPeakInd);  
trek=TrekSet.trek;
tau=TrekSet.tau;
%peaks=zeros(PeakN,7); %if works bad because may be hidden peaks
peaks=[];


%%

i=1; %always one so as search peak markers after every subtracting
while i<PeakN %


     FIT=TrekFitTime(TrekSet,i,STP);                         

     
     [TrekSet,ExcelentFit]=TrekSubtract(TrekSet,i,STP,FIT);

       R=[];
       S=[];
       
       while not(ExcelentFit)
            [FIT,R,S]=TrekGetDoublePeaksSid(TrekSet,i);
            STPC=StpCombined(STP,R,S);
            [TrekSet,ExcelentFit]=TrekSubtract(TrekSet,i,STPC,FIT);
       end;    
            

        NPeaksSubtr=NPeaksSubtr+1;
        peaks=[peaks;zeros(1,7)];

        peaks(NPeaksSubtr,1)=TrekSet.SelectedPeakInd(i);             %TrekSet.SelectedPeakInd Max initial
        peaks(NPeaksSubtr,2)=TrekSet.StartTime+TrekSet.SelectedPeakInd(i)*tau-FIT.Shift*tau;  %Peak Max Time fitted
        peaks(NPeaksSubtr,3)=peaks(NPeaksSubtr,2);     % for peak-to-peak interval
        peaks(NPeaksSubtr,4)=FIT.B;                       %Peak Zero Level
        peaks(NPeaksSubtr,5)=FIT.A;                     %Peak Amplitude
        peaks(NPeaksSubtr,6)=FIT.Khi ;%MinKhi2;% /Ampl;% KhiMin
        peaks(NPeaksSubtr,7)=Pass;                     % number of Pass in which peak finded
        
        if not(isempty(R))
            NPeaksSubtr=NPeaksSubtr+1;
            peaks=[peaks;zeros(1,7)];

            peaks(NPeaksSubtr,1)=TrekSet.SelectedPeakInd(i);             %TrekSet.SelectedPeakInd Max initial
            peaks(NPeaksSubtr,2)=TrekSet.StartTime+TrekSet.SelectedPeakInd(i)*tau-FIT.Shift*tau+S*tau;  %second peak Always after first
            peaks(NPeaksSubtr,3)=peaks(NPeaksSubtr,2);     % for peak-to-peak interval
            peaks(NPeaksSubtr,4)=FIT.B;                        %Peak Zero Level
            peaks(NPeaksSubtr,5)=FIT.A*R;                     %Peak Amplitude
            peaks(NPeaksSubtr,6)=FIT.Khi ;%MinKhi2;% /Ampl;% KhiMin
            peaks(NPeaksSubtr,7)=Pass;                     % number of Pass in which peak finded
        end;
%%
        TrekSet.Threshold=TrekSet.Threshold*2;
        TrekSet=TrekPeakSearch(TrekSet,false);
                
%%
end;
disp(['=======Search Peak finished. Elapsed time is ', num2str(toc),' sec']);
%%

evalin('base','clear peaks;');

peaks((peaks(:,5)<TrekSet.Threshold|peaks(:,2)<TrekSet.StartTime)&peaks(:,7)>0,:)=[];
PeakN=NPeaksSubtr;
if PeakN>0
  peaks=sortrows(peaks,2); 
  peaks(2:end,3)=diff(peaks(:,3)); peaks(1,3)=0; 
 
  TrekSet.peaks=[TrekSet.peaks;peaks];
  TrekSet.peaks=sortrows(TrekSet.peaks,2); 
end; 
  


fprintf('=====  Found pulses      ==========\n');
fprintf('The number of measured points  = %7.0f during %7.0f us \n',TrekSet.size,TrekSet.size*tau);
fprintf('The total number of peaks = %7.0f \n',PeakN);


fprintf('Last threshold = %7.0f \n',TrekSet.Threshold);

%%
if EndPlotBool  
 if PeakN>0
  
    figure; hold on; 
        title([TrekSet.name,': Chi^2 versus peak amplitude. Pass=', num2str(Pass)]);
          plot(peaks(:,5),peaks(:,6),'r.');
          xlabel('Peak Amplitude');  ylabel('Chi^2');
  
  
     TrekFg=figure; 
          plot(TrekSet.trek); 
          hold on; grid on;
          title([TrekSet.name,':  tracks. Pass=', num2str(Pass)]);
          plot((peaks(:,2)-TrekSet.StartTime)/tau,peaks(:,4)+peaks(:,5),'r^');
          plot((peaks(:,2)-TrekSet.StartTime)/tau,peaks(:,4),'g>');
          plot(TrekSet.SelectedPeakInd,TrekSet.trek(TrekSet.SelectedPeakInd),'.r');
%           plot(HighPedestalInd,trek(HighPedestalInd),'dm');
%           plot(HighAmpInd,trek(HighAmpInd),'*r');
%           plot(LowAmpInd,trek(LowAmpInd),'.k');          
          plot(trek,'k'); 
          plot(TrekSet.BreakPointsInd,TrekSet.trek(TrekSet.BreakPointsInd),'*r');
          plot(peaks(peaks(:,6)>1,1),trek(peaks(peaks(:,6)>1,1)),'dm');
%           legend('trek','Amplitude+Zero','Zero','Selected Peak Ind','HighPedestal','Ampl>MaxSignal','Ampl<Threshold','trekMinus');
%            legend('trek','Amplitude+Zero','Zero','Selected Peak Ind','HighPedestal','Ampl>MaxSignal','trekMinus');
            legend('trek','Amplitude+Zero','Zero','Selected Peak Ind','trekMinus','Break Points');

%           dt=[];
%           for i=1:NPeaksSubtr
%             FitIdx=peaks(i,1)+PulseInterpFine(1:FineInterpN:end,1);
%             dtau=peaks(i,2)-TrekSet.StartTime-peaks(i,1)*tau;
%             FineShift=round(dtau/tau*FineInterpN);
%             PulseInterpFineShifted=circshift(PulseInterpFine(:,2),FineShift);
% 
%             mark='.';    
%             point=['k',mark];
% 
%             if dtau<-tau; point=['b',mark]; end;
%             if dtau>tau; point=['r',mark]; end;
% 
%             plot(FitIdx,peaks(i,5)*PulseInterpFineShifted(1:FineInterpN:end)+peaks(i,4),point);
%           end; 
%             plot(trekMinus,'y'); 


 
    CloseGraphs;

 end;
end;
%%
TrekSet.trek=trek;

disp('>>>>>>>>Get Peaks finished');
