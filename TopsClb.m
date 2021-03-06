function [PeakSet,StandardPulseNorm]=TopsClb(FileName,Plot,trProcessBool)
%PeakSet -> [SelectedPeakInd,PeakOnFrontInd,Threshold]
% Search peak top indexes of tr(:,1) array.
%FileName - file of 1D array of measurement sampled at 1/tau rate
           %tr signals are supposed to be positive short pulses,
           %FileName signals are supposed to be negative short pulses,
           % front ~3-4 points, tail is more than 4 points.

           
%SelectedPeakInd - indexes of peak tops selected
%PeakOnFrontInd - indexes of peak tops overlaped with other peak fronts
%Threshold - noise standard deviation      
      

% Signal are cathed from noises by detecting their fronts(1) and tops(2):
% 1. Front detection using array trF=-trD.^2.*trDD, 
%     which quite sensitive to real signal (Section 1) 
% 2. Top detection using variation of 5 measurements 
%     around any top (Section 2)
% 3. Combimagtion of (1) and (2) to select noise out. 
% 4. Search a standradr signal pulse from extracted signal.  

tic;

Time=[];
disp('>>>>>>>>TopsClb.m started'); 



Text  = false;    % switch between text and bin files
tau=0.020;        % us digitizing time
MinFront=0.05;    % minimal peak front, us
MaxFront=0.125;   % maximal peak front, us
MinTail=0.05;     % minimal peak tail, us
MaxTail=0.8;      % maximal peak tail, us
OverSt=4;         % noise regection threshold, in standard deviations
ThresholdPre=100; % PreSelected threshol for manual input

MaxSignal= 3300;  % maximal signal whithout distortion
notProcessTail=8; % number of points after exceeding of Maxsignal, which will'nt be processed

StandardPulseFile='D:\!SCN\EField\StandPeakAnalys\StPeak20ns_2.dat';


if nargin<2; Plot=true; end;
if isstr(FileName); 
     [tr,ProcInt,ProcIntTime,StdVal]=PrepareTrek(FileName); 
     ThresholdStd=OverSt*StdVal;
 else
     tr=FileName;
 end;



if nargin<3|isempty(trProcessBool);
    trProcessBool=logical(ones(size(tr)));
    
    trProcessBool=tr<MaxSignal;
    for i=1:notProcessTail
        trProcessBoolSh=circshift(trProcessBool,1);
        trProcessBoolSh(1)=true;
        trProcessBool=trProcessBool&trProcessBoolSh;
    end;
    clear trProcessBoolSh;
end;

MaxFrontN=round(MaxFront/tau); MaxTailN=round(MaxTail/tau);
MinFrontN=round(MinFront/tau); MinTailN=round(MinTail/tau);


trSize=size(tr,1);

Time(end+1)=toc;
%================ Threshold Determination Peaks ==============  

tic;

[MeanVal,StdVal,PeakPolarity,Noise]=MeanSearch(tr,OverSt,0);
ThresholdStd=StdVal*OverSt;

Time(end+1)=toc;
disp(['Std Calculation time=', num2str(Time(end))]);
disp(['Total time=', num2str(sum(Time))]);


