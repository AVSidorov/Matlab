function TrekSet=TrekGetPeaksSid(TrekSetIn,Pass);
TrekSet=TrekSetIn;
tic;
disp('>>>>>>>>Get Peaks started');

Nfit=10;

EndPlotBool=true;
PulsePlot=false;
FitPlot=false;

PulseN=size(TrekSet.StandardPulse,1);
MaxInd=find(TrekSet.StandardPulse==1); %Standard Pusle must be normalized by Amp
BckgFitInd=find(TrekSet.StandardPulse==0);%Standard Pulse must have several zero point at front end and las zero point
BckgFitInd(end)=[];
BckgFitN=size(BckgFitInd,1); 
FrontN=MaxInd-BckgFitN;
TailInd=find(TrekSet.StandardPulse<=0);
TailInd(TailInd<MaxInd)=[];
TailInd=TailInd(1);
NPeaksSubtr=0;


if nargin<2
    Pass=1;
end;

PeakN=size(TrekSet.SelectedPeakInd,1);  
trek=TrekSet.trek;
tau=TrekSet.tau;
peaks=zeros(PeakN,7);
peaksBad=[];
ShortFrontInd=[];


for i=-2:1/Nfit:2
    n=round((i+2)*Nfit)+1;
    PulseInterp(n,:)=interp1([1:PulseN],TrekSet.StandardPulse,[1:PulseN]+i,'spline',0);
end;
StpR=circshift(TrekSet.StandardPulse,1);
StpL=circshift(TrekSet.StandardPulse,-1);
MinCurve=[StpR(1:MaxInd-1);TrekSet.StandardPulse(MaxInd);StpL(MaxInd+1:end)]';
MaxCurve=[StpL(1:MaxInd-1);TrekSet.StandardPulse(MaxInd);StpR(MaxInd+1:end)]';



i=0;
while i<PeakN %
    DoubleFit=false;
    OscilFit=false;
    ExcelentFit=false;
    GoodFit=false;

%not just i=i+1 because can be jump if PeakOnFront and next pulse fitted in
%GetDoublePeaks
 if NPeaksSubtr>0    
    i=max([find(TrekSet.SelectedPeakInd(:)>peaks(NPeaksSubtr,1),1,'first'),i+1]);
 else
     i=1;
 end;
%%
    %if Peak marked by LongFront and not marked as PeakOnFront start
    %GetDoublePeaks right here
    if numel(find(TrekSet.SelectedPeakInd(i)==TrekSet.PeakOnFrontInd(:)))==0&numel(find(TrekSet.SelectedPeakInd(i)==TrekSet.LongFrontInd(:)))>0
        DoubleFit=true;
    end; 
    %after subtracting peak it can move
    if numel(find(TrekSet.SelectedPeakInd(i)==TrekSet.PeakOnFrontInd(:)))==0&numel(find(TrekSet.SelectedPeakInd(i)==TrekSet.PeakOnTailInd(:)))==0&numel(find(TrekSet.SelectedPeakInd(i)==TrekSet.LongFrontInd(:)))==0
            if trek(TrekSet.SelectedPeakInd(i))<trek(TrekSet.SelectedPeakInd(i)+1)
                TrekSet.SelectedPeakInd(i)=TrekSet.SelectedPeakInd(i)+1;
            end;
            if trek(TrekSet.SelectedPeakInd(i))<trek(TrekSet.SelectedPeakInd(i)-1)
                TrekSet.SelectedPeakInd(i)=TrekSet.SelectedPeakInd(i)-1;
            end;
    end;
    if trek(TrekSet.SelectedPeakInd(i))<TrekSet.Threshold; %after subtracting previous peak the next can be noise
        continue;
    end;


%% =========search points suitable for fitting

        %first step All indexes of points that correspond to all points of
        %StandardPulse
        FitInd=[1:PulseN]+TrekSet.SelectedPeakInd(i)-MaxInd;
        %reduce points out of bounds trek
        FitInd=FitInd(FitInd<=TrekSet.size&FitInd>=1);
        FitIndPulse=FitInd-TrekSet.SelectedPeakInd(i)+MaxInd; %make Indexes same size
        

        %Reduce points which overlaped to next pulse only after front
        if i<PeakN
            %BorderInd is index there next pulse can be over Threshold
            BorderInd=max([TrekSet.SelectedPeakInd(i+1)-MaxInd+find(trek(TrekSet.SelectedPeakInd(i+1))*TrekSet.StandardPulse>TrekSet.Threshold,1,'first'),...
                TrekSet.SelectedPeakInd(i+1)-(MaxInd-BckgFitN)]);
            
            FitInd=FitInd(FitInd<BorderInd|FitIndPulse<=MaxInd);
            FitIndPulse=FitInd-TrekSet.SelectedPeakInd(i)+MaxInd; %make Indexes same size
        end;


        %for overloaded pulse other fit function is necessary
        bool=trek(FitInd)<=TrekSet.MaxSignal;
        FitInd=FitInd(bool);
        FitIndPulse=FitInd-TrekSet.SelectedPeakInd(i)+MaxInd;
        

        % coarse fit for amp and backround
        %Is Nessesary for <short fit> Background calculates by prePulse
        %(noise) points. Not exact
        %A=trek(TrekSet.SelecetdPeakInd(i));
        %B=mean(trek(BckgFitInd-MaxInd+TrekSet.SelectedPeakInd(i)));
        
         ex=1;
         while ex>0
            p=polyfit(TrekSet.StandardPulse(FitIndPulse),trek(FitInd),1);
            A=p(1);
            B=p(2);
            %if B > Threshold, it can mean there are not signed Pukse on front

            bool=(MaxCurve(FitIndPulse)*A+B+TrekSet.Threshold-trek(FitInd)')>=0&...
                 (trek(FitInd)'-(MinCurve(FitIndPulse)*A+B-TrekSet.Threshold))>=0;
            % points from next pulse on tail can increase A&B so iterations are
            % necessary
            % but in iterations we reduce points only on tail
             if isempty(find(not(bool|FitIndPulse<=MaxInd))) 
                 ex=0; 
             else
            %  reduce points out of Min/MaxCurve corridor but not at front    
                 FitIndPulse=FitIndPulse(bool|FitIndPulse<=MaxInd);
                 FitInd=FitIndPulse+TrekSet.SelectedPeakInd(i)-MaxInd;
             end;
        end;
        %reduce points on tail which greater then max
        if numel(find(TrekSet.SelectedPeakInd(i)==TrekSet.PeakOnFrontInd(:)))==0
            FitInd((trek(FitInd)'>=trek(TrekSet.SelectedPeakInd(i)))&FitIndPulse>MaxInd)=[];
            FitIndPulse=FitInd-TrekSet.SelectedPeakInd(i)+MaxInd;
        end;
  
        if FitIndPulse(end)>MaxInd
            bool=(MaxCurve(FitIndPulse)*A+B+TrekSet.Threshold-trek(FitInd)')>=0&...
                     (trek(FitInd)'-(MinCurve(FitIndPulse)*A+B-TrekSet.Threshold))>=0;
        else
            bool=(MaxCurve(FitIndPulse)*trek(TrekSet.SelectedPeakInd(i))+B+TrekSet.Threshold-trek(FitInd)')>=0&...
                     (trek(FitInd)'-(MinCurve(FitIndPulse)*trek(TrekSet.SelectedPeakInd(i))+B-TrekSet.Threshold))>=0;
        end;
                 
        if numel(find(not(bool)&FitIndPulse<MaxInd&FitIndPulse>BckgFitN))>0
            DoubleFit=true;
        end;
        %if FitPulse is continious this array contains only 1
        dFitIndPulse=circshift(FitIndPulse',-1)-FitIndPulse'; 
        dFitIndPulse(end)=0;
        
  
        %if fit pulse points breaks in tail part we reduce FitPulse by
        %removing stand alone tail points
        
        FitIndPulseMax=FitIndPulse(dFitIndPulse>3); % very small breaks is not important
        FitIndPulseMax(FitIndPulseMax<TailInd)=[];  % we search breaks only on the tail
        if not(isempty(FitIndPulseMax))
            FitIndPulseMax=FitIndPulseMax(1);           % take the first break
            FitIndPulse(FitIndPulse>FitIndPulseMax)=[]; % remove from fitting all points after break
            FitInd=FitIndPulse+TrekSet.SelectedPeakInd(i)-MaxInd;
        end;
        N=size(FitIndPulse,2);
         

%% ============== fitting
                %<SHORT FIT>
                % Yi=trek(FitInd)-B;
                % Xi=PulseInterp(:,FitIndPulse);
                % A=(Xi*Yi)./(sum(Xi')'); 
                %works bad. Gives negative amplitude.Possibly
                % weight is nessesary
       if FitPlot 
           fp=figure; 
           subplot(2,1,1);
           grid on; hold on;
           plot(FitInd,trek(FitInd),'.b-');
           plot([1:PulseN]+TrekSet.SelectedPeakInd(i)-MaxInd,trek([1:PulseN]+TrekSet.SelectedPeakInd(i)-MaxInd),'b');
           axis([1+TrekSet.SelectedPeakInd(i)-MaxInd,TailInd+TrekSet.SelectedPeakInd(i)-MaxInd,min(trek([1:PulseN]+TrekSet.SelectedPeakInd(i)-MaxInd)),max(trek([1:PulseN]+TrekSet.SelectedPeakInd(i)-MaxInd))]);
           subplot(2,1,2);
           grid on; hold on;
       end;

      Yi=trek(FitInd);
%       if numel(find(TrekSet.SelectedPeakInd(i)==TrekSet.PeakOnFrontInd(:)))>0
%            Xi=PulseInterp(:,FitIndPulse);
%            FineInd=[-2:1/Nfit:2];
%           for ii=(4*Nfit+1):-1:1
%               p=polyfit(Xi(ii,:),Yi',1);
%               Khi(ii)=sum((Yi'-(p(1)*Xi(ii,:)+p(2))).^2)/N;
%                 if FitPlot
%                     figure(fp);
%                     subplot(2,1,1);
%                     plot(FitInd,p(1)*Xi(ii,:)+p(2),'om-');
%                     plot(FitInd,Yi'-(p(1)*Xi(ii,:)+p(2)),'g');
%                     subplot(2,1,2);
%                     plot(FineInd(ii),Khi(ii),'*r');
%                     pause;
%                 end;
%           end;
%           shTi=4*Nfit+1+1;
%       else
                % shT>0 means shift in time left. Conditions for shT are to Avoid fitting
                % by part of front. In this case we have good khi, but
                % after subtracting get the negative line, because maximum
                % of fit pulse much greater then trek pulse
                shT=1/2;
                KhiMinInd=1;
                while KhiMinInd<3&shT>=-1
                    Khi=[];
                    Khi(1:3)=inf;
                    shTi=1;
                    FineInd=[];
                    while (Khi(end)<=Khi(end-1)|Khi(end-1)<=Khi(end-2))&(shT>=-1)
                        FineInd(end+1)=shT;
                        FitPulse=interp1([1:PulseN],TrekSet.StandardPulse,[1:PulseN]+shT,'spline',0);

                        p=polyfit(FitPulse(FitIndPulse),Yi',1);
                        Khi(shTi)=sum((Yi'-(p(1)*FitPulse(FitIndPulse)+p(2))).^2)/N/trek(TrekSet.SelectedPeakInd(i));
                        if FitPlot
                            figure(fp);
                            subplot(2,1,1);
                            plot(FitInd,p(1)*FitPulse(FitIndPulse)+p(2),'om-');
                            plot(FitInd,trek(FitInd)'-(p(1)*FitPulse(FitIndPulse)+p(2)),'g');
                            subplot(2,1,2);
                            plot(-shT,Khi(shTi),'*r');
                            pause;
                        end;
                        shTi=shTi+1;
                        shT=shT-1/Nfit;                        
                    end;

                    [KhiMin,KhiMinInd]=min(Khi);
                    shT=FineInd(1)+2/Nfit;
                end;
%       end;
                shTi=shTi-1;
                [KhiMin,KhiMinInd]=min(Khi);
                StInd=max([1,KhiMinInd-2]);
                EndInd=min([shTi,KhiMinInd+2]);

                KhiFit=polyfit(FineInd(StInd:EndInd),Khi(StInd:EndInd),2);
                Shift=-KhiFit(2)/(2*KhiFit(1));

                PulseFine=interp1([1:PulseN],TrekSet.StandardPulse,[1:PulseN]+Shift,'spline',0);
                [p,Rstruct]=polyfit(PulseFine(FitIndPulse),Yi',1);
                MinKhi2=sum((Yi'-(p(1)*PulseFine(FitIndPulse)+p(2))).^2)/N/trek(TrekSet.SelectedPeakInd(i));
                if FitPlot
                    figure(fp);                  
                    subplot(2,1,2);
                    plot(-[FineInd(1):-1/Nfit/10:FineInd(end)],polyval(KhiFit,[FineInd(1):-1/Nfit/10:FineInd(end)]),'b');                   
                    plot([-Shift,-Shift],[0,MinKhi2],'sm-','linewidth',2);
                    pause;
                    figure(fp);                  
                    close(gcf);
                end;

%% ================= trek cleaning and data saving
                PulseSubtract=p(1)*PulseFine+p(2);

                        SubtractInd=[1:PulseN]+TrekSet.SelectedPeakInd(i)-MaxInd;
                        SubtractInd=SubtractInd(SubtractInd<=TrekSet.size&SubtractInd>=1);
                        SubtractIndPulse=SubtractInd-TrekSet.SelectedPeakInd(i)+MaxInd;
                        
                        %definite the region there trek essentialy change
                        DisturbIndPulse=find(PulseSubtract>TrekSet.Threshold);
                        DisturbInd=DisturbIndPulse+TrekSet.SelectedPeakInd(i)-MaxInd;
                        DisturbInd=DisturbInd(DisturbInd<=TrekSet.size&DisturbInd>=1);
                        DisturbIndPulse=DisturbInd-TrekSet.SelectedPeakInd(i)+MaxInd;



                        OverloadInd=SubtractInd(trek(SubtractInd)>TrekSet.MaxSignal);
                        OverloadIndPulse=OverloadInd-TrekSet.SelectedPeakInd(i)+MaxInd;
                        PulseSubtract(OverloadIndPulse)=trek(OverloadInd);
%%
                        if PulsePlot
                             pp=figure;
                             subplot(2,1,1);
                             grid on; hold on;
                             plot(SubtractInd,trek(SubtractInd));
                             plot(TrekSet.SelectedPeakInd(i),trek(TrekSet.SelectedPeakInd(i)),'*r');


                             plot(SubtractInd,PulseSubtract(SubtractIndPulse),'.m-');
                             plot(SubtractInd,trek(SubtractInd)-PulseSubtract(SubtractIndPulse)','g');
                             subplot(2,1,2);
                             grid on; hold on;
                             plot(-FineInd,Khi,'*r');
                             plot(-[FineInd(1):-1/Nfit/10:FineInd(end)],polyval(KhiFit,[FineInd(1):-1/Nfit/10:FineInd(end)]),'b');                   
                             plot([-Shift,-Shift],[0,MinKhi2],'sm-','linewidth',2);                            
                             pause;
                             figure(pp);
                             close(gcf);
                        end;
%%
                        if p(1)>TrekSet.Threshold&abs(p(2))<TrekSet.Threshold&...
                                (max(trek(FitInd)-PulseSubtract(FitIndPulse)')-min(trek(FitInd)-PulseSubtract(FitIndPulse)'))<=2*TrekSet.Threshold&...
                                min(trek(DisturbInd))>-TrekSet.Threshold
                            ExcelentFit=true;
                        else
                            if abs(mean(trek(FitInd)-PulseSubtract(FitIndPulse)'))<=TrekSet.Threshold
                                GoodFit=true;
                            end;
                            if abs(sum(trek(FitInd)-PulseSubtract(FitIndPulse)'))<=2*TrekSet.Threshold
                                OscilFit=true;
                            end;
                        end;

                        if not(ExcelentFit)
                            DoubleFit=true;
                        else
                            DoubleFit=false;
                        end;

%                        end;
                       
                 if ExcelentFit %&(p(1)+p(2)-trek(TrekSet.SelectedPeakInd(i)))<TrekSet.Threshold

                        trek(SubtractInd)=trek(SubtractInd)-PulseSubtract(SubtractIndPulse)'; 
                        NPeaksSubtr=NPeaksSubtr+1;

                        peaks(NPeaksSubtr,1)=TrekSet.SelectedPeakInd(i);             %TrekSet.SelectedPeakInd Max initial
                        peaks(NPeaksSubtr,2)=TrekSet.StartTime+TrekSet.SelectedPeakInd(i)*tau-Shift*tau;  %Peak Max Time fitted
                        peaks(NPeaksSubtr,3)=peaks(NPeaksSubtr,2);     % for peak-to-peak interval
                        peaks(NPeaksSubtr,4)=p(2);                        %Peak Zero Level
                        peaks(NPeaksSubtr,5)=p(1);                     %Peak Amplitude
                        peaks(NPeaksSubtr,6)=MinKhi2 ;%MinKhi2;% /Ampl;% KhiMin
                        peaks(NPeaksSubtr,7)=Pass;                     % number of Pass in which peak finded

                        if  (max(trek(DisturbInd))-min(trek(DisturbInd)))>2*TrekSet.Threshold
                            TrekSet1=TrekSet;
                            TrekSet1.Plot=false;
                            TrekSet1.trek=[TrekSet.StdVal;-TrekSet.StdVal;0;trek(SubtractInd(SubtractIndPulse>MaxInd))];
                            %first 3 points is necessary for making
                            %minimum before pulse 
                            TrekSet1.size=numel(TrekSet1.trek);
                            TrekSet1.SelectedPeakInd=[];
                            TrekSet1.PeakOnFrontInd=[];
                            TrekSet1.PeakOnTailInd=[];
                            TrekSet1.LongFrontInd=[];
                            TrekSet1.Threshold=2*TrekSet.Threshold;
                            TrekSet1=TrekPeakSearch(TrekSet1);
                            bool=TrekSet.SelectedPeakInd>=SubtractInd(MaxInd+1)&TrekSet.SelectedPeakInd<=SubtractInd(end);
                            if numel(TrekSet1.SelectedPeakInd)~=numel(find(TrekSet.SelectedPeakInd>=SubtractInd(MaxInd+1)&TrekSet.SelectedPeakInd<=SubtractInd(end)))

                                TrekSet1.SelectedPeakInd=TrekSet1.SelectedPeakInd-1+SubtractInd(MaxInd+1)-3;
                                TrekSet1.PeakOnFrontInd=TrekSet1.PeakOnFrontInd-1+SubtractInd(MaxInd+1)-3;
                                TrekSet1.PeakOnTailInd=TrekSet1.PeakOnTailInd-1+SubtractInd(MaxInd+1)-3;
                                TrekSet1.LongFrontInd=TrekSet1.LongFrontInd-1+SubtractInd(MaxInd+1)-3;

                                for IndI=1:numel(TrekSet1.SelectedPeakInd)
                                    if isempty(find(TrekSet1.SelectedPeakInd(IndI)==TrekSet.SelectedPeakInd(:)))
                                        TrekSet.SelectedPeakInd(end+1)=TrekSet1.SelectedPeakInd(IndI);
                                        TrekSet.SelectedPeakInd=sortrows(TrekSet.SelectedPeakInd);
                                    end;
                                end;

                                for IndI=1:numel(TrekSet1.PeakOnFrontInd)
                                    if isempty(find(TrekSet1.PeakOnFrontInd(IndI)==TrekSet.PeakOnFrontInd(:)))
                                        TrekSet.PeakOnFrontInd(end+1)=TrekSet1.PeakOnFrontInd(IndI);
                                        TrekSet.PeakOnFrontInd=sortrows(TrekSet.PeakOnFrontInd);
                                    end;
                                end;

                                for IndI=1:numel(TrekSet1.PeakOnTailInd)
                                    if isempty(find(TrekSet1.PeakOnTailInd(IndI)==TrekSet.PeakOnTailInd(:)))
                                        TrekSet.PeakOnTailInd(end+1)=TrekSet1.PeakOnTailInd(IndI);
                                        TrekSet.PeakOnTailInd=sortrows(TrekSet.PeakOnFrontInd);
                                    end;
                                end;

                                for IndI=1:numel(TrekSet1.LongFrontInd)
                                  if isempty(find(TrekSet1.LongFrontInd(IndI)==TrekSet.LongFrontInd(:)))
                                        TrekSet.LongFrontInd(end+1)=TrekSet1.LongFrontInd(IndI);
                                        TrekSet.LongFrontInd=sortrows(TrekSet.LongFrontInd);
                                    end;
                                end;


                            end;
                        end;

                 else
                         if p(2)>TrekSet.Threshold
                             DoubleFit=true;
                         end;

                end;

                
                if DoubleFit    
                    TrekSet1=TrekSet;
                    TrekSet1.trek=trek;
                    TrekSet1=TrekGetDoublePeaks(TrekSet1,i);
                    TrekSet.SelectedPeakInd=TrekSet1.SelectedPeakInd;
                    TrekSet.PeakOnFrontInd=TrekSet1.PeakOnFrontInd;
                    TrekSet.PeakOnTailInd=TrekSet1.PeakOnTailInd;
                    TrekSet.LongFrontInd=TrekSet1.LongFrontInd;
                    PeakN=size(TrekSet.SelectedPeakInd,1); 
                    trek=TrekSet1.trek;
                    NPeaksSubtr=NPeaksSubtr+2;
                    peaks([NPeaksSubtr-1,NPeaksSubtr],:)=TrekSet1.peaks;
                    peaks(end+1,:)=zeros(1,7);
                    continue;
                end;
                

               
%%
end;
disp(['=======Search Peak finished. Elapsed time is ', num2str(toc),' sec']);
%%


peaks(peaks(:,5)<TrekSet.Threshold|peaks(:,2)<TrekSet.StartTime,:)=[];
PeakN=NPeaksSubtr;
if PeakN>1
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
 if PeakN>1
  
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
          plot(peaks(peaks(:,6)>1,1),trek(peaks(peaks(:,6)>1,1)),'dm');
%           legend('trek','Amplitude+Zero','Zero','Selected Peak Ind','HighPedestal','Ampl>MaxSignal','Ampl<Threshold','trekMinus');
%            legend('trek','Amplitude+Zero','Zero','Selected Peak Ind','HighPedestal','Ampl>MaxSignal','trekMinus');
            legend('trek','Amplitude+Zero','Zero','Selected Peak Ind','trekMinus');

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
