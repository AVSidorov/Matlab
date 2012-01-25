function TrekSet=TrekGetPeaksSid(TrekSetIn,Pass);

tic;
disp('>>>>>>>>Get Peaks started');

TrekSet=TrekSetIn;
EndPlotBool=TrekSet.Plot;




%%
STP=StpStruct(TrekSet.StandardPulse);

if nargin<2
    Pass=1;
end;

PeakN=numel(TrekSet.SelectedPeakInd);  

tau=TrekSet.tau;
%peaks=zeros(PeakN,7); %if works bad because may be hidden peaks



%%


i=1; %always one so as search peak markers after every subtracting
%%
while i<=PeakN %
     

     FIT=TrekFitTime(TrekSet,i,STP);                         
        
     
     [TrekSet,ExcelentFit]=TrekSubtract(TrekSet,i,STP,FIT);
%%     
     if Pass==1&not(ExcelentFit)
        BreakPointInd=find(TrekSet.BreakPointsInd>TrekSet.SelectedPeakInd(i),1,'first');
        if not(isempty(BreakPointInd))
            i=find(TrekSet.SelectedPeakInd>TrekSet.BreakPointsInd(BreakPointInd),1,'first');
            if isempty(i)
                i=PeakN+1;
                continue;
            end;
        else
            i=PeakN+1;
            continue;
        end;
        continue;    
     end;
%%
     if Pass==2&not(ExcelentFit)
         if not(isempty(find(TrekSet.SelectedPeakInd(i)==TrekSet.PeakOnFrontInd)))|...
                    not(isempty(find(TrekSet.SelectedPeakInd(i)==TrekSet.LongFrontInd)))
                i=i+1;
                continue;
         else
           FIT=TrekFitTail(TrekSet,i,STP);           
           if FIT.Good
               TrekSet.Plot=true;
               [TrekSet,ExcelentFit]=TrekSubtract(TrekSet,i,STP,FIT);
               if ExcelentFit
                   i=find(TrekSet.SelectedPeakInd>TrekSet.peaks(end,1),1,'first');
               else
                   TrekSet=TrekSubtractInFit(TrekSet,i,STP,FIT);
                   i=find(TrekSet.SelectedPeakInd>TrekSet.peaks(end,1),1,'first');
               end;
               TrekSet.Plot=TrekSetIn.Plot;
           else
           BreakPointInd=find(TrekSet.BreakPointsInd>TrekSet.SelectedPeakInd(i),1,'first');
            if not(isempty(BreakPointInd))
                i=find(TrekSet.SelectedPeakInd>TrekSet.BreakPointsInd(BreakPointInd),1,'first');
                if isempty(i)
                    i=PeakN+1;                 
                    continue;
                end;
            else
                i=PeakN+1;
                continue;
            end;

           end;
         end;
     end;

      R=[];
      S=[];
  
  
%        while not(ExcelentFit)
% %             [FIT,R,S]=TrekGetDoublePeaksSid(TrekSet,i,FIT);
% %             if FIT.Good
% %                 STPC=StpCombined(STP,R,S);
% %                 [TrekSet,ExcelentFit]=TrekSubtract(TrekSet,i,STPC,FIT);                
% %             else
%                 if not(isempty(find(TrekSet.SelectedPeakInd(i)==TrekSet.PeakOnFrontInd)))|...
%                    not(isempty(find(TrekSet.SelectedPeakInd(i)==TrekSet.LongFrontInd)))
%                    i=i+1; 
%                 end;
% %             end;
%        end;    
            

%% Отправить в двойной фитинг
        
%         if not(isempty(R))
%             NPeaksSubtr=NPeaksSubtr+1;
%             peaks=[peaks;zeros(1,7)];
% 
%             peaks(NPeaksSubtr,1)=TrekSet.SelectedPeakInd(i);             %TrekSet.SelectedPeakInd Max initial
%             peaks(NPeaksSubtr,2)=TrekSet.StartTime+TrekSet.SelectedPeakInd(i)*tau-FIT.Shift*tau+S*tau;  %second peak Always after first
%             peaks(NPeaksSubtr,3)=peaks(NPeaksSubtr,2);     % for peak-to-peak interval
%             peaks(NPeaksSubtr,4)=FIT.B;                        %Peak Zero Level
%             peaks(NPeaksSubtr,5)=FIT.A*R;                     %Peak Amplitude
%             peaks(NPeaksSubtr,6)=FIT.Khi ;%MinKhi2;% /Ampl;% KhiMin
%             peaks(NPeaksSubtr,7)=Pass;                     % number of Pass in which peak finded
%         end;
%%        
        PeakN=numel(TrekSet.SelectedPeakInd);
        
%%
end; %while i<=PeakN 


disp(['=======Search Peak finished. Elapsed time is ', num2str(toc),' sec']);
%%

% evalin('base','clear peaks;');

TrekSet.peaks((TrekSet.peaks(:,5)<TrekSet.Threshold|TrekSet.peaks(:,2)<TrekSet.StartTime)&TrekSet.peaks(:,7)>0,:)=[];
PeakN=numel(TrekSet.peaks(:,1));
if PeakN>0
  TrekSet.peaks=sortrows(TrekSet.peaks,2); 
  TrekSet.peaks(2:end,3)=diff(TrekSet.peaks(:,3)); TrekSet.peaks(1,3)=0; 
 
  TrekSet.peaks=[TrekSetIn.peaks;TrekSet.peaks];
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
          plot(TrekSet.peaks(:,5),TrekSet.peaks(:,6),'r.');
          xlabel('Peak Amplitude');  ylabel('Chi^2');
  
  
     TrekFg=figure; 
          plot(TrekSetIn.trek); 
          hold on; grid on;
          title([TrekSet.name,':  tracks. Pass=', num2str(Pass)]);
          plot((TrekSet.peaks(:,2)-TrekSet.StartTime)/tau,TrekSet.peaks(:,4)+TrekSet.peaks(:,5),'r^');
          plot((TrekSet.peaks(:,2)-TrekSet.StartTime)/tau,TrekSet.peaks(:,4),'g>');
          plot(TrekSetIn.SelectedPeakInd,TrekSetIn.trek(TrekSetIn.SelectedPeakInd),'.r');
%           plot(HighPedestalInd,trek(HighPedestalInd),'dm');
%           plot(HighAmpInd,trek(HighAmpInd),'*r');
%           plot(LowAmpInd,trek(LowAmpInd),'.k');          
          plot(TrekSet.trek,'k'); 
          plot(TrekSetIn.BreakPointsInd,TrekSetIn.trek(TrekSetIn.BreakPointsInd),'*r');
          plot(TrekSet.peaks(TrekSet.peaks(:,6)>1,1),TrekSet.trek(TrekSet.peaks(TrekSet.peaks(:,6)>1,1)),'dm');
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


disp('>>>>>>>>Get Peaks finished');
