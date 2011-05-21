function [TrekSet,MinKhi]=TrekGetDoublePeaks(TrekSetIn,I);
TrekSet=TrekSetIn;

tic;
disp('>>>>>>>>Get Double Peaks started');

fprintf('Initial Ind - Time is %4d - %5.3fus\n',TrekSet.SelectedPeakInd(I),TrekSet.StartTime+TrekSet.SelectedPeakInd(I)*TrekSet.tau);

Nfit=7;
FitPassN=2;

EndPlot=false;
PulsePlot=false;
FitPlot=false;


PulseN=size(TrekSet.StandardPulse,1);
MaxInd=find(TrekSet.StandardPulse==1); %Standard Pulse must be normalized by Amp
BckgFitInd=find(TrekSet.StandardPulse==0);%Standard Pulse must have several zero point at front end and las zero point
BckgFitInd(end)=[];
BckgFitN=size(BckgFitInd,1); 
TailInd=find(TrekSet.StandardPulse<=0);
TailInd(TailInd<MaxInd)=[];
TailInd=TailInd(1);

if nargin<2
return;
end;

sh=[1/Nfit:((MaxInd-BckgFitN)-1/Nfit)/Nfit:(MaxInd-BckgFitN)];
shN=numel(sh);

am=[[1/Nfit:1/Nfit:1],1./[1-1/Nfit:-1/Nfit:1/Nfit]];
amN=numel(am);

trek=TrekSet.trek;
PeakN=size(TrekSet.SelectedPeakInd,1); 
peaks=[];
FitPass=0;
goodfit=[];
MinKhiOld=inf;
dI=0;
%dI is Need to bind peak of double pulse to next Selected Pulse
 if numel(find(TrekSet.SelectedPeakInd(I)==TrekSet.PeakOnFrontInd(:)))>0
     if(TrekSet.SelectedPeakInd(I+1)-TrekSet.SelectedPeakInd(I))<=(MaxInd-BckgFitN)
 %      if isempty(find(TrekSet.SelectedPeakInd(I+1)==TrekSet.PeakOnFrontInd(:)))
          dI=1;
          sh=[TrekSet.SelectedPeakInd(I+1)-TrekSet.SelectedPeakInd(I)-2:4/Nfit:TrekSet.SelectedPeakInd(I+1)-TrekSet.SelectedPeakInd(I)+2];
          shN=numel(sh);
          B1=mean(trek(TrekSet.SelectedPeakInd(I)-MaxInd+BckgFitInd));
          A1=trek(TrekSet.SelectedPeakInd(I))-B1;         
          B2=A1*TrekSet.StandardPulse(MaxInd+(TrekSet.SelectedPeakInd(I+1)-TrekSet.SelectedPeakInd(I)))+B1;
          A2=trek(TrekSet.SelectedPeakInd(I+1))-B2;
          amMin=1+(A2/A1-1)/2;
          amMax=A2/A1+(A2/A1-1)/2;
          am=[amMin:(amMax-amMin)/Nfit:amMax];
          amN=numel(am);
 %      end;
     end;
 end;
 if numel(find(TrekSet.SelectedPeakInd(I)==TrekSet.LongFrontInd(:)))>0
    dI=1;

    sh=[TrekSet.SelectedPeakInd(I+1)-TrekSet.SelectedPeakInd(I)-2:4/Nfit:TrekSet.SelectedPeakInd(I+1)-TrekSet.SelectedPeakInd(I)+2];
    shN=numel(sh);

    B1=mean(trek(TrekSet.SelectedPeakInd(I)-MaxInd+BckgFitInd));
    A1=trek(TrekSet.SelectedPeakInd(I))-B1;         
    B2=A1*TrekSet.StandardPulse(MaxInd+(TrekSet.SelectedPeakInd(I+1)-TrekSet.SelectedPeakInd(I)))+B1;
    A2=trek(TrekSet.SelectedPeakInd(I+1))-B2;
    amMin=1+(A2/A1-1)/2;
    amMax=A2/A1+(A2/A1-1)/2;
    am=[amMin:(amMax-amMin)/Nfit:amMax];
    amN=numel(am);
 end;

%%
while isempty(peaks)|FitPass<FitPassN; %second condition to avoid too coarse fit

OscilFit=false;
ExcelentFit=false;
GoodFit=false;

FitPass=FitPass+1;    
MinKhi=inf;
pAm=[];
pSh=[];
pAmi=[];
pShi=[];
mShift=[];
MinKhi2=[];
N=[];
for shi=1:shN
  for ami=1:amN
       