fprintf(['Press ''C'' to correct the threshold or to accept the followes one as Threshold: \n',...
        '''r'' (red) by Standard deviation %6.3f\n',...
        '''m'' (magenta) by Std*OverSt %6.3f\n',...
        '''e'' for manual input default %6.3f\n'],StdVal,ThresholdStd,ThresholdPre);

        
    Decision=input('Default is Threshold=Std*OverSt ','s');
    if isempty(Decision); Decision='q'; end;  
    if Decision=='q'  
        Threshold=max([ThresholdStd,ThresholdPre]);
    end;
    if Decision=='r'||Decision=='R'
        Threshold=StdVal;
    end;
    if Decision=='m'||Decision=='M'
        Threshold=ThresholdStd;
    end;

    if Decision=='e'||Decision=='E'
        Threshold=input('Input threshold ');
        if isempty(Threshold)
            Threshold=ThresholdPre;
        end;
    end;

%================ Find Peaks ==============  

tic;
   
trR1=circshift(tr,1);  trR1(1)=trR1(2);
trR2=circshift(tr,2);  trR2(1)=trR2(3); trR2(2)=trR2(3);

trL1=circshift(tr,-1); trL1(end)=trL1(end-1);
trL2=circshift(tr,-2); trL2(end)=trL2(end-2); trL2(end-1)=trL2(end-2);

MaxBool=tr>trR1&tr>trL1;
MaxBool(1)=false; MaxBool(end)=false;
MaxInd=find(MaxBool); 
MaxIndN=size(MaxInd,1);

%5-points noise analysis
% noise like: /\/\
NoiseMBool=tr<trR1&tr<trL1&trL2<trL1&trR2<trR1;
NoiseMInd=find(NoiseMBool);
NoiseMIndN=size(NoiseMInd,1);

% noise like: \/\/
NoiseWBool=tr>trR1&tr>trL1&trL2>trL1&trR2>trR1;
NoiseWInd=find(NoiseWBool);
NoiseWIndN=size(NoiseWInd,1);

SignalBool=tr>Threshold; 
SignalInd=find(SignalBool);
SIndN=size(SignalInd,1);

%Standard Pulse Preselection
StPBool=tr>trR1&trR1>trR2&tr>trL1&trL1>trL2;
StPBool=StPBool&SignalBool&not(NoiseWBool)&not(NoiseMBool);
StPInd=find(StPBool);
StPIndN=size(StPInd,1);

clear trR1 trR2 trL1 trL2 ;

PeakBool=MaxBool&SignalBool&not(NoiseWBool)&not(NoiseMBool);
PeakInd=find(PeakBool); 
PeakIndN=size(PeakInd,1);

Time(end+1)=toc;
disp(['Finding Peaks,max, W, M, and above Threshold signals time=', num2str(Time(end))]);

tic;    

PeakSet.SelectedPeakInd=PeakInd;
SelectedPeakN=size(PeakSet.SelectedPeakInd,1);
PeakSet.Threshold=Threshold;


% Readout of standard pulse averaged aver many tracks
if exist(StandardPulseFile,'file');
   StandardPulseNormFile=load(StandardPulseFile);
   [StPFMax,StPFMaxInd]=max(StandardPulseNormFile);
   [StPFMax1,StPFMax1Ind]=max(StandardPulseNormFile(StandardPulseNormFile<StPFMax));
   StPFFitInd=min(StPFMaxInd,StPFMax1Ind);

   disp(['Standard pulses is taken from ',StandardPulseFile]);
   
   MaxFrontN=StPFMaxInd;
   MaxTailN=size(StandardPulseNormFile,1)-StPFMaxInd;

    StandardPulseNormFileD=diff(StandardPulseNormFile); 
    StandardPulseNormFileD(end+1)=StandardPulseNormFileD(end); 
    StandardPulseNormFileDD=diff(StandardPulseNormFile,2); 
    StandardPulseNormFileDD(end+1)=StandardPulseNormFileDD(end);
    StandardPulseNormFileDD(end+1)=StandardPulseNormFileDD(end);
    StandardPulseNormFileF=-20*StandardPulseNormFileD.^2.*StandardPulseNormFileDD;
end;
%search of PeakOnFront
if not(isempty(PeakSet.SelectedPeakInd))
    IntervalBefore=PeakInd-circshift(PeakInd,1);
    IntervalBefore(1)=PeakInd(1);
    IntervalAfter=circshift(PeakInd,-1)-PeakInd;
    IntervalAfter(end)=trSize-PeakInd(end);
    PeakOnFrontBool=IntervalAfter<MaxFrontN;
    PeakSet.PeakOnFrontInd=PeakInd(PeakOnFrontBool);
end;


%preselection to search standard peak: 

PeakRangeMost=mean(tr(PeakBool));
RangeSelectedPeak=tr(PeakBool);


if Plot    
    figure; hold on; grid on; 
    plot(tr,'-y.');  %plot(trD,'m');  
    plot(MaxInd,tr(MaxInd),'g.');
    plot(NoiseMInd,tr(NoiseMInd),'k.'); plot(NoiseWInd,tr(NoiseWInd),'b.');
    plot(SignalInd,tr(SignalInd),'-m.');          
    plot(PeakSet.SelectedPeakInd,tr(PeakSet.SelectedPeakInd),'go'); 
    plot(StPInd,tr(StPInd),'ro');
    legend('track','max','NoiseM','NoiseW','S','Selected peaks','Standard peaks');
    plot([1,trSize],[Threshold,Threshold]);
end; 


fprintf('=====  Search of peak tops      ==========\n');
fprintf('The number of measured points  = %7.0f during %7.0f us \n',trSize,trSize*tau);
fprintf('The number of maximums  = %7.0f \n',MaxIndN);
fprintf('The number of noise peaks (W types)= %7.0f \n',NoiseWIndN);
fprintf('The number of noise peaks (M types)= %7.0f \n',NoiseMIndN);
fprintf('The number of noise peaks (W and M types)= %7.0f \n',NoiseMIndN+NoiseWIndN);
fprintf('The number of signal points (above threshold) = %7.0f \n',SIndN);
fprintf('The number of selected peaks above %7.2f threshold = %7.0f \n',PeakSet.Threshold,SelectedPeakN);
Time(end+1)=toc;
disp(['Search peak tops time=', num2str(Time(end))]);
fprintf('>>>>>>>>>>>>>>>>>>>>>>\n');
%================ section 4 ==============
%Distribution of time intervals among peaks: 

fprintf('=====  Search of Standard pulse    ==========\n');
tic;



if not(isempty(PeakSet.SelectedPeakInd))
    IntervalBefore=StPInd-circshift(StPInd,1);
    IntervalBefore(1)=StPInd(1);
    IntervalAfter=circshift(StPInd,-1)-StPInd;
    IntervalAfter(end)=trSize-StPInd(end);


    SingleInterval=(MaxFrontN+MaxTailN);
    StandardPeakBool=IntervalBefore>SingleInterval&IntervalAfter>SingleInterval;
    StandardPeakBool(RangeSelectedPeak<(PeakSet.Threshold+PeakRangeMost)/2)=false;
    StandardPeakInd=PeakSet.SelectedPeakInd(StandardPeakBool);
    StandardPeakN=size(StandardPeakInd,1);
    if StandardPeakN>0
        %Synhronize standard peaks using two highest points:
        AscendTop=tr(StandardPeakInd-1)>=tr(StandardPeakInd+1);
        if StandardPeakInd(end)-AscendTop(end)+MaxTailN>trSize
            StandardPeakN=StandardPeakN-1; StandardPeakInd(end)=[]; end;
        if StandardPeakInd(1)-AscendTop(1)-MaxFrontN<1;
            StandardPeakN=StandardPeakN-1; StandardPeakInd(1)=[]; end;
        SampleN=MaxFrontN+MaxTailN+1;
        StandardPulse=zeros(SampleN,StandardPeakN);

        % Make StandardPule matrix
        for i=1:StandardPeakN;
            NN=StandardPeakInd(i)-AscendTop(i);
            StandardPulse(:,i)=tr(NN-MaxFrontN:NN+MaxTailN)-...
                (tr(NN-MaxFrontN)+tr(NN+MaxTailN))/2;
        end;
        % remove all signals above MaxSignal:
        MaxSignal=3000;
        SignalsOk=StandardPulse<MaxSignal;
        for i=1:SampleN
            SelectedStandrdPulse=StandardPulse(i,SignalsOk(i,:));
            MeanStandardPulse(i,1)=mean(SelectedStandrdPulse);
            stdStandardPulse(i,1)=std(SelectedStandrdPulse);
            SelectedN(i,1)=sum(SignalsOk(i,:));
        end;
        StdNoise=mean(stdStandardPulse(end-6:end-3));

        % correction of zero line:
        x=[1,2,SampleN-3,SampleN-2,SampleN-1,SampleN]';
        Zero=polyfit(x,MeanStandardPulse(x),1);
        x=(1:SampleN)';
        MeanStandardPulse=MeanStandardPulse-(Zero(1)*x+Zero(2));
        [MaxStandardPulse,MaxStandardPulseIndx]=max(MeanStandardPulse);

        SmoothStartInd=MaxStandardPulseIndx+MaxFrontN;
        SmoothN=SampleN-SmoothStartInd;
        if SmoothN>3
            SmoothTail=smooth(MeanStandardPulse(SmoothStartInd-2:end),3);
            MeanStandardPulse(SmoothStartInd:end)=SmoothTail(3:end);
        end;
        LastFrontZero=find(MeanStandardPulse(1:MaxStandardPulseIndx)<=0,1,'last');
        FirstTailZero=find(MeanStandardPulse(MaxStandardPulseIndx+1:end)<=0,1,'first')+MaxStandardPulseIndx;
        MeanStandardPulse(1:LastFrontZero)=0;
        MeanStandardPulse(FirstTailZero:end)=0;
        StandardPulseNorm=MeanStandardPulse/MaxStandardPulse;
        
        % correction pre front zero point number;
        if LastFrontZero>1
         StandardPulseNorm(1:LastFrontZero-1)=[];
        end;

        [StPMax,StPMaxInd]=max(StandardPulseNorm);
        [StPMax1,StPMax1Ind]=max(StandardPulseNorm(StandardPulseNorm<StPMax));
        StPFitInd=min(StPMaxInd,StPMax1Ind);

        fprintf('The number of standard pulses found = %7.0f \n',StandardPeakN);
        StandardPulseNormD=diff(StandardPulseNorm);
        StandardPulseNormD(end+1)=StandardPulseNormD(end);
        StandardPulseNormDD=diff(StandardPulseNorm,2);
        StandardPulseNormDD(end+1)=StandardPulseNormDD(end);
        StandardPulseNormDD(end+1)=StandardPulseNormDD(end);
        StandardPulseNormF=-20*StandardPulseNormD.^2.*StandardPulseNormDD;
    end;

    if Plot
        figure;
        if StandardPeakN>0
            subplot(2,1,1);
            hold on;  x=(1:SampleN)';
            for i=1:StandardPeakN
                plot(x(SignalsOk(:,i)),StandardPulse(SignalsOk(:,i),i));
            end;
            plot(MeanStandardPulse,'-c.','LineWidth',2,'MarkerSize',12);
            plot(stdStandardPulse,'-m.');
            ylim([min(StandardPulse(SignalsOk)), 1.1*max(StandardPulse(SignalsOk))]);
            grid on;
            subplot(2,1,2); hold on;
            plot(StandardPulseNorm,'-r.'); grid on;
            plot(StandardPulseNormF,'-b.');
        end;
    end;
end;

 
if exist(StandardPulseFile,'file');
   if Plot
    plot([(StPFitInd-StPFFitInd)+1:(StPFitInd-StPFFitInd)+size(StandardPulseNormFile,1)],StandardPulseNormFile,'-ro'); grid on;  hold on;
    plot([(StPFitInd-StPFFitInd)+1:(StPFitInd-StPFFitInd)+size(StandardPulseNormFile,1)],StandardPulseNormFileF,'-bo');
    legend('Standard Pulse','Standard Pulse F','File Standard Pulse','File Standard Pulse F');
   end;
end;

Time(end+1)=toc;
disp(['Standard Pulse Analyze=', num2str(Time(end))]);
fprintf('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n');
disp(['Full processing time=', num2str(sum(Time))]);
CloseGraphs;
disp('================ Tops.m finished');
      