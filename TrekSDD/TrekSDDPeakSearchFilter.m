function [TrekSet,trekMinus]=TrekSDDPeakSearchFilter(TrekSet,FilterResponseWidth)

mode='exp';
StdValFile='D:\!SCN\FilteringSDD\StdVal-vs-fwhm.mat';


if nargin<2
    FilterResponseWidth=0.8;
end;

peaks=[];


%% searching Reset Pulses intervals
if ~isfield(TrekSet,'ResetInd')
    TrekSet=TrekSDDResetFind(TrekSet);
end;
if ~isfield(TrekSet,'OverloadStart')
    TrekSet=TrekOverloadFind(TrekSet);
end;

% for i=1:numel(TrekSet.ResetStartInd)
%      Ind=[TrekSet.ResetStartInd(i):TrekSet.ResetInd(i)]';
%      [fit,s,m]=polyfit([Ind(1)-1,Ind(end)+1]',TrekSet.trek([Ind(1)-1,Ind(end)+1]),1);
%      TrekSet.trek(Ind)=polyval(fit,Ind,s,m);
%  end;

TrekSetIn=TrekSet;

%% filter initialization

STP=TrekSet.STP;
% time=(STP.TimeInd-1)*TrekSet.tau;
time=([1:STP.size]-1)'*TrekSet.tau;
Stp(:,1)=time;
% Stp(:,2)=STP.FinePulse;
Stp(:,2)=STP.Stp;
[M,MI]=max(Stp(:,2));
MaxTime=time(MI);
Resp(:,1)=Stp(:,1);

stepN=5;
WidthMax=FilterResponseWidth;
FilterResponseWidth=TrekSet.tau*3;
load(StdValFile,'fwhm');
load(StdValFile,['StdVal_',mode]);
StdValTab(:,1)=fwhm;
eval(['StdValTab(:,2)=StdVal_',mode,';']);
StdValStart=interp1(StdValTab(:,1),StdValTab(:,2),FilterResponseWidth);
StdValEnd=interp1(StdValTab(:,1),StdValTab(:,2),WidthMax,'linear',min(StdValTab(:,2)));
FilterWidths=interp1(StdValTab(:,2),StdValTab(:,1),[StdValStart:(StdValEnd-StdValStart)/stepN:StdValEnd]')';
if max(FilterWidths)~=WidthMax 
    FilterWidths(end)=WidthMax;
end;
f=(WidthMax/FilterResponseWidth)^(1/stepN);
n=1;
treks=zeros(TrekSet.size,stepN);
while FilterResponseWidth<=WidthMax
    %% filter calculating
    Resp=GaussResponse(Stp,FilterResponseWidth);
    
    Kernel=MakeKernelByResponse(Resp,Stp,false);
    kernel=KernelByTimeStep(Kernel,0.02);
    StpFilt=filter(kernel,1,STP.Stp);
    [M,MaxIndFilt]=max(StpFilt);
%     kernel=kernel(1:2*MaxIndFilt);
%     StpFilt=filter(kernel,1,STP.Stp);
%     [M,MaxIndFilt]=max(StpFilt);

    %% Peaks Searching
    Threshold=[];
    
    tic;
    trek=filter(kernel,1,TrekSet.trek);
    trek=circshift(trek,STP.MaxInd-MaxIndFilt);

     for i=1:numel(TrekSet.ResetStartInd)
         Ind=[TrekSet.ResetStartInd(i):min([TrekSet.size,TrekSet.ResetInd(i)+100])]';
         trek(Ind)=0;
     end;
     for i=1:numel(TrekSet.OverloadStart)
         Ind=[TrekSet.OverloadStart(i):TrekSet.OverloadEnd(i)]';
         trek(Ind)=0;
     end;


     S=SpecialTreks(trek);
     %% determintion of Threshold for filtered trek
        if isempty(Threshold);
            TrekSetF=TrekSet;
            rmfield(TrekSetF,'STP');
            TrekSetF.trek=trek;
            TrekSetF=TrekSDDNoise(TrekSetF);
            Threshold=ceil(TrekSetF.Threshold);
            h1=figure;
            subplot(2,1,1);
            grid on; hold on;
            Hist=HistOnNet(trek(S.MaxBool),[Threshold:Threshold/10:3*Threshold]);
            plot(Hist(:,1),Hist(:,2),'.b-');
            plot(Threshold*[1,1],[1,max(Hist(:,2))],'r','LineWidth',2);
            subplot(2,1,2);
            grid on; hold on;
            plot(trek,'k');
            plot([1,TrekSet.size],Threshold*[1,1],'r');
            
            fprintf('Now  Threshold is %4.0f\n',Threshold);
            ch=input('For change Threshold input (g)raphic choise, or any other symbol for comand line\n','s');
            figure(h1);
            if ~isempty(ch)&&~isempty(str2num(ch))&&str2num(ch)>=TrekSetF.StdVal
                 Threshold=str2num(ch);
            elseif strcmpi(ch,'g')
                [x,y]=ginput(1);
                Threshold=ceil(x);                
            elseif ~isempty(ch)
                ThresholdIn=input('New Threshold is ');
                if ~isempty(ThresholdIn)
                    Threshold=ThresholdIn;
                end;               
            end;
            fprintf('New Threshold is %3.0f\n',Threshold);
            close(h1);
        end;

       %% indexes finding
        SelectedPeakInd=find(S.MaxBool&trek>Threshold&TrekSet.trek<TrekSet.MaxSignal);
        SelectedPeakInd(SelectedPeakInd*TrekSet.tau+TrekSet.StartTime<TrekSet.StartPlasma)=[];

        %% combining peaks with previous filter
        if ~isempty(SelectedPeakInd)        
            if isempty(peaks)
               PeakSet=struct;
            end;
                PeakSet(end).Ind=SelectedPeakInd;           
                PeakSet(end).size=TrekSet.size;
                PeakSet(end).Amp=trek(SelectedPeakInd);
                PeakSet(end).trek=trek;
                PeakSet(end).Threshold=Threshold;
                PeakSet(end).sigma=FilterResponseWidth;
                PeakSet(end).fwhm=2*sqrt(2*log(2))*FilterResponseWidth/TrekSet.tau;
                PeakSet(end).step=n;
                PeakSet(end).StepMarker=ones(size(SelectedPeakInd));              
            if isempty(peaks)
                peaks=PeakSet;
            else      
                peaks=PeaksMerge(peaks,PeakSet(end));
            end;
            fprintf('Now %5.0f peaks founded. Last iteration %5.2f sec\n', size(peaks.Ind,1),toc);
        end;
     %% Calculating apmlitude
%      % determination integration winwow width
%       n1=round(MaxIndFilt-find(StpFilt*mean(peaks.Amp)>1,1,'first'));
%       n2=round(find(StpFilt*mean(peaks.Amp)>1,1,'last')-MaxIndFilt);
%       WHlfWidht=round(mean([n1,n2]));
%       WWidth=2*WHlfWidht+1;
%      % calculating initial Amps
%      trekI=filter(ones(WWidth,1),1,trek);
%      trekI=circshift(trekI,-WHlfWidht-1)/sum(StpFilt(MaxIndFilt-WHlfWidht:MaxIndFilt+WHlfWidht));
%      p=[];
%      p(:,1)=peaks.Ind;
%      p(:,2)=trekI(p(:,1));
%      % determination Amps by linear equation system
%      Amps=TrekSDDAmplitude(p,@(delay)KbyDelayIntegral(delay,StpFilt,WWidth));
%      peaks.Amp=Amps;
     
     treks(:,n)=trek;
     FilteredPulses(:,n)=StpFilt;
     FWHMs(n)=FilterResponseWidth/TrekSet.tau;
     Thresholds(n)=Threshold;

%      FilterResponseWidth=FilterWidths(1)*f^n;
     FilterResponseWidth=FilterWidths(n);
     n=n+1;
     if ~isempty(FilterWidths)&&n<=numel(FilterWidths)&&FilterResponseWidth>=FilterWidths(n)
         FilterResponseWidth=FilterWidths(n);
     end;

end;

%% final output
% trekMinus=TrekSet.trek;
peaks=TrekSDDAmplitudesByFilter(peaks.Ind(:,1),treks,FilteredPulses,round(FWHMs),Thresholds);
TrekSet=TrekSetIn;
TrekSet.peaks=zeros(size(peaks,1),7);
TrekSet.peaks(:,1)=peaks(:,1);
TrekSet.peaks(:,2)=peaks(:,1)*TrekSet.tau+TrekSet.StartTime;
TrekSet.peaks(2:end,3)=diff(TrekSet.peaks(:,2));
TrekSet.peaks(:,4)=0;
TrekSet.peaks(:,5)=peaks(:,5);
TrekSet.peaks=sortrows(TrekSet.peaks,2);