%%
        Stp=(TrekSet.StandardPulse+am(ami)*interp1([1:PulseN],TrekSet.StandardPulse,[1:PulseN]-sh(shi),'spline',0)');
        [m,mi]=max(Stp);
    
        TailInd=find(Stp<=0);
        TailInd(TailInd<mi)=[];
        TailInd=TailInd(1);
        
        
        StpL=circshift(Stp,-1);
        StpR=circshift(Stp,1);
        MaxCurve=[StpL(1:mi-1);Stp(mi);StpR(mi+1:end)];
        MinCurve=[StpR(1:mi-1);Stp(mi);StpL(mi+1:end)];
        
%%
        %first step All indexes of points that correspond to all points of
        %StandardPulse
%         FitInd=[1:PulseN]+TrekSet.SelectedPeakInd(I)-mi;
        %Here we take only points in main part
        FitInd=[1:TailInd]+TrekSet.SelectedPeakInd(I+dI)-mi;

        %reduce points out of bounds trek
        FitInd=FitInd(FitInd<=TrekSet.size&FitInd>=1);
        FitIndPulse=FitInd-TrekSet.SelectedPeakInd(I+dI)+mi; %make Indexes same size



        %Reduce points which overlaped to next pulse only after front
        if I+dI<PeakN
            %BorderInd is index there next pulse can be over Threshold.
            BorderInd=max([TrekSet.SelectedPeakInd(I+dI+1)-MaxInd+find(trek(TrekSet.SelectedPeakInd(I+dI+1))*TrekSet.StandardPulse>TrekSet.Threshold,1,'first'),...
                TrekSet.SelectedPeakInd(I+dI+1)-(MaxInd-BckgFitN)]); %if next pulse to small, to avoid empty BorderInd
            FitInd=FitInd(FitInd<BorderInd|FitIndPulse<=mi);            
            FitIndPulse=FitInd-TrekSet.SelectedPeakInd(I+dI)+mi; %make Indexes same size
        end;




         ex=1;
         while ex>0
            p=polyfit(Stp(FitIndPulse),trek(FitInd),1);
            A=p(1);
            B=p(2);
            %if B > Threshold, it can mean there are not signed Peaks on front

            bool=((MaxCurve(FitIndPulse)*A+B+TrekSet.Threshold-trek(FitInd))>=0&...
                 (trek(FitInd)-(MinCurve(FitIndPulse)*A+B-TrekSet.Threshold))>=0)';
            % points from next pulse on tail can increase A&B so iterations are
            % necessary
            % but in iterations we reduce points only on tail
             if isempty(find(not(bool|FitIndPulse<=mi))) 
                 ex=0; 
             else
            %  reduce points out of Min/MaxCurve corridor but not at front    
                 FitIndPulse=FitIndPulse(bool|FitIndPulse<=mi);
                 FitInd=FitIndPulse+TrekSet.SelectedPeakInd(I+dI)-mi;
             end;
        end;
        % if whole front don't get in Min/MaxCurve corridor go to next step
        if B<TrekSet.Threshold   
            if numel(find(not(bool)&FitIndPulse<MaxInd&FitIndPulse>BckgFitN))>0
                continue;
            end;
        else
           if numel(find(not(bool)&FitIndPulse<MaxInd))>0
            continue;
           end;
        end;

        %reduce points on tail which greater then max
            FitInd((trek(FitInd)'>=trek(TrekSet.SelectedPeakInd(I+dI)))&FitIndPulse>mi)=[];
            FitIndPulse=FitInd-TrekSet.SelectedPeakInd(I+dI)+mi;

   
             
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
             FitInd=FitIndPulse+TrekSet.SelectedPeakInd(I+dI)-mi;
        end;
        %only here(Double Peak Search) make Fit Interval continious
        FitIndPulse=[1:FitIndPulse(end)];
        FitInd=FitIndPulse+TrekSet.SelectedPeakInd(I+dI)-mi;
        
            
        N(shi,ami)=size(FitIndPulse,2);
        
             
%% ============== fitting
               if FitPlot 
                   fp=figure; 
                   grid on; hold on;
                   plot(FitInd,trek(FitInd),'.b-');
                   plot([1:PulseN]+TrekSet.SelectedPeakInd(I+dI)-MaxInd,trek([1:PulseN]+TrekSet.SelectedPeakInd(I+dI)-MaxInd),'b');
                   axis([1+TrekSet.SelectedPeakInd(I+dI)-MaxInd,TailInd+TrekSet.SelectedPeakInd(I+dI)-MaxInd,-50,trek(TrekSet.SelectedPeakInd(I+dI))+TrekSet.Threshold]);
                   title(['Now is ',num2str(sh(shi)),' shift and ',num2str(am(ami)),' relative amp of second pulse']);

               end;
                % shT>0 means shift in time left. Conditions for shT to Avoid fitting
                % by part of front. In this case we have good khi, but
                % after subtracting get the negative line, because maximum
                % of fit pulse much greater then trek pulse
                Yi=trek(FitInd);
                shT=1/2;
                KhiMinInd=1;
                while KhiMinInd<3&shT>=-1
                    Khi=[];
                    Khi(1:3)=inf;
                    shTi=1;
                    FineInd=[];
                    while (Khi(end)<=Khi(end-1)|Khi(end-1)<=Khi(end-2))&(shT>=-1)
                        FineInd(end+1)=shT;
                        FitPulse=interp1([1:PulseN],Stp,[1:PulseN]+shT,'spline',0);
                        p=polyfit(FitPulse(FitIndPulse),Yi',1);
                         Khi(shTi)=sum((Yi'-(p(1)*FitPulse(FitIndPulse)+p(2))).^2)/N(shi,ami)/trek(TrekSet.SelectedPeakInd(I+dI));
%                         weight=abs(Stp(FitIndPulse))';
%                         weight=zeros(1,N(shi,ami));
%                         weight(1:mi)=1;
%                         Khi(shTi)=sum(weight.*(Yi'-(p(1)*FitPulse(FitIndPulse)+p(2))).^2)/N(shi,ami)/trek(TrekSet.SelectedPeakInd(I));
                        shTi=shTi+1;
                        shT=shT-1/Nfit;
                         if FitPlot
                            figure(fp);
                            plot(FitInd,p(1)*FitPulse(FitIndPulse)+p(2),'om-');
                            plot(FitInd,trek(FitInd)'-p(1)*FitPulse(FitIndPulse)+p(2),'g');
                            pause;
                        end;
                    end;

                    [KhiMin,KhiMinInd]=min(Khi);
                    shT=FineInd(1)+2/Nfit;
                end;

                if FitPlot
                    figure(fp);
                    close(gcf);
                end;

                [KhiMin,KhiMinInd]=min(Khi);

                shTi=shTi-1;
                StInd=max([1,KhiMinInd-2]);
                EndInd=min([shTi,KhiMinInd+2]);
                if KhiMinInd>shTi-2
                    continue;
                end;
                
                KhiFit=polyfit(FineInd(StInd:EndInd),Khi(StInd:EndInd),2);
                Shift=-KhiFit(2)/(2*KhiFit(1));

                PulseFine=interp1([1:PulseN],Stp,[1:PulseN]+Shift,'spline',0);
                [p,Rstruct]=polyfit(PulseFine(FitIndPulse),Yi',1);
                MinKhi2(shi,ami)=sum((Yi'-(p(1)*PulseFine(FitIndPulse)+p(2))).^2)/N(shi,ami)/trek(TrekSet.SelectedPeakInd(I+dI));
                    if MinKhi2(shi,ami)<MinKhi
                        MinKhi=MinKhi2(shi,ami);
                        pSh=sh(shi);
                        pShi=shi;
                        pAm=am(ami);
                        pAmi=ami;
                        mShift=Shift;
                        Amp=p(1);
                        Bckg=p(2);
%                         PulsePlot=true;
                    end;

%%
        if PulsePlot
            PulseSubtract=p(1)*PulseFine+p(2);

            SubtractInd=[1:PulseN]+TrekSet.SelectedPeakInd(I+dI)-mi;
            SubtractInd=SubtractInd(SubtractInd<=TrekSet.size&SubtractInd>=1);
            SubtractIndPulse=SubtractInd-TrekSet.SelectedPeakInd(I+dI)+mi;

            figure;
             grid on; hold on;
             plot(SubtractInd,trek(SubtractInd));
             plot(TrekSet.SelectedPeakInd(I+dI),trek(TrekSet.SelectedPeakInd(I+dI)),'*r');
             plot(FitInd,trek(FitInd),'ob');           

             plot(SubtractInd,PulseSubtract(SubtractIndPulse),'.m-');
             plot(FitInd,PulseSubtract(FitIndPulse),'om');
             
             plot(SubtractInd,trek(SubtractInd)'-PulseSubtract(SubtractIndPulse),'g');
             axis([SubtractInd(1),SubtractInd(1)+50,-TrekSet.Threshold,trek(TrekSet.SelectedPeakInd(I+dI))+TrekSet.Threshold]);
             pause;
             close(gcf);
%              PulsePlot=true;
        end;
%%
    end;
end;
%% ================= trek cleaning and data saving        p=polyfit(Stp(FitIndPulse),trek(FitInd),1);

Stp=(TrekSet.StandardPulse+pAm*interp1([1:PulseN],TrekSet.StandardPulse,[1:PulseN]-pSh,'spline',0)');
[m,mi]=max(Stp);
Stp=interp1([1:PulseN],Stp,[1:PulseN]+mShift,'spline',0);
PulseSubtract=Amp*Stp+Bckg;
SubtractInd=[1:PulseN]+TrekSet.SelectedPeakInd(I+dI)-mi;
SubtractInd=SubtractInd(SubtractInd<=TrekSet.size&SubtractInd>=1);
SubtractIndN=numel(SubtractInd);
SubtractIndPulse=SubtractInd-TrekSet.SelectedPeakInd(I+dI)+mi;
FitIndPulse=[1:mi];
FitInd=FitIndPulse+TrekSet.SelectedPeakInd(I+dI)-mi;

%definite the region there trek essentialy change
DisturbIndPulse=find(PulseSubtract>TrekSet.Threshold);
DisturbInd=DisturbIndPulse+TrekSet.SelectedPeakInd(I+dI)-mi;
DisturbInd=DisturbInd(DisturbInd<=TrekSet.size&DisturbInd>=1);
DisturbIndPulse=DisturbInd-TrekSet.SelectedPeakInd(I+dI)+mi;


if FitPass>=FitPassN|(max(trek(FitInd)-PulseSubtract(FitIndPulse)')-min(trek(FitInd)-PulseSubtract(FitIndPulse)'))<=2*TrekSet.Threshold
    if EndPlot
        figure;
            grid on; hold on;
            plot(SubtractInd,trek(SubtractInd));
            plot(TrekSet.SelectedPeakInd(I+dI),trek(TrekSet.SelectedPeakInd(I+dI)),'*r');
            plot(SubtractInd,PulseSubtract(SubtractIndPulse),'.m-');
            plot(SubtractInd,trek(SubtractInd)'-PulseSubtract(SubtractIndPulse),'g');
%             axis([SubtractInd(1),SubtractInd(1)+TailInd,-TrekSet.Threshold,trek(TrekSet.SelectedPeakInd(I+dI))+TrekSet.Threshold]);
            disp(['This is ',num2str(FitPass),' pass']);        
            goodfit=input('If empty continue fitting\n','s');
        close(gcf);
    else
        if abs(MinKhiOld-MinKhi)<0.05 goodfit='q'; end;
    end;

if Amp>TrekSet.Threshold&abs(Bckg)<TrekSet.Threshold&...
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


if (max(trek(FitInd)-PulseSubtract(FitIndPulse)')-min(trek(FitInd)-PulseSubtract(FitIndPulse)'))<=2*TrekSet.Threshold|not(isempty(goodfit))|...
        abs(sum(trek(FitInd)-PulseSubtract(FitIndPulse)'))<=2*TrekSet.Threshold;
    if Amp>TrekSet.Threshold&abs(Bckg)<TrekSet.Threshold|not(isempty(goodfit))
                            trek(SubtractInd)=trek(SubtractInd)-PulseSubtract(SubtractIndPulse)'; 
                            if max(abs(trek(SubtractInd)-Bckg))<TrekSet.Threshold   %may be need more weak condition (for oscilations) 
                                trek(SubtractInd)=trek(SubtractInd)-Bckg;           %abs(sum(trek(SubtractInd)-Bckg)/SubtractIndN)<TrekSet.Threshold
                            end;
                                
                            peaks(1,1)=TrekSet.SelectedPeakInd(I);             %TrekSet.SelectedPeakInd Max initial
                            peaks(1,2)=TrekSet.StartTime+TrekSet.SelectedPeakInd(I)*TrekSet.tau-mShift*TrekSet.tau;  %Peak Max Time fitted
                            peaks(1,3)=peaks(1,2);     % for peak-to-peak interval
                            peaks(1,4)=Bckg;                        %Peak Zero Level
                            peaks(1,5)=Amp;                     %Peak Amplitude
                            peaks(1,6)=MinKhi/Amp ;%MinKhi2;% /Ampl;% KhiMin
                            peaks(1,7)=0;                     % number of Pass in which peak finded

                            peaks(2,1)=TrekSet.SelectedPeakInd(I+dI);             %TrekSet.SelectedPeakInd Max initial
                            peaks(2,2)=TrekSet.StartTime+TrekSet.SelectedPeakInd(I)*TrekSet.tau+pSh*TrekSet.tau-mShift*TrekSet.tau;  %Peak Max Time fitted
                            peaks(2,3)=peaks(2,2);     % for peak-to-peak interval
                            peaks(2,4)=Bckg;                        %Peak Zero Level
                            peaks(2,5)=Amp*pAm;                     %Peak Amplitude
                            peaks(2,6)=MinKhi/Amp ;%MinKhi2;% /Ampl;% KhiMin
                            peaks(2,7)=0;                     % number of Pass in which peak finded
                            TrekSet.peaks=peaks;
                            if  (max(trek(DisturbInd))-min(trek(DisturbInd)))>2*TrekSet.Threshold&not(OscilFit)
                                TrekSet.SelectedPeakInd(TrekSet.SelectedPeakInd>SubtractInd(SubtractIndPulse==mi)&TrekSet.SelectedPeakInd<=SubtractInd(end))=[];
                                TrekSet.PeakOnFrontInd(TrekSet.PeakOnFrontInd>SubtractInd(SubtractIndPulse==mi)&TrekSet.PeakOnFrontInd<=SubtractInd(end))=[];
                                TrekSet.PeakOnTailInd(TrekSet.PeakOnTailInd>SubtractInd(SubtractIndPulse==mi)&TrekSet.PeakOnTailInd<=SubtractInd(end))=[];
                                TrekSet.LongFrontInd(TrekSet.LongFrontInd>SubtractInd(SubtractIndPulse==mi)&TrekSet.LongFrontInd<=SubtractInd(end))=[];

                                TrekSet1=TrekSet;
                                TrekSet1.Plot=false;
                                TrekSet1.trek=[TrekSet.StdVal;-TrekSet.StdVal;0;trek(SubtractInd(SubtractIndPulse>mi))];
                                %first 3 points is necessary for making
                                %minimum before pulse 
                                TrekSet1.size=numel(TrekSet1.trek);
                                TrekSet1.SelectedPeakInd=[];
                                TrekSet1.PeakOnFrontInd=[];
                                TrekSet1.PeakOnTailInd=[];
                                TrekSet1.LongFrontInd=[];
                                TrekSet1.Threshold=2*TrekSet.Threshold;
                                TrekSet1=TrekPeakSearch(TrekSet1);

                                TrekSet1.SelectedPeakInd=TrekSet1.SelectedPeakInd-1+SubtractInd(mi+1)-3;
                                TrekSet1.PeakOnFrontInd=TrekSet1.PeakOnFrontInd-1+SubtractInd(mi+1)-3;
                                TrekSet1.PeakOnTailInd=TrekSet1.PeakOnTailInd-1+SubtractInd(mi+1)-3;
                                TrekSet1.LongFrontInd=TrekSet1.LongFrontInd-1+SubtractInd(mi+1)-3;

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
                           
        break; %to avoid second pass if good fit at first
    end;
else
end;
end;%end of if FitPass>=FitPassN
%%
dSh=sh(2)-sh(1);
if pShi<3
    St=max([pSh(1)/Nfit,pSh-(sh(3)-sh(1))]);
    En=sh(pShi+2);
else
    if pShi>shN-2
        St=sh(pShi-2);
        En=pSh+(sh(end)-sh(end-2));
    else
        St=sh(pShi-2);
        En=sh(pShi+2);
    end;
end;
sh=[St:(En-St)/Nfit:En];
shN=numel(sh);

if pAmi<3
    St=max([am(1)/Nfit,pAm-(am(3)-am(1))]);
    En=am(pAmi+2);
else
    if pAmi>amN-2
        St=am(amN-2);
        En=pAm+(am(end)-am(end-2));
    else
        St=am(pAmi-2);
        En=am(pAmi+2);
    end;
end;
am=[St:(En-St)/Nfit:En];
amN=numel(am);
MinKhiOld=MinKhi;
end;
%%
toc;
disp('====Get Double Peaks finished');

TrekSet.trek=trek;





            