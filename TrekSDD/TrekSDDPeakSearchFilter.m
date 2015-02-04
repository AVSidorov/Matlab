function [TrekSet,trekMinus]=TrekSDDPeakSearchFilter(TrekSet,FilterResponseWidth)



if nargin<2
    FilterResponseWidth=10;
end;

peaks=[];
peaksBad=[];

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
WidthMax=FilterResponseWidth;
FilterResponseWidth=2;
f=(WidthMax/FilterResponseWidth)^(1/stepN);
while FilterResponseWidth<=WidthMax
    %% filter calculating
    Resp(:,2)=exp(-(time-MaxTime).^2/(2*(sqrt(FilterResponseWidth)*TrekSet.tau)^2))';

    Kernel=MakeKernelByResponse(Resp,Stp,false);
    kernel=KernelByTimeStep(Kernel,0.02);


    %% Peaks Searching
    ex=true;
    NAdded=inf;
    % peaks=[];
    kernel=kernel(1:137);
    Threshold=[];
    while ex
        tic;
        trek=filter(kernel,1,TrekSet.trek);

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
        if ~isempty(SelectedPeakInd)
            %% Determinition Pulse interval above noise and not intersected with neighbour pulses
            % intial amlitude is trek value in selected point 

            %determine for each pulse interval above noise (half width)
            Delta=sqrt(-log(TrekSetF.StdVal./trek(SelectedPeakInd))*2*(sqrt(FilterResponseWidth)*0.02)^2)/TrekSet.tau;
            DeltaI=round(Delta);

            %deterimine iterval to previouse and next
            Ibefore=zeros(size(SelectedPeakInd));
            Ibefore(2:end)=SelectedPeakInd(2:end)-SelectedPeakInd(1:end-1);
            Dbefore=zeros(size(SelectedPeakInd));
            Dbefore(1,1)=DeltaI(1);
            for i=2:numel(SelectedPeakInd)
                Dbefore(i,1)=min([DeltaI(i),round(Ibefore(i)-Delta(i-1))]);
            end;


            Iafter=zeros(size(SelectedPeakInd));
            Iafter(end)=TrekSet.size-SelectedPeakInd(end);
            Iafter(1:end-1)=SelectedPeakInd(2:end)-SelectedPeakInd(1:end-1);

            Dafter=zeros(size(SelectedPeakInd));
            for i=1:numel(SelectedPeakInd)-1
                Dafter(i,1)=min([DeltaI(i),round(Iafter(i)-Delta(i+1))]);
            end;
            Dafter(end,1)=DeltaI(end);

            bool=(Dafter+Dbefore)<1;
            Dafter(bool)=[];
            Dbefore(bool)=[];

            SelectedPeakInd(bool)=[];

           %% determine amplitude by integral
            Amp=zeros(size(SelectedPeakInd));
            for i=1:numel(SelectedPeakInd)
               Amp(i,1)=sum(trek(SelectedPeakInd(i)-Dbefore(i):SelectedPeakInd(i)+Dafter(i)))/(sum(Resp(MI-round(Dbefore(i)/STP.TimeStep):MI+round(Dafter(i)/STP.TimeStep),2))*STP.TimeStep); 
            end;

            bool=Amp<Threshold;
            Amp(bool)=[];
            SelectedPeakInd(bool)=[];
        end;
        %% saving founded peaks and cleaning TrekSet.trek for research
        if ~isempty(SelectedPeakInd)&&numel(SelectedPeakInd)<NAdded(end);        
            NAdded(end+1)=numel(SelectedPeakInd);
            TrekSet.peaks=[];
            TrekSet.peaks(:,1)=SelectedPeakInd;
            TrekSet.peaks(:,2)=SelectedPeakInd*TrekSet.tau+TrekSet.StartTime;
            TrekSet.peaks(2:end,3)=diff(TrekSet.peaks(:,2));
            TrekSet.peaks(:,4)=0;
            TrekSet.peaks(:,5)=Amp;
            bool=Amp-trek(SelectedPeakInd)>TrekSet.Threshold;
            TrekSet.peaks(bool,5)=trek(SelectedPeakInd(bool));
            TrekSet.peaks(:,7)=0;
            peaks=[peaks;TrekSet.peaks];        
            fprintf('Added %5.0f peaks in %5.2f sec\n', NAdded(end),toc);
            TrekSet=TrekSubtractByPeaks(TrekSet);
        else
            ex=false;
        end;

    end;   
    
    FilterResponseWidth=FilterResponseWidth*f;
end;

%% final output
trekMinus=TrekSet.trek;
TrekSet=TrekSetIn;
peaks(:,2)=peaks(:,1)*TrekSet.tau+TrekSet.StartTime;
peaks(2:end,3)=diff(peaks(:,2));
peaks(:,4)=0;
peaks=sortrows(peaks,2);
TrekSet.peaks=peaks;


