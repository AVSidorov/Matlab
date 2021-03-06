function [TrekSet,trekMinus]=TrekSDDPeakSearchFilter(TrekSet,WidthMax,WidthMin)
mode='exp';
if strcmp(lower(TrekSet.name),'generated')
    mode='white';
end;
StdValFile='D:\!SCN\FilteringSDD\StdVal-vs-fwhm.mat';


stepN=10;




if nargin<2
    WidthMax=0.8;
end;

if nargin<3
    WidthMin=TrekSet.tau*2;
end;
FilterResponseWidth=WidthMin;
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

% STP=TrekSet.STP;
% time=(STP.TimeInd-1)*TrekSet.tau;
% Stp(:,1)=time;
% Stp(:,2)=STP.FinePulse;

Stp=([1:TrekSet.STP.size]'-1)*TrekSet.tau;
Stp(:,2)=TrekSet.STP.Stp;

%% load StdVal vs Fwhm dependence for filtering
load(StdValFile,'fwhm');
load(StdValFile,['StdVal_',mode]);
StdValTab(:,1)=fwhm;
eval(['StdValTab(:,2)=StdVal_',mode,';']);

%% Fast Spectrum determination 
% This procedure performed for correct minimal filtered pulse width
% determination
% to avoid loosing all signal under noise threshold after filtering.
Resp=GaussResponse(Stp,WidthMax);
trek=TrekSDDFilterFFT(TrekSet,Resp);
S=SpecialTreks(trek);
SelectedPeakInd=find(S.MaxBool&trek>TrekSet.Threshold&TrekSet.trek<TrekSet.MaxSignal);
SelectedPeakInd(SelectedPeakInd*TrekSet.tau+TrekSet.StartTime<TrekSet.StartPlasma)=[];
Hist=HistOnNet(trek(SelectedPeakInd),[TrekSet.Threshold:TrekSet.StdVal:max(trek)]);
A=cumsum(Hist(:,2));
% ThresholdQLost is array dependence  relative quantity of Lost pulses from
% Threshold level 

ThresholdQLost(:,1)=Hist(:,1);
ThresholdQLost(:,2)=A(:)/A(end); 
%Taking part without zero bins we may obtain curve with not enough length
%for finding intersection further
% 
%take part of Histogram whithout zero bins whith max length
% Ind=find(diff(A)==0);
% Ind=[1;Ind;numel(A)];
% [l,i]=max(diff(Ind));
% ThresholdQLost(:,1)=Hist(Ind(i):Ind(i+1),1);
% ThresholdQLost(:,2)=A(Ind(i):Ind(i+1))/A(end); 

%mean pulse detecting time
mTau=range(SelectedPeakInd)*TrekSet.tau/A(end);
% using dependence StdVal growth from filtered pulse fwhm(=)dead time
% calculate relative part of lost pulses caused by overlapping
OverlapQlost(:,1)=TrekSet.Threshold*StdValTab(:,2); % recalculate relative StdVal change to absolute Threshold
OverlapQlost(:,2)=1-exp(-StdValTab(:,1)/mTau);
% to extend curve for all pulses amplitude range we add point with maximal
% amplitude. In small filtering output widths region Threshold raises very
% fast, so we take dead time (=output width) almost same as minimal in table
OverlapQlost(end+1,1)=Hist(end,1);
OverlapQlost(end,2)=1-exp(-min(StdValTab(:,1))*0.9/mTau);
OverlapQlost=sortrows(OverlapQlost);

%minimal width of filtered pulse (maximal noise level) is determinated as
%point there number of lost pulses in noise (under threshold) is equal to
%number for not overlapped pulses
[x,y]=intersections(ThresholdQLost(:,1),ThresholdQLost(:,2),OverlapQlost(:,1),1-OverlapQlost(:,2));
StdValStart=x/TrekSet.Threshold;

%% Determination of StdVal borders and linear spaced set
StdValStart=max([StdValStart,interp1(StdValTab(:,1),StdValTab(:,2),FilterResponseWidth,'linear',max(StdValTab(:,2)))]);
StdValStart=min([StdValStart,max(StdValTab(:,2))]);
StdValEnd=interp1(StdValTab(:,1),StdValTab(:,2),WidthMax,'linear',min(StdValTab(:,2)));
StdVals=[StdValStart:(StdValEnd-StdValStart)/(stepN-1):StdValEnd]';

%% Making FilterWidths
FilterWidths=interp1(StdValTab(:,2),StdValTab(:,1),StdVals);
if max(FilterWidths)~=WidthMax 
    FilterWidths(end)=WidthMax;
end;

% avoiding large gaps in FilterWidhts
Io = find(diff(FilterWidths)>=(range(FilterWidths)/stepN),1,'first');
FilterWidths=[FilterWidths;[max(FilterWidths)-range(FilterWidths)/stepN:-range(FilterWidths)/stepN:FilterWidths(Io)]'];

FilterWidths(FilterWidths<WidthMin)=[];

FilterWidths=sortrows(FilterWidths);
StdVals=interp1(StdValTab(:,1),StdValTab(:,2),FilterWidths);


n=1;
treks=zeros(TrekSet.size,stepN);

ex=false;

while ~ex
    tic;
    %% filtering calculating
    FilterResponseWidth=FilterWidths(n);
    Resp=GaussResponse(Stp,FilterResponseWidth);
    [trek,StpFilt]=TrekSDDFilterFFT(TrekSet,Resp);

    %% Peaks Searching
    Threshold=[];
    

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
     
     %determination by tabled StdVal
     ThresholdTable=TrekSet.Threshold*StdVals(n);
     
     %determination by part whihtout signal 
     ThresholdPlasma=[];
     if isfield(TrekSet,'NoiseSet')&&~isempty(TrekSet.NoiseSet)&&isstruct(TrekSet.NoiseSet)&&...
        isfield(TrekSet.NoiseSet,'NoiseInd')&&~isempty(TrekSet.NoiseSet.NoiseInd)&&numel(TrekSet.NoiseSet.NoiseInd)>1000
        NoiseSet=NoiseStd(trek(TrekSet.NoiseSet.NoiseInd));        
        ThresholdPlasma=NoiseSet.Thr;
     else
         TrekSetF=TrekSet;
         TrekSetF.trek=trek;
         TrekSetF=TrekSDDNoise(TrekSetF);         
         ThresholdPlasma=TrekSetF.Threshold;
     end;
     if ~isempty(ThresholdPlasma)
            Threshold=ThresholdPlasma;
     else
            Threshold=ThresholdTable;         
     end;
     
     if isempty(Threshold)&&TrekSet.Plot;
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
            treks(:,n)=trek;
            FilteredPulses(:,n)=StpFilt;
            FWHMs(n)=FilterResponseWidth/TrekSet.tau;
            Thresholds(n)=Threshold;
            n=n+1;
        else
            StdVals=[StdVals(n+1):(StdValEnd-StdVals(n+1))/(stepN-1):StdValEnd]';
            FilterWidths=interp1(StdValTab(:,2),StdValTab(:,1),StdVals)';
            if max(FilterWidths)~=WidthMax 
                FilterWidths(end)=WidthMax;
            end;
        end;

        if n>numel(FilterWidths)
            ex=true;
        end; 
end;

%% final output
% trekMinus=TrekSet.trek;

%PeakSet=peaks; %some lines for search history plotting
peaks=TrekSDDAmplitudesByFilter(peaks.Ind(:,1),treks,FilteredPulses,round(FWHMs),Thresholds);
% [ind,ia,ib]=intersect(peaks(:,1),PeakSet.Ind(:,1));
% PeakSet.Ind=PeakSet.Ind(ib,:);
% PeakSet.Amp=peaks(:,5);
% PeakSet.StepMarker=PeakSet.StepMarker(ib,:);
TrekSet=TrekSetIn;
TrekSet.peaks=zeros(size(peaks,1),7);
TrekSet.peaks(:,1)=peaks(:,1);
TrekSet.peaks(:,2)=peaks(:,1)*TrekSet.tau+TrekSet.StartTime;
TrekSet.peaks(2:end,3)=diff(TrekSet.peaks(:,2));
TrekSet.peaks(:,4)=0;
TrekSet.peaks(:,5)=peaks(:,5);
TrekSet.peaks=sortrows(TrekSet.peaks,2);





