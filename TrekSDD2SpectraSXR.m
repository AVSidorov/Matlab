function [f,FrontInd,ResetPulseInd,f1,f2,f3,f4]=TrekSDD2SpectraSXR(FileName); 
% SXR spectra from SDD treks
% FileName - 1. the name of the first file from a set of 4 trek files: 
%                      '01sxr' or '01sxr.dat'
%            2. concatination of 4 treks read out from trek files:  [f1,f2,f3,f4]; 
%            3. Merged trek f  

BaseTrek=1;     % the number of base trek. Normally BaseTrek=1, but if f1 is noisy then BaseTrek=2; 

ExcessNoise=3; 
UpperRange=4095;
TopDelay= 12; %(21); % delay of the pulse top from the maximum of the diff(Pulse), tacts                                          
StartDelay=-5; %(-9); % delay of the pulse start from the maximum of the diff(Pulse), tacts
FlatStartDelay=[-8:-3];
FlatTopDelay=[15:30]; 
FrontLevelNorm=0.3127; 
global MinimalGap;
MinimalGap=9;

Tact=20; % ADC tact, ns
StartPlasma=15; % ms - start of plasma discharge
EndPlasma=60; % ms - end of plasma discharge
TimeIntervals=[[26,30];[31,35];[36,40]]; 

% Minimal duration (in samples) of the flat bottom of reset pulses in trek#1 (the highest sensitivity)
ResetBottom1=1000; % Change if necessary
% The level of the reset pulse at which its duration > ResetBottom1
ResetLevel1=0; % Change if necessary
% Time interval (in samples) after the plato of the reset pulses where merge interpolation is wrong 
ResetMergeTail=5000; 

if ischar(FileName)
tic;     
    if strcmp(FileName(end-3:end),'.dat');
        FileName1=FileName;
        FileName2=[FileName(1:end-4),'2',FileName(end-3:end)];
        FileName3=[FileName(1:end-4),'3',FileName(end-3:end)];
        FileName4=[FileName(1:end-4),'4',FileName(end-3:end)];
    else
        FileName1=[FileName,'.dat'];
        FileName2=[FileName,'2','.dat'];
        FileName3=[FileName,'3','.dat'];
        FileName4=[FileName,'4','.dat'];
    end;

    fid=fopen(FileName1);f1=fread(fid,inf,'single');fclose(fid);
    fid=fopen(FileName2);f2=fread(fid,inf,'single');fclose(fid);
    fid=fopen(FileName3);f3=fread(fid,inf,'single');fclose(fid);
    fid=fopen(FileName4);f4=fread(fid,inf,'single');fclose(fid);
    MergeOn=true; 
Time=toc;
disp(['Reading files: ', num2str(Time),' c']); 
else
   if length(FileName(1,:))==4;  
      f1=FileName(:,1);     f2=FileName(:,2);    f3=FileName(:,3);    f4=FileName(:,4); 
      MaxTrek=max([max(f1),max(f2),max(f3),max(f4)]);      
      MinTrek=min([min(f1),min(f2),min(f3),min(f4)]);            
      MergeOn=true; 
   else
      f1=FileName(:,1); MergeOn=false;    % take only the first column
      MaxTrek=max(f1);      
      MinTrek=min(f1);
      ResetLevel1=MinTrek+100; 
      f2=[];f3=[];f4=[];
   end; 
end;
fN=length(f1);


