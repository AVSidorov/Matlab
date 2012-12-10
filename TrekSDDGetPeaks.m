function TrekSet=TrekSDDGetPeaks(TrekSetIn,Pass)

tic;
disp('>>>>>>>>Get Peaks started');

TrekSet=TrekSetIn;
EndPlotBool=TrekSet.Plot;



t=0:1/5000:0.5;
B=500*t.^2.*exp(-t/0.05).*sin(2*pi*1000*t);
%%
STP=TrekSet.STP;   

if nargin<2
    Pass=1;
end;

PeakN=numel(TrekSet.SelectedPeakInd);  

tau=TrekSet.tau;
%peaks=zeros(PeakN,7); %if works bad because may be hidden peaks



%%


i=1; %always one so as search peak markers after every subtracting
Ind=0;
%%
while i<=PeakN %

%      TrekSet.Plot=true;
     if Ind>=TrekSet.SelectedPeakInd(i)
         i=i+1;
         continue;
     end;
     Ind=TrekSet.SelectedPeakInd(i);   
     FIT=TrekFitTime(TrekSet,TrekSet.SelectedPeakInd(i));
     
     
     [TrekSet,ExcelentFit,TrekSet1]=TrekSubtract(TrekSet,FIT);
     TrekSet1=TrekPeakReSearch(TrekSet1,FIT);
     TrekSet1=TrekBreakPoints(TrekSet1);
     PeakN=numel(TrekSet.SelectedPeakInd);

%      ExFit=not(any(TrekSet1.SelectedPeakInd>FIT.MaxInd-STP.FrontN&TrekSet1.SelectedPeakInd<=FIT.MaxInd));
%      if xor(ExcelentFit,ExFit)&&FIT.Khi<1&&FIT.A>TrekSet.Threshold %&Pass>1
%          [TrekSet,ExcelentFit]=TrekSubtractManual(TrekSet,TrekSet1,FIT,STP);
%      end;
       if ~ExcelentFit
           sound(B,5000);
           [TrekSet,ExcelentFit]=TrekSubtractManual(TrekSet,TrekSet1,FIT,STP);
       end;
     TrekSet=TrekSDDPeakReSearch(TrekSet,FIT);
     TrekSet=TrekBreakPoints(TrekSet);
     PeakN=numel(TrekSet.SelectedPeakInd);
     assignin('base','TrekSet',TrekSet);

     %i don't changes because in TrekPeakResearche current marker in case of good
     %subtraction would be deleted and next marker becomes first.
%%     
    if not(ExcelentFit)  
      
        if Pass==1
            BreakPointInd=find(TrekSet.BreakPointsInd>TrekSet.SelectedPeakInd(i),1,'first');
            if not(isempty(BreakPointInd))
                i=find(TrekSet.SelectedPeakInd>TrekSet.BreakPointsInd(BreakPointInd),1,'first');
                if isempty(i)
                    i=PeakN+1;
                end;
            else
                i=PeakN+1;
            end;              
         end;
        if Pass>=3
             if not(isempty(find(TrekSet.SelectedPeakInd(i)==TrekSet.PeakOnFrontInd)))|...
                not(isempty(find(TrekSet.SelectedPeakInd(i)==TrekSet.LongFrontInd)))
                    i=i+1;
             else
                    [TrekSet,ExcelentFit,TrekSet1,FIT,STPC]=TrekFitDouble(TrekSet,TrekSet.SelectedPeakInd(i),STP);
%                    if FIT.Khi<1
                        TrekSet=TrekSet1;
%                    end;

                   TrekSet=TrekPeakReSearch(TrekSet,STPC,FIT);
                   TrekSet=TrekBreakPoints(TrekSet,STP);
                   PeakN=numel(TrekSet.SelectedPeakInd);
                   if not(ExcelentFit)
                    BreakPointInd=find(TrekSet.BreakPointsInd>TrekSet.SelectedPeakInd(i),1,'first');
                    if not(isempty(BreakPointInd))
                        i=find(TrekSet.SelectedPeakInd>TrekSet.BreakPointsInd(BreakPointInd),1,'first');
                        if isempty(i)
                            i=PeakN+1;
                        end;
                    else
                      i=PeakN+1;  
                    end;
                   end;                  
             end;
        end;
    end;
%%
%       R=[];
%       S=[]; 
  
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
            


%%
end; %while i<=PeakN 


disp(['=======Search Peak finished. Elapsed time is ', num2str(toc),' sec']);
%%

% evalin('base','clear peaks;');

% TrekSet.peaks((TrekSet.peaks(:,5)<TrekSet.Threshold|TrekSet.peaks(:,2)<TrekSet.StartTime):)=[];
PeakN=numel(TrekSet.peaks(:,1));
if PeakN>0
  TrekSet.peaks=sortrows(TrekSet.peaks,2); 
  TrekSet.peaks(2:end,3)=diff(TrekSet.peaks(:,2)); TrekSet.peaks(1,3)=0;
  TrekSet.peaks(TrekSet.peaks(:,7)==0,7)=Pass;
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
