function [TrekSet,trekMinus]=TrekSDDPeakSearchFilter(TrekSet,FilterResponseWidth)

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
time=(STP.TimeInd-1)*TrekSet.tau;
Stp(:,1)=time;
Stp(:,2)=STP.FinePulse;
[M,MI]=max(STP.FinePulse);
MaxTime=time(MI);
Resp(:,1)=Stp(:,1);

stepN=5;
WidthMax=FilterResponseWidth/(2*sqrt(2*log(2)));
FilterResponseWidth=TrekSet.tau*3/(2*sqrt(2*log(2)));
f=(WidthMax/FilterResponseWidth)^(1/stepN);
n=1;
while FilterResponseWidth<=WidthMax
    %% filter calculating
    Resp=GaussResponse(Stp,FilterResponseWidth);
    
    Kernel=MakeKernelByResponse(Resp,Stp,false);
    kernel=KernelByTimeStep(Kernel,0.02);
    StpFilt=filter(kernel,1,STP.Stp);
    [M,MaxIndFilt]=max(StpFilt);

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
                PeakSet(end).step=n;
                PeakSet(end).StepMarker=zeros(size(trek));
                PeakSet(end).StepMarker(SelectedPeakInd)=n;
            if isempty(peaks)
                peaks=PeakSet;
            else      
                peaks=PeaksMerge(peaks,PeakSet(end));
            end;
            fprintf('Now %5.0f peaks founded. Last iteration %5.2f sec\n', numel(peaks.Ind),toc);
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
     
     FilterResponseWidth=FilterResponseWidth*f;
     n=n+1;
end;

%% final output
trekMinus=TrekSet.trek;
TrekSet=TrekSetIn;
peaks(:,2)=peaks(:,1)*TrekSet.tau+TrekSet.StartTime;
peaks(2:end,3)=diff(peaks(:,2));
peaks(:,4)=0;
peaks=sortrows(peaks,2);
TrekSet.peaks=peaks;