% Search for reset pulses in trek#1 assuming 
ResetPlatoInd=find(f1<=ResetLevel1); 
ResetPlatoIndDiff=diff(ResetPlatoInd); 
ResetPlatoIndDiff=[ResetPlatoIndDiff;ResetPlatoIndDiff(end)]; 
ResetPlatoIndN=length(ResetPlatoInd); 
i=1; 
ResetMergeTailInd=[]; 
while ResetPlatoIndN>0
    ind=find(ResetPlatoIndDiff==1,1,'first');
    if isempty(ind) ind=length(ResetPlatoInd); end;
    ResetPlatoInd(1:ind)=[]; ResetPlatoIndDiff(1:ind)=[];
    ResetPlatoIndN=length(ResetPlatoInd);
    if ResetPlatoIndN>0
        ind=find(ResetPlatoIndDiff>1,1,'first');
        if isempty(ind); ind=length(ResetPlatoInd); end;
        if ind>=ResetBottom1;
            ResetPulseInd(i,1)=ResetPlatoInd(1);    % front of reset pulses
            ResetPulseInd(i,2)=ResetPlatoInd(ind);  % end oof the playo of reset pulses
            ResetMergeTailInd=[ResetMergeTailInd;ResetPulseInd(i,2)+[0:ResetMergeTail]']; 
            i=i+1; 
        end;
        ResetPlatoInd(1:ind)=[]; ResetPlatoIndDiff(1:ind)=[];
        ResetPlatoIndN=length(ResetPlatoInd);
    end;
end;



NoiseInd=[1:StartPlasma/Tact*1e6,EndPlasma/Tact*1e6:fN]; 
%if nargin<2; NoiseSet1=NoiseFitMK(f1,1,1); title('f1');  end;
%if nargin<3; NoiseSet2=NoiseFitMK(f2,1,1); title('f2');  end;
%if nargin<4; NoiseSet3=NoiseFitMK(f3,1,1); title('f3');  end;
%if nargin<5; NoiseSet4=NoiseFitMK(f4,1,1); title('f4');  end;

NoiseSet1=NormalNoise(f1,NoiseInd);
NoiseInd=NoiseSet1.Ind;
if MergeOn
    NoiseSet2=NormalNoise(f2,NoiseSet1.Ind);
    NoiseSet3=NormalNoise(f3,NoiseSet2.Ind);
    NoiseSet4=NormalNoise(f4,NoiseSet3.Ind);
    NoiseInd=NoiseSet4.Ind;
end;

NoiseBool=false(size(f1));
NoiseBool(NoiseInd)=true;
NoiseBool(ResetMergeTailInd)=false;



if MergeOn
    tic;

    P21Noise=polyfit(f2(NoiseBool)-NoiseSet2.MeanVal,f1(NoiseBool)-NoiseSet1.MeanVal,1);
    P31Noise=polyfit(f3(NoiseBool)-NoiseSet3.MeanVal,f1(NoiseBool)-NoiseSet1.MeanVal,1);
    P41Noise=polyfit(f4(NoiseBool)-NoiseSet4.MeanVal,f1(NoiseBool)-NoiseSet1.MeanVal,1);
    P32Noise=polyfit(f3(NoiseBool)-NoiseSet3.MeanVal,f2(NoiseBool)-NoiseSet2.MeanVal,1);
    P42Noise=polyfit(f4(NoiseBool)-NoiseSet4.MeanVal,f2(NoiseBool)-NoiseSet2.MeanVal,1);
    P43Noise=polyfit(f4(NoiseBool)-NoiseSet4.MeanVal,f3(NoiseBool)-NoiseSet3.MeanVal,1);

    AboveNoiseBool=(f1>NoiseSet1.MeanVal+ExcessNoise*NoiseSet1.StdVal)&...
        (f2>NoiseSet2.MeanVal+ExcessNoise*NoiseSet2.StdVal)&...
        (f3>NoiseSet3.MeanVal+ExcessNoise*NoiseSet3.StdVal)&...
        (f4>NoiseSet4.MeanVal+ExcessNoise*NoiseSet4.StdVal);
    UnderNoiseBool=(f1<NoiseSet1.MeanVal-ExcessNoise*NoiseSet1.StdVal); %&...
    %                (f2<NoiseSet2.MeanVal-ExcessNoise*NoiseSet2.StdVal)&...
    %                (f3<NoiseSet3.MeanVal-ExcessNoise*NoiseSet3.StdVal)&...
    %                (f4<NoiseSet4.MeanVal-ExcessNoise*NoiseSet4.StdVal);
    UpperRangeBool=(f1<UpperRange)&(f2<UpperRange)&(f3<UpperRange)&(f4<UpperRange);

    % three ranges of signals:
    % noise range:

    NoiseBool=NoiseBool&not(AboveNoiseBool)&not(UnderNoiseBool);
    % Positive signals range:
    SignalBool=true(size(f1));
    SignalBool(NoiseSet1.Ind)=false;
    SignalBool(ResetMergeTailInd)=false;
    LowerLevel=max([min(f1(SignalBool)),min(f2(SignalBool)),min(f3(SignalBool)),min(f4(SignalBool))]); % the level of reset pulses
    SignalBool=SignalBool&AboveNoiseBool&UpperRangeBool;
    % Negative signals (reset pulses) range:
    LowerRangeBool=(f1>LowerLevel)&(f2>LowerLevel)&(f3>LowerLevel)&(f4>LowerLevel);
    ResetBool=true(size(f1));
    ResetBool(NoiseSet1.Ind)=false;
    ResetBool(ResetMergeTailInd)=false;
    ResetBool=ResetBool&UnderNoiseBool&LowerRangeBool;

    MergeInd=find(SignalBool);
    %MergeIndN=length(MergeInd);
    % PolyN=50;
    % MergeFitN=fix(MergeIndN/PolyN);
    % for i=1:1000; %MergeFitN;
    %     k=PolyN*[i:(i+1)]-PolyN+1;
    %     P21N(i,1:2)=polyfit(f2(MergeInd(k))-NoiseSet2.MeanVal,f1(MergeInd(k))-NoiseSet1.MeanVal,1);
    %     P21N(i,3)=min(f1(MergeInd(k)));  P21N(i,4)=max(f1(MergeInd(k)));
    %
    %     P31N(i,1:2)=polyfit(f3(MergeInd(k))-NoiseSet3.MeanVal,f1(MergeInd(k))-NoiseSet1.MeanVal,1);
    %     P31N(i,3)=min(f1(MergeInd(k)));  P31N(i,4)=max(f1(MergeInd(k)));
    %
    %     P41N(i,1:2)=polyfit(f4(MergeInd(k))-NoiseSet4.MeanVal,f1(MergeInd(k))-NoiseSet1.MeanVal,1);
    %     P41N(i,3)=min(f1(MergeInd(k)));  P41N(i,4)=max(f1(MergeInd(k)));
    %
    %     P32N(i,1:2)=polyfit(f3(MergeInd(k))-NoiseSet3.MeanVal,f2(MergeInd(k))-NoiseSet2.MeanVal,1);
    %     P32N(i,3)=min(f2(MergeInd(k)));  P42N(i,4)=max(f2(MergeInd(k)));
    %
    %     P42N(i,1:2)=polyfit(f4(MergeInd(k))-NoiseSet4.MeanVal,f2(MergeInd(k))-NoiseSet2.MeanVal,1);
    %     P42N(i,3)=min(f2(MergeInd(k)));  P42N(i,4)=max(f2(MergeInd(k)));
    %
    %     P43N(i,1:2)=polyfit(f4(MergeInd(k))-NoiseSet4.MeanVal,f3(MergeInd(k))-NoiseSet3.MeanVal,1);
    %     P43N(i,3)=min(f3(MergeInd(k)));  P43N(i,4)=max(f3(MergeInd(k)));
    % end;
    % Bool21=(abs(P21N(:,2))<1000&P21N(:,1)<10&P21N(:,1)>0.1);
    % Bool31=(abs(P31N(:,2))<1000&P31N(:,1)<20&P31N(:,1)>0.1);
    % Bool41=(abs(P41N(:,2))<1000&P41N(:,1)<99&P41N(:,1)>0.1);
    % Bool32=(abs(P32N(:,2))<1000&P32N(:,1)<10&P32N(:,1)>0.1);
    % Bool42=(abs(P42N(:,2))<1000&P42N(:,1)<50&P42N(:,1)>0.1);
    % Bool43=(abs(P43N(:,2))<1000&P43N(:,1)<50&P43N(:,3)>0.1);



    % polyfit of positive signals

    P21Merge=polyfit(f2(MergeInd)-NoiseSet2.MeanVal,f1(MergeInd)-NoiseSet1.MeanVal,1);
    P12Merge=polyfit(f1(MergeInd)-NoiseSet1.MeanVal,f2(MergeInd)-NoiseSet2.MeanVal,1);
    P31Merge=polyfit(f3(MergeInd)-NoiseSet3.MeanVal,f1(MergeInd)-NoiseSet1.MeanVal,1);
    P41Merge=polyfit(f4(MergeInd)-NoiseSet4.MeanVal,f1(MergeInd)-NoiseSet1.MeanVal,1);
    P32Merge=polyfit(f3(MergeInd)-NoiseSet3.MeanVal,f2(MergeInd)-NoiseSet2.MeanVal,1);
    P42Merge=polyfit(f4(MergeInd)-NoiseSet4.MeanVal,f2(MergeInd)-NoiseSet2.MeanVal,1);
    P43Merge=polyfit(f4(MergeInd)-NoiseSet4.MeanVal,f3(MergeInd)-NoiseSet3.MeanVal,1);
    % polyfit of negative signals
    MergeInd=find(ResetBool);
    M21Merge=polyfit(f2(MergeInd)-NoiseSet2.MeanVal,f1(MergeInd)-NoiseSet1.MeanVal,1);
    M31Merge=polyfit(f3(MergeInd)-NoiseSet3.MeanVal,f1(MergeInd)-NoiseSet1.MeanVal,1);
    M41Merge=polyfit(f4(MergeInd)-NoiseSet4.MeanVal,f1(MergeInd)-NoiseSet1.MeanVal,1);
    M32Merge=polyfit(f3(MergeInd)-NoiseSet3.MeanVal,f2(MergeInd)-NoiseSet2.MeanVal,1);
    M42Merge=polyfit(f4(MergeInd)-NoiseSet4.MeanVal,f2(MergeInd)-NoiseSet2.MeanVal,1);
    M43Merge=polyfit(f4(MergeInd)-NoiseSet4.MeanVal,f3(MergeInd)-NoiseSet3.MeanVal,1);
    % polyfit of noise signals
    MergeInd=find(NoiseBool);
    N21Merge=polyfit(f2(MergeInd)-NoiseSet2.MeanVal,f1(MergeInd)-NoiseSet1.MeanVal,1);
    N31Merge=polyfit(f3(MergeInd)-NoiseSet3.MeanVal,f1(MergeInd)-NoiseSet1.MeanVal,1);
    N41Merge=polyfit(f4(MergeInd)-NoiseSet4.MeanVal,f1(MergeInd)-NoiseSet1.MeanVal,1);
    N32Merge=polyfit(f3(MergeInd)-NoiseSet3.MeanVal,f2(MergeInd)-NoiseSet2.MeanVal,1);
    N42Merge=polyfit(f4(MergeInd)-NoiseSet4.MeanVal,f2(MergeInd)-NoiseSet2.MeanVal,1);
    N43Merge=polyfit(f4(MergeInd)-NoiseSet4.MeanVal,f3(MergeInd)-NoiseSet3.MeanVal,1);



    %f(:,2)=polyval(P21Merge,f2-NoiseSet2.MeanVal)+NoiseSet1.MeanVal; f(f(:,2)<LowerLevel,2)=LowerLevel;
    %f(:,3)=polyval(P31Merge,f3-NoiseSet3.MeanVal)+NoiseSet1.MeanVal; f(f(:,3)<LowerLevel,3)=LowerLevel;
    %f(:,4)=polyval(P41Merge,f4-NoiseSet4.MeanVal)+NoiseSet1.MeanVal; f(f(:,4)<LowerLevel,4)=LowerLevel;

    % fm=repmat(f1,[1,4]);
    % PositiveBool=AboveNoiseBool&UpperRangeBool;
    % fm(PositiveBool,2)=polyval(P21Merge,f2(PositiveBool)-NoiseSet2.MeanVal)+NoiseSet1.MeanVal;
    % fm(PositiveBool,3)=polyval(P31Merge,f3(PositiveBool)-NoiseSet3.MeanVal)+NoiseSet1.MeanVal;
    % fm(PositiveBool,4)=polyval(P41Merge,f4(PositiveBool)-NoiseSet4.MeanVal)+NoiseSet1.MeanVal;
    % NegativeBool=UnderNoiseBool&LowerRangeBool;
    % fm(NegativeBool,2) =polyval(M21Merge,f2(NegativeBool)-NoiseSet2.MeanVal)+NoiseSet1.MeanVal;
    % fm(NegativeBool,3) =polyval(M31Merge,f3(NegativeBool)-NoiseSet3.MeanVal)+NoiseSet1.MeanVal;
    % fm(NegativeBool,4) =polyval(M41Merge,f4(NegativeBool)-NoiseSet4.MeanVal)+NoiseSet1.MeanVal;
    % NoiseBool=not(AboveNoiseBool)&not(UnderNoiseBool);
    % fm(NoiseBool,2) =polyval(N21Merge,f2(NoiseBool)-NoiseSet2.MeanVal)+NoiseSet1.MeanVal;
    % fm(NoiseBool,3) =polyval(N31Merge,f3(NoiseBool)-NoiseSet3.MeanVal)+NoiseSet1.MeanVal;
    % fm(NoiseBool,4) =polyval(N41Merge,f4(NoiseBool)-NoiseSet4.MeanVal)+NoiseSet1.MeanVal;
    % OverBool=(f1==UpperRange);
    % fm(OverBool,1)=fm(OverBool,2);
    % OverBool=(f2==UpperRange);
    % fm(OverBool,1)=fm(OverBool,3); fm(OverBool,2)=fm(OverBool,3);
    % OverBool=(f3==UpperRange);
    % fm(OverBool,1)=fm(OverBool,4); fm(OverBool,2)=fm(OverBool,4); fm(OverBool,3)=fm(OverBool,4);
    % for i=1:4; fm(fm(:,i)<LowerLevel,i)=LowerLevel; end;
    
    switch BaseTrek
        case 1
            f=f1;
            OverBool=(f1==UpperRange);
            f(OverBool)=polyval(P21Merge,f2(OverBool)-NoiseSet2.MeanVal)+NoiseSet1.MeanVal;
            OverBool=(f1==0);
            f(OverBool)=polyval(P21Merge,f2(OverBool)-NoiseSet2.MeanVal)+NoiseSet1.MeanVal;

            OverBool=(f2==UpperRange);
            f(OverBool)=polyval(P31Merge,f3(OverBool)-NoiseSet3.MeanVal)+NoiseSet1.MeanVal;
            OverBool=(f2==0);
            f(OverBool)=polyval(P31Merge,f3(OverBool)-NoiseSet3.MeanVal)+NoiseSet1.MeanVal;

            OverBool=(f3==UpperRange);
            f(OverBool)=polyval(P41Merge,f4(OverBool)-NoiseSet4.MeanVal)+NoiseSet1.MeanVal;
            OverBool=(f3==0);
            f(OverBool)=polyval(P41Merge,f4(OverBool)-NoiseSet4.MeanVal)+NoiseSet1.MeanVal;
            f=f-NoiseSet1.MeanVal;
            NoiseSet=NoiseSet1;
        case 2
            f=f2;
            OverBool=(f2==UpperRange);
            f(OverBool)=polyval(P32Merge,f3(OverBool)-NoiseSet3.MeanVal)+NoiseSet2.MeanVal;
            OverBool=(f2==0);
            f(OverBool)=polyval(P32Merge,f3(OverBool)-NoiseSet4.MeanVal)+NoiseSet2.MeanVal;

            OverBool=(f3==UpperRange);
            f(OverBool)=polyval(P42Merge,f4(OverBool)-NoiseSet4.MeanVal)+NoiseSet2.MeanVal;
            OverBool=(f3==0);
            f(OverBool)=polyval(P42Merge,f4(OverBool)-NoiseSet4.MeanVal)+NoiseSet2.MeanVal;
            f=f-NoiseSet2.MeanVal;
            NoiseSet=NoiseSet2;            
    end;
    Time=toc;
    disp(['Merging treks: ', num2str(Time),' c']);
else
    f=f1;
    NoiseSet=NoiseSet1;
end;



% Search for reset pulses in f(:,1). Assume flat plato of the reset pulse
ResetLevel=min(f)+1000; 
ResetPlatoDur=100;
ResetPlatoInd=find(f<=ResetLevel); 
ResetPlatoIndDiff=diff(ResetPlatoInd); 
ResetPlatoIndDiff=[ResetPlatoIndDiff;ResetPlatoIndDiff(end)]; 
ResetPlatoIndN=length(ResetPlatoInd); 
i=1; 
ResetInd=[];     ResetPulseInd=[]; 
while ResetPlatoIndN>0
    ind=find(ResetPlatoIndDiff==1,1,'first');
    if isempty(ind) ind=length(ResetPlatoInd); end;
    ResetPlatoInd(1:ind)=[]; ResetPlatoIndDiff(1:ind)=[];
    ResetPlatoIndN=length(ResetPlatoInd);
    if ResetPlatoIndN>0
        ind=find(ResetPlatoIndDiff>1,1,'first');
        if isempty(ind); ind=length(ResetPlatoInd); end;
        if ind>=ResetPlatoDur;
            ResetPulseInd(i,1)=ResetPlatoInd(1);    % front of reset pulses
            ResetPulseInd(i,2)=ResetPlatoInd(ind);  % end oof the playo of reset pulses
            ResetInd=[ResetInd;ResetPulseInd(i,1)+[0:ResetMergeTail]']; 
            i=i+1; 
        end;
        ResetPlatoInd(1:ind)=[]; ResetPlatoIndDiff(1:ind)=[];
        ResetPlatoIndN=length(ResetPlatoInd);
    end;
end;

tic; 

[f,FrontInd,ThrehsholdFront,ResetInd]=FrontDetector(f,NoiseSet,ResetInd);

Time=toc; disp(['Searching pulses: ', num2str(Time),' c']); 

if length(FrontInd(1,:))==1; FrontInd(:,2)=FrontInd(:,1); end;
FrontIndN=length(FrontInd);
HistPulseTimes=HistOnNetMK(FrontInd(:,1)*Tact*1e-6,StartPlasma:EndPlasma); 

TailSlope=0;
StartInd0=FrontInd(i,1)+FlatStartDelay;
FrontInd(:,4:7)=0;
for i=1:FrontIndN-1
    StartInd1=FrontInd(i+1,1)+FlatStartDelay;
    StartLevel=mean(f(StartInd0,1));
    if FrontInd(i,1)==FrontInd(i,2)
        FrontLevel=f(FrontInd(i,1),1);
    else
        FrontIndNearest=[fix(FrontInd(i,2)),ceil(FrontInd(i,2))];
        FrontLevel=interp1(FrontIndNearest,f(FrontIndNearest,1),FrontInd(i,2));
    end;
    TopInd=FrontInd(i,1)+FlatTopDelay;
    TopInd(TopInd>StartInd1(end))=[];
    if isempty(TopInd)
        TopLevel=StartLevel+(FrontLevel-StartLevel)/FrontLevelNorm;
        FrontInd(i,7)=1;
    else
        TopLevel=mean(f(TopInd,1));
    end;
    FrontInd(i,4)=StartLevel;
    FrontInd(i,5)=FrontLevel;
    FrontInd(i,6)=TopLevel;
    StartInd0=StartInd1;
end;
i=FrontIndN;
FrontIndNearest=[fix(FrontInd(i,2)),ceil(FrontInd(i,2))];
FrontLevel=interp1(FrontIndNearest,f(FrontIndNearest,1),FrontInd(i,2));
TopInd=FrontInd(i,1)+FlatTopDelay;
TopLevel=mean(f(TopInd,1));
FrontInd(i,4)=StartLevel;
FrontInd(i,5)=FrontLevel;
FrontInd(i,6)=TopLevel;
 

Fronts=FrontInd(:,6)-FrontInd(:,4);
FrontInd(Fronts<0,:)=[]; 
Fronts(Fronts<0)=[]; 
DiffFrontInd=[0;diff(FrontInd(:,1))];

HistDiffFrontInd=HistOnNetMK(DiffFrontInd,0.5+1:5:1000);
MaxCounts=1000;
HistFrontAll=HistOnNetMK(Fronts,0:round(ThrehsholdFront)/4:MaxCounts);

Fronts1=Fronts(FrontInd(:,1)>=TimeIntervals(1,1)/Tact*1e6&FrontInd(:,1)<=TimeIntervals(1,2)/Tact*1e6,:); 
Fronts2=Fronts(FrontInd(:,1)>=TimeIntervals(2,1)/Tact*1e6&FrontInd(:,1)<=TimeIntervals(2,2)/Tact*1e6,:); 
Fronts3=Fronts(FrontInd(:,1)>=TimeIntervals(3,1)/Tact*1e6&FrontInd(:,1)<=TimeIntervals(3,2)/Tact*1e6,:); 

HistFront1=HistOnNetMK(Fronts1,0:round(ThrehsholdFront)/4:MaxCounts);
HistFront2=HistOnNetMK(Fronts2,0:round(ThrehsholdFront)/4:MaxCounts);
HistFront3=HistOnNetMK(Fronts3,0:round(ThrehsholdFront)/4:MaxCounts);


figure; subplot(2,2,1:2);  
errorbar(HistPulseTimes(:,1),HistPulseTimes(:,2),HistPulseTimes(:,3),'-ro','Linewidth',2); grid on;
xlabel('time, ms'); ylabel('Peaks/ms'); 
axis([StartPlasma,EndPlasma,0,1.1*max(HistPulseTimes(:,2)+HistPulseTimes(:,3))]); 
if ischar(FileName); title(FileName); end; 

subplot(2,2,3); hold on; 
errorbar(HistFrontAll(:,1),HistFrontAll(:,2),HistFrontAll(:,3),'k','Linewidth',2); grid on;
plot(HistFront1(:,1),HistFront1(:,2),'-b>','Linewidth',2); grid on;
plot(HistFront2(:,1),HistFront2(:,2),'-ro','Linewidth',2); grid on;
plot(HistFront3(:,1),HistFront3(:,2),'-gv','Linewidth',2); grid on;
legend('All','1','2','3');

set(gca,'YScale','log'); xlabel('Energy,counts'); ylabel('numbers');
axis([0,MaxCounts,1,1.1*max(HistFrontAll(:,2)+HistFrontAll(:,3))]); 

subplot(2,2,4); hold on; 
plot(HistDiffFrontInd(:,1),HistDiffFrontInd(:,2),'b','Linewidth',2); grid on;
axis([0,1000,1,1.1*max(HistDiffFrontInd(:,2)+HistDiffFrontInd(:,3))]);
set(gca,'YScale','log'); xlabel('Time,counts'); ylabel('numbers');

clear global MinimalGap

% k=find(f(1:FrontInd(1),3)==0,1,'last');
% m=find(f(FrontInd(1):FrontInd(2),3)==0,1,'first')+FrontInd(1);
% while isempty(m)
%     if f(FrontInd(2),3)<f(FrontInd(1),3); FrontInd(2); else FrontInd(1)=[]; end;
%     m=find(f(FrontInd(1):FrontInd(2),3)==0,1,'first');
% end;
% f(k:m,3)=f(k:m,3)*f(FrontInd(1),1)/f(FrontInd(1),3);
% i=2;
% while i<length(FrontInd)
%     k=find(f(FrontInd(i-1):FrontInd(i),3)==0,1,'last')+FrontInd(i-1);
%     m=find(f(FrontInd(i):FrontInd(i+1),3)==0,1,'first')+FrontInd(i);
%     while isempty(m)
%         if f(FrontInd(i+1),3)<f(FrontInd(i),3); 
%            FrontInd(i+1)=[]; else FrontInd(i)=[]; end;
%         m=find(f(FrontInd(i):FrontInd(i+1),3)==0,1,'first')+FrontInd(i);
%     end;
%     f(k:m,3)=f(k:m,3)*f(FrontInd(i),1)/f(FrontInd(i),3); 
%     i=i+1;
% end;
% PeakN=length(FrontInd);
% f(f(:,3)>max(f(:,1)),3)=max(f(:,1));

%================================================

function NoiseSet=NormalNoise(f,NoiseInd);
NoiseTrek=f(NoiseInd);
MeanNoiseTrek0=mean(NoiseTrek);
StdNoiseTrek0=std(NoiseTrek);
StdRatio=2;
while abs(StdRatio-1)>0.05; 
    NoiseInd(abs(NoiseTrek-MeanNoiseTrek0)>4*StdNoiseTrek0)=[];
    NoiseTrek=f(NoiseInd);
    StdNoiseTrek=std(NoiseTrek);  
    MeanNoiseTrek=mean(NoiseTrek);
    StdRatio=StdNoiseTrek/StdNoiseTrek0;
    StdNoiseTrek0=StdNoiseTrek;
    MeanNoiseTrek0=MeanNoiseTrek;
end;
NoiseSet.MeanVal=MeanNoiseTrek;
NoiseSet.StdVal=StdNoiseTrek;
NoiseSet.Ind=NoiseInd; 

function Hist=HistOnNetMK(A,net)
netSize=size(net); 
if netSize(2)>netSize(1) net=net'; end;  
Hist=zeros(numel(net)-1,3);
Hist(:,1)=(net(1:end-1)+net(2:end))/2;
diffnet=diff(net);
A=sort(A); A(A<net(1))=[]; 
ind=find(A>net(1)&A<=net(2));
Hist(1,2)=length(ind); 
if Hist(1,2)>0; ind=ind(end)+1; else ind=1; end;  
for i=2:numel(net)-1
    N=find(A(ind:end)<=net(i+1),1,'last');
    if not(isempty(N)); Hist(i,2)=N; ind=ind+N;   end; 
end;
Hist(:,2)=Hist(:,2)./diffnet;
[Nmax,Imax]=max(Hist(:,2)); 
k=(net(Imax+1)-net(Imax));
Hist(:,2)=Hist(:,2)*k;
Hist(:,3)=sqrt(Hist(:,2)); 


function [f,FrontInd,ThrehsholdFront,ResetInd]=FrontDetector(f,NoiseSet,ResetInd);
% detects fronts of pulses from the shape of their derivatives
% Normalized derivative of the front of standard pulse at 20 ns tact

global MinimalGap;

Kernel=[0,0.0023,0.0067,0.0098,0.013,0.0192,0.0301,0.0444,...
        0.0574,0.0649,0.0685,0.0775,0.103,0.1486,0.2047,0.2488,...
        0.2598,0.2495,0.2708,0.3804,0.5952,0.8572,1,0.8343,0.4174,0.0764,0.0089,0.0008,0]';
Kernel=Kernel/sum(Kernel); 
DelayStart=-16; % Delay of the convolved pulse from the pulse start
DelayTop=14; % Delay of the convolved pulse from the pulse top

DelayMaxDiff=-7; % Delay of the convolved pulse from the maximum of diff(pulse) 


dSN=length(Kernel);  % must be odd!
fN=length(f);

NoiseBool=false(size(f));
NoiseBool(NoiseSet.Ind)=true;
%NoiseBool(NoiseSet.ExcludeNoiseInd)=false;

DiffNoiseBool=diff(NoiseBool);
Front=find(DiffNoiseBool==1);  FrontN=length(Front);
Back=find(DiffNoiseBool==-1);  BackN=length(Back);
for i=1:FrontN
    x1=Front(i); x2=min(Front(i)+(dSN-1)/2,fN);     
    NoiseBool(x1:x2)=false;        
end;
for i=1:BackN
    x1=max(Back(i)-(dSN-3)/2,1); x2=Back(i);  
    NoiseBool(x1:x2)=false; 
end;

ResetBool=false(size(f));
ResetBool(ResetInd)=true;
DiffResetBool=diff(ResetBool);
Front=find(DiffResetBool==1);  FrontN=length(Front);
Back=find(DiffResetBool==-1);  BackN=length(Back);
for i=1:FrontN
    x1=Front(i); x2=min(Front(i)+(dSN-1)/2,fN);     
    ResetBool(x1:x2)=false;        
end;
for i=1:BackN
    x1=max(Back(i)-(dSN-3)/2,1); x2=Back(i);  
    ResetBool(x1:x2)=false; 
end;

SignalBool=true(size(f));
SignalBool(NoiseSet.Ind)=false;
SignalBool(ResetInd)=false;
DiffSignalBool=diff(SignalBool);
Front=find(DiffSignalBool==1);  FrontN=length(Front);
Back=find(DiffSignalBool==-1);  BackN=length(Back);
for i=1:FrontN
    x1=Front(i); x2=min(Front(i)+(dSN-1)/2,fN);     
    SignalBool(x1:x2)=false;        
end;
for i=1:BackN
    x1=max(Back(i)-(dSN-3)/2,1); x2=Back(i);  
    SignalBool(x1:x2)=false; 
end;

f(:,2)=[0;diff(f)]; f(:,3)=0;


ConvF=conv(Kernel,f(:,2));
ConvF(1:(dSN-1)/2)=[]; ConvF(end-(dSN-1)/2+1:end)=[]; 
ConvF=circshift(ConvF,DelayMaxDiff); 
% ConvF(ConvF>0)=ConvF(ConvF>0).^(1/3);
% ConvF(ConvF<0)=-(-ConvF(ConvF<0)).^(1/3);
StdConvF=std(ConvF(NoiseBool)); 
StdConvF=std(ConvF(NoiseBool&abs(ConvF)<3*StdConvF));
NoiseBool=NoiseBool&abs(ConvF)<5*StdConvF;

f(:,3)=ConvF/StdConvF*NoiseSet.StdVal;
clear ConvF;

fRight=circshift(f(:,3),1); fLeft=circshift(f(:,3),-1);
PeakBool  =f(:,3)>=fRight&f(:,3)>fLeft;

% PeakInd=find(PeakBool);  PeakN=length(find(PeakBool));
% ValleyBool=f(:,3)<fRight&f(:,3)<=fLeft;
% ValleyN=length(find(ValleyBool)); ValleyInd=find(ValleyBool); 
% PVN=min(PeakN,ValleyN); 
% if PeakBool(1)>ValleyBool(1);  Delta1= PeakInd(2:PVN)-ValleyInd(1:PVN-1); end; 


PeakNoise=f(PeakBool&NoiseBool,3);
MeanPeakNoise=mean(PeakNoise);
StdPeakNoise=std(PeakNoise);

PeakSignalBool=PeakBool&SignalBool;
PeakSignal=f(PeakSignalBool,3);

MeanPeakSignal=mean(PeakSignal);
StdPeakSignal=std(PeakSignal);

HistRange=[-0.5:0.01:1.005]*(MeanPeakNoise+5*StdPeakNoise);
HistPeakNoise=HistOnNetMK(PeakNoise,HistRange);

HistPeakSignal=HistOnNetMK(PeakSignal,HistRange);
HistPeakSignal(:,3)=HistPeakSignal(:,3)*sum(HistPeakNoise(:,2))/sum(HistPeakSignal(:,2));
HistPeakSignal(:,2)=HistPeakSignal(:,2)*sum(HistPeakNoise(:,2))/sum(HistPeakSignal(:,2));

figure;
plot(HistPeakNoise(:,1),HistPeakNoise(:,2),'Linewidth',2); hold on;
plot(HistPeakSignal(:,1),HistPeakSignal(:,2),'r','Linewidth',2); grid on;
ThrehsholdFrontInd=find(HistPeakSignal(:,1)>MeanPeakNoise&HistPeakSignal(:,2)>1.5*HistPeakNoise(:,2),3,'first');
ThrehsholdFront=HistPeakSignal(ThrehsholdFrontInd(end),1);
plot(ThrehsholdFront*[1,1],[1,max(HistPeakNoise(:,2))],'r','Linewidth',2);
set(gca,'YScale','log');
xlabel('Maxima,counts'); ylabel('numbers');

FrontBool=PeakSignalBool&f(:,3)>ThrehsholdFront&f(:,1)>NoiseSet.StdVal&f(:,2)>0;
FrontInd=find(FrontBool);
FrontIndN=length(FrontInd);

Gap=diff(FrontInd(:,1));
ShortGap=[]; 
for i=1:FrontIndN-1
     if Gap(i)<MinimalGap
        [Min,Ind]=min(f(FrontInd(i:i+1),3)); 
        ShortGap=[ShortGap;i+Ind-1];
     end; 
end;     
FrontInd(ShortGap)=[]; 
FrontIndN=length(FrontInd);
FrontInd(:,2)=FrontInd; FrontInd(:,3)=f(FrontInd(:,1),3);
for i=1:FrontIndN
    xRange=FrontInd(i)+[-2:2]';
    P=polyfit([-2:2]',f(xRange,3),2);
    dx=-P(2)/P(1)/2;
    if abs(dx)<=1
        FrontInd(i,2)=FrontInd(i)+dx;
        FrontInd(i,3)=polyval(P,dx);
    end;
end;




