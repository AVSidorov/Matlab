function [f,FrontInd,ResetPulseInd,f1,f2,f3,f4]=TrekSDD2SpectraSXR(FileName,eVperCounts,ThickBe,IntervalSXR); 
% SXR spectra from SDD treks
% FileName - 1. the name of the first file from a set of 4 trek files: 
%                      '01sxr' or '01sxr.dat'
%            2. concatination of 4 treks read out from trek files:  [f1,f2,f3,f4]; 
%            3. Merged trek f  
% eVperCounts - eV/Counts
% ThickBe - thecknesss of berillium foil, um
% IntervalSXR - [t1,t2], time interval for SXR signals, ms

 global MinimalGap UpperRange NoiseSet1 NoiseSet2 NoiseSet3 NoiseSet4 NoiseBool ResetBool SignalBool ExcessNoise...
                   ResetPulseInd ResetMergeTailInd OverloadPulseTopInd BaseTrek ...
        StandardPulse StandardConvPulse Tact StartPlasma EndPlasma Kernel1 Kernel2 Kern1N Kern2N K1 K2 K ShiftKernel1 ShiftKernel2 TailCoeff TailSmoothN...
        SmoothN ConvPeakAmplitude ConvPeakArea TopDelay FlatTop StartDelay FlatStart;

if nargin<2; eVperCounts=1; end;
if nargin<3; ThickBe=0; end; 
BaseTrek=1;     % the number of base trek. Normally BaseTrek=1, but if f1 is noisy then BaseTrek=2; 
StandardPulseFile='D:\MK\!SCN\2013\Ioffe\SXR\StandardPulseSet.mat'; 
ExcessNoise=3; 
UpperRange=4095;
TopDelay= 12; %(21); % delay of the pulse top from the maximum of the diff(Pulse), tacts                                          
StartDelay=-5; %(-9); % delay of the pulse start from the maximum of the diff(Pulse), tacts
FlatStart=[-8:-3];
FlatTop=[15:30]; 
FrontLevelNorm=0.3127; 
MinimalGap=2;

ReadOk=ReadoutStandardPulseSet(StandardPulseFile); 
if not(ReadOk);  error('Wrong kernels');  end; 



% Minimal duration (in tacts) of the flat bottom of reset pulses in trek#1 (the highest sensitivity)
ResetBottom1=200; % Typically it is 1000, but sometimes less than 300
% The level of the reset pulse at which its duration > ResetBottom1
ResetLevel1=0; % Change if necessary
% Time interval (in tacts) after the plato of the reset pulses where merge interpolation is wrong 
ResetMergeTail=5000; 
ResetTail=2000; 

% overloaded pulse level in f4:  
OverloadMergeLevel=3000; 
% Do not merge channels after high pulses for : 
OverloadPulsesMergeTail=3000; 

[f1,f2,f3,f4,MergeOn]=ReadoutTrekFiles(FileName);
%fN=length(f1);

% % file 15:
% IndEnd=261430;  IndStart=500;
% f1(IndEnd:end)=[]; f2(IndEnd:end)=[]; f3(IndEnd:end)=[]; f4(IndEnd:end)=[];
% f1(1:IndStart)=[]; f2(1:IndStart)=[]; f3(1:IndStart)=[]; f4(1:IndStart)=[];
% 
% % file 16:
% IndEnd=260700;  IndStart=2500;
% f1(IndEnd:end)=[]; f2(IndEnd:end)=[]; f3(IndEnd:end)=[]; f4(IndEnd:end)=[];
% f1(1:IndStart)=[]; f2(1:IndStart)=[]; f3(1:IndStart)=[]; f4(1:IndStart)=[];
% 
% % file 12:
% IndEnd=256930;  IndStart=0;
% f1(IndEnd:end)=[]; f2(IndEnd:end)=[]; f3(IndEnd:end)=[]; f4(IndEnd:end)=[];
% f1(1:IndStart)=[]; f2(1:IndStart)=[]; f3(1:IndStart)=[]; f4(1:IndStart)=[];


% file 27 (0.312 V)
% IndEnd=262130;  IndStart=5000;
% f1(IndEnd:end)=[]; f2(IndEnd:end)=[]; f3(IndEnd:end)=[]; f4(IndEnd:end)=[];
% f1(1:IndStart)=[]; f2(1:IndStart)=[]; f3(1:IndStart)=[]; f4(1:IndStart)=[];

% file 22 (10 V)
% IndEnd=252000;  IndStart=1600;
% f1(IndEnd:end)=[]; f2(IndEnd:end)=[]; f3(IndEnd:end)=[]; f4(IndEnd:end)=[];
% f1(1:IndStart)=[]; f2(1:IndStart)=[]; f3(1:IndStart)=[]; f4(1:IndStart)=[];

% file 23 (5 V)
% IndEnd=259550;  IndStart=11000;
% f1(IndEnd:end)=[]; f2(IndEnd:end)=[]; f3(IndEnd:end)=[]; f4(IndEnd:end)=[];
% f1(1:IndStart)=[]; f2(1:IndStart)=[]; f3(1:IndStart)=[]; f4(1:IndStart)=[];

% file 24 (2.5 V)
% IndEnd=259300;  IndStart=11000;
% f1(IndEnd:end)=[]; f2(IndEnd:end)=[]; f3(IndEnd:end)=[]; f4(IndEnd:end)=[];
% f1(1:IndStart)=[]; f2(1:IndStart)=[]; f3(1:IndStart)=[];
% f4(1:IndStart)=[];

fN=length(f1);

IndStartPlasma=6000; IndEndPlasma=fN-6000; 

if nargin<4
    StartPlasma=20; % ms - start of plasma discharge
    EndPlasma=50; % ms - end of plasma discharge
 
%     StartPlasma=IndStartPlasma*20e-6;
%     EndPlasma=IndEndPlasma*20e-6;


    TimeIntervals=[[26,30];[31,35];[36,40]];
else
    StartPlasma=IntervalSXR(1);
    EndPlasma=IntervalSXR(2);
    Interval=diff(IntervalSXR);
    TimeIntervals=StartPlasma+Interval*[[0,1/3];[1/3,2/3];[2/3,1]];
end;

NoiseInd=round([1:StartPlasma/Tact*1e6,EndPlasma/Tact*1e6:fN]); 
% NoiseInd=[600:2500]';    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

% Search for reset pulses in trek#1 
ResetPlatoInd=find(f1<=ResetLevel1);
ResetPulseInd=[];
ResetMergeTailInd=[]; 
if not(isempty(ResetPlatoInd))   
ResetPlatoIndDiff=diff(ResetPlatoInd); 
ResetPlatoIndDiff=[ResetPlatoIndDiff;ResetPlatoIndDiff(end)]; 
ResetPlatoIndN=length(ResetPlatoInd); 
i=1; 
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
            ResetPulseInd(i,2)=ResetPlatoInd(ind);  % end of the plato of reset pulses
            ResetPulseInd(i,3)=ResetPlatoInd(ind)+ResetMergeTail; 
            ResetMergeTailInd=[ResetMergeTailInd;ResetPulseInd(i,2)+[0:ResetMergeTail]']; 
            i=i+1; 
        end;
        ResetPlatoInd(1:ind)=[]; ResetPlatoIndDiff(1:ind)=[];
        ResetPlatoIndN=length(ResetPlatoInd);
    end;
end;
end;

% search for tails after overload pulses: 
OverloadPlatoInd=find(f4>=OverloadMergeLevel); 
OverloadPulseTopInd=[];
if not(isempty(OverloadPlatoInd))   
OverloadPlatoIndDiff=diff(OverloadPlatoInd); 
OverloadPlatoIndDiff=[OverloadPlatoIndDiff;OverloadPlatoIndDiff(end)]; 
OverloadPlatoIndN=length(OverloadPlatoInd); 
i=1; 
while OverloadPlatoIndN>0
    ind=find(OverloadPlatoIndDiff==1,1,'first');
    if isempty(ind); ind=length(OverloadPlatoInd); end;
    OverloadPlatoInd(1:ind)=[]; OverloadPlatoIndDiff(1:ind)=[];
    OverloadPlatoIndN=length(OverloadPlatoInd);
    if OverloadPlatoIndN>0
        ind=find(OverloadPlatoIndDiff>1,1,'first');
        if isempty(ind); ind=length(OverloadPlatoInd); end;
        if ind>0;
            OverloadPulseTopInd(i,1)=OverloadPlatoInd(1);    % front of overload pulses
            [Max,Ind]=max(f4(OverloadPlatoInd(1):OverloadPlatoInd(ind)));
            OverloadPulseTopInd(i,2)=OverloadPulseTopInd(i,1)+Ind-1; % index of maximum of overload pulses           
            OverloadPulseTopInd(i,3)=OverloadPlatoInd(ind);  % end of the plato of overload pulses
            OverloadPulseTopInd(i,4)=OverloadPlatoInd(ind)+OverloadPulsesMergeTail; % end of tail after overload pulses 
%            OverloadPulseMergeTailInd=[OverloadPulseMergeTailInd;OverloadPulseTopInd(i,2)+[0:OverloadPulsesMergeTail]']; 
            i=i+1; 
        end;
        OverloadPlatoInd(1:ind)=[]; OverloadPlatoIndDiff(1:ind)=[];
        OverloadPlatoIndN=length(OverloadPlatoInd);
    end;
end;
end;

OverloadPulseTopIndN=size(OverloadPulseTopInd,1); 
if OverloadPulseTopIndN>0; OverloadPulseTopInd(end,3)=min(OverloadPulseTopInd(end,3),fN);  end; 
for i=1:OverloadPulseTopIndN-1;
    OverloadPulseTopInd(i,4)=min(OverloadPulseTopInd(i,4),OverloadPulseTopInd(i+1,1)-10);
end; 




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
[f,NoiseSet]=MergeSignals(f1,f2,f3,f4);
else
    f=f1;
    NoiseSet=NoiseSet1;
end;

fN=length(f);

NoiseBool=false(size(f));
NoiseBool(NoiseSet.Ind)=true;

DiffNoiseBool=diff(NoiseBool);
Front=find(DiffNoiseBool==1);  FrontN=length(Front);
Back=find(DiffNoiseBool==-1);  BackN=length(Back);
for i=1:FrontN
    x1=Front(i); x2=min(Front(i)+(Kern1N-1)/2,fN);     
    NoiseBool(x1:x2)=false;        
end;
for i=1:BackN
    x1=max(Back(i)-(Kern1N-3)/2,1); x2=Back(i);  
    NoiseBool(x1:x2)=false; 
end;

% Search for reset pulses in f(:,1). Assume flat plato of the reset pulse
ResetLevel=min(f)+1000; 
ResetLevel=min(-2000,ResetLevel); 
ResetPlatoDur=100;
ResetFrontDur=21;
ResetPlatoInd=find(f<=ResetLevel); 
if isempty(ResetPlatoInd)
ResetBool=false; ResetInd=[];
else
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
                ResetPulseInd(i,1)=ResetPlatoInd(1)-ResetFrontDur;    % front of reset pulses
                ResetPulseInd(i,2)=ResetPlatoInd(ind);  % end of the plato of reset pulses
                ResetInd=[ResetInd;ResetPulseInd(i,1)+[0:ResetTail]'];
                i=i+1;
            end;
            ResetPlatoInd(1:ind)=[]; ResetPlatoIndDiff(1:ind)=[];
            ResetPlatoIndN=length(ResetPlatoInd);
        end;
    end;

    ResetBool=false(size(f));
    ResetBool(ResetInd)=true;
    DiffResetBool=diff(ResetBool);
    Front=find(DiffResetBool==1);  FrontN=length(Front);
    Back=find(DiffResetBool==-1);  BackN=length(Back);
    for i=1:FrontN
        x2=Front(i); x1=max(Front(i)-(Kern1N-1)/2,1);
        ResetBool(x1:x2)=true;
    end;
    for i=1:BackN
        x2=min(Back(i)+(Kern1N-3)/2,fN); x1=Back(i);
        ResetBool(x1:x2)=true;
    end;
end;

SignalBool=true(size(f));
SignalBool(NoiseSet.Ind)=false;
SignalBool(ResetInd)=false;
DiffSignalBool=diff(SignalBool);
Front=find(DiffSignalBool==1);  FrontN=length(Front);
Back=find(DiffSignalBool==-1);  BackN=length(Back);
for i=1:FrontN
    x1=Front(i); x2=min(Front(i)+(Kern1N-1)/2,fN);     
    SignalBool(x1:x2)=false;        
end;
for i=1:BackN
    x1=max(Back(i)-(Kern1N-3)/2,1); x2=Back(i);  
    SignalBool(x1:x2)=false; 
end;

tic; 

[f,FrontInd,ThrehsholdFront,ResetInd]=FrontDetector(f,NoiseSet,ResetInd,eVperCounts);

Time=toc; disp(['Searching pulses: ', num2str(Time),' s']); 

if length(FrontInd(1,:))==1; FrontInd(:,2)=FrontInd(:,1); end;
FrontIndN=length(FrontInd);
HistPulseTimes=HistOnNetMK(FrontInd(:,1)*Tact*1e-6,StartPlasma:EndPlasma); 

% TailSlope=0;
% StartInd0=FrontInd(i,1)+FlatStart;
% FrontInd(:,4:7)=0;
% for i=1:FrontIndN-1
%     StartInd1=FrontInd(i+1,1)+FlatStart;
%     StartLevel=mean(f(StartInd0,1));
%     if FrontInd(i,1)==FrontInd(i,2)
%         FrontLevel=f(FrontInd(i,1),1);
%     else
%         FrontIndNearest=[fix(FrontInd(i,2)),ceil(FrontInd(i,2))];
%         FrontLevel=interp1(FrontIndNearest,f(FrontIndNearest,1),FrontInd(i,2));
%     end;
%     TopInd=FrontInd(i,1)+FlatTop;
%     TopInd(TopInd>StartInd1(end))=[];
%     if isempty(TopInd)
%         TopLevel=StartLevel+(FrontLevel-StartLevel)/FrontLevelNorm;
%         FrontInd(i,7)=1;
%     else
%         TopLevel=mean(f(TopInd,1));
%     end;
%     FrontInd(i,4)=StartLevel;
%     FrontInd(i,5)=FrontLevel;
%     FrontInd(i,6)=TopLevel;
%     StartInd0=StartInd1;
% end;
% i=FrontIndN;
% FrontIndNearest=[fix(FrontInd(i,2)),ceil(FrontInd(i,2))];
% FrontLevel=interp1(FrontIndNearest,f(FrontIndNearest,1),FrontInd(i,2));
% TopInd=FrontInd(i,1)+FlatTop;
% TopLevel=mean(f(TopInd,1));
% FrontInd(i,4)=StartLevel;
% FrontInd(i,5)=FrontLevel;
% FrontInd(i,6)=TopLevel;
% Fronts=FrontInd(:,6)-FrontInd(:,4);
Fronts=FrontInd(:,3);
FrontInd(Fronts<0,:)=[]; 
Fronts(Fronts<0)=[]; 
DiffFrontInd=[0;diff(FrontInd(:,1))];

HistDiffFrontInd=HistOnNetMK(DiffFrontInd,0.5+1:5:1000);
MaxEnergy=6000;
HistFrontAll=HistOnNetMK(Fronts,0:round(ThrehsholdFront)/4:MaxEnergy);
HistFrontAll(:,1)=HistFrontAll(:,1);
Fronts1=Fronts(FrontInd(:,1)>=TimeIntervals(1,1)/Tact*1e6&FrontInd(:,1)<=TimeIntervals(1,2)/Tact*1e6,:); 
Fronts2=Fronts(FrontInd(:,1)>=TimeIntervals(2,1)/Tact*1e6&FrontInd(:,1)<=TimeIntervals(2,2)/Tact*1e6,:); 
Fronts3=Fronts(FrontInd(:,1)>=TimeIntervals(3,1)/Tact*1e6&FrontInd(:,1)<=TimeIntervals(3,2)/Tact*1e6,:); 

HistFront1=HistOnNetMK(Fronts1,0:round(ThrehsholdFront)/4:MaxEnergy);
HistFront2=HistOnNetMK(Fronts2,0:round(ThrehsholdFront)/4:MaxEnergy);
HistFront3=HistOnNetMK(Fronts3,0:round(ThrehsholdFront)/4:MaxEnergy);
HistFront1(:,1)=HistFront1(:,1);
HistFront2(:,1)=HistFront2(:,1);
HistFront3(:,1)=HistFront3(:,1);

figure; subplot(2,2,1:2);  
errorbar(HistPulseTimes(:,1),HistPulseTimes(:,2),HistPulseTimes(:,3),'-ro','Linewidth',2); grid on;
xlabel('time, ms'); ylabel('Peaks/ms'); 
axis([StartPlasma,EndPlasma,0,1.1*max(HistPulseTimes(:,2)+HistPulseTimes(:,3))]); 
if ischar(FileName); title(FileName); end; 

subplot(2,2,3); hold on; 
errorbar(HistFrontAll(:,1),HistFrontAll(:,2),HistFrontAll(:,3),'-.k'); grid on;

if ThickBe>0
    Transm=AbsorptionSDD(ThickBe,HistFrontAll(:,1));
    ZeroInd=find(Transm(:,2)<1e-30); 
    Transm(ZeroInd,:)=[];
    HistFrontAll(ZeroInd,:)=[];
    HistFrontAll(:,2)=HistFrontAll(:,2)./Transm(:,2);
    HistFrontAll(:,3)=HistFrontAll(:,3)./Transm(:,2);
    
    Transm=AbsorptionSDD(ThickBe,HistFront1(:,1));
    ZeroInd=find(Transm(:,2)<1e-30); 
    Transm(ZeroInd,:)=[];
    HistFront1(ZeroInd,:)=[];
    HistFront1(:,2)=HistFront1(:,2)./Transm(:,2);
    HistFront1(:,3)=HistFront1(:,3)./Transm(:,2);
    
    Transm=AbsorptionSDD(ThickBe,HistFront2(:,1));
    ZeroInd=find(Transm(:,2)<1e-30); 
    Transm(ZeroInd,:)=[];
    HistFront2(ZeroInd,:)=[];
    HistFront2(:,2)=HistFront2(:,2)./Transm(:,2);
    HistFront2(:,3)=HistFront2(:,3)./Transm(:,2);    
    
    Transm=AbsorptionSDD(ThickBe,HistFront3(:,1));
    ZeroInd=find(Transm(:,2)<1e-30); 
    Transm(ZeroInd,:)=[];
    HistFront3(ZeroInd,:)=[];   
    HistFront3(:,2)=HistFront3(:,2)./Transm(:,2);
    HistFront3(:,3)=HistFront3(:,3)./Transm(:,2);
end; 

errorbar(HistFrontAll(:,1),HistFrontAll(:,2),HistFrontAll(:,3),'-k','Linewidth',2); grid on;

plot(HistFront1(:,1),HistFront1(:,2),'-b>','Linewidth',2); grid on;
plot(HistFront2(:,1),HistFront2(:,2),'-ro','Linewidth',2); grid on;
plot(HistFront3(:,1),HistFront3(:,2),'-gv','Linewidth',2); grid on;
legend('All','1','2','3');

set(gca,'YScale','log'); xlabel('Energy,counts'); ylabel('numbers');
axis([0,MaxEnergy,1,1.1*max(HistFrontAll(:,2)+HistFrontAll(:,3))]); 

subplot(2,2,4); hold on; 
plot(HistDiffFrontInd(:,1)*Tact,HistDiffFrontInd(:,2),'b','Linewidth',2); grid on;
axis([0,1000*Tact,1,1.1*max(HistDiffFrontInd(:,2)+HistDiffFrontInd(:,3))]);
set(gca,'YScale','log'); xlabel('Time,ns'); ylabel('numbers');

clear global MinimalGap UpperRange NoiseSet1 NoiseSet2 NoiseSet3 NoiseSet4 NoiseBool ResetBool SignalBoll ExcessNoise ...
             ResetPulseInd ResetMergeTailInd OverloadPulseTopInd BaseTrek...
             StandardPulse StandardConvPulse Tact StartPlasma EndPlasma Kernel1 Kernel2 Kern1N Kern2N K1 K2 K ShiftKernel1 ShiftKernel2 TailCoeff TailSmoothN...
             SmoothN ConvPeakAmplitude ConvPeakArea TopDelay FlatTop StartDelay FlatStart;
% k=find(f(1:FrontInd(1),3)==0,1,'last');
% m=find(f(FrontInd(1):FrontInd(2),3)==0,1,'first')+FrontInd(1);ResetBool SignalBoll 
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
%================================================
function [f1,f2,f3,f4,MergeOn]=ReadoutTrekFiles(FileName);
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
disp(['Reading files: ', num2str(Time),' s']); 
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
%=============================================================
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
%================================================
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

function ReadOk=ReadoutStandardPulseSet(StandardPulseFile)

global StandardPulse StandardConvPulse Tact Kernel1 Kernel2 Kern1N Kern2N...
       K1 K2 K ShiftKernel1 ShiftKernel2 TailCoeff TailSmoothN...
       SmoothN ConvPeakAmplitude ConvPeakArea TopDelay FlatTop StartDelay FlatStart;

SPS=load(StandardPulseFile);   
SPS=SPS.StandardPulseSet;
StandardPulse=SPS.SP(:,2);
StandardConvPulse=SPS.SP(:,3);
Tact=SPS.Tact;  % ns

Kernel1=SPS.Kernel1;
Kernel2=SPS.Kernel2;
Kern1N=length(Kernel1);  % must be odd!
Kern2N=length(Kernel2);  % must be odd!    

K1=SPS.K1; K2=SPS.K2; K=SPS.K;
ShiftKernel1=SPS.ShiftKernel1; ShiftKernel2=SPS.ShiftKernel2;
TailCoeff=SPS.TailCoeff;  TailSmoothN=SPS.TailSmoothN;
SmoothN=SPS.SmoothN;

ConvPeakAmplitude=SPS.ConvPeakAmplitude;
ConvPeakArea=SPS.ConvPeakArea;

TopDelay=SPS.TopDelay;
FlatTop=SPS.FlatTop;
StartDelay=SPS.StartDelay;
FlatStart=SPS.FlatStart;



if (Kern1N/2==fix(Kern1N/2))||(Kern2N/2==fix(Kern2N/2)); 
    ReadOk=false; else ReadOk=true; end; 

%================================================
function [f,FrontInd,ThrehsholdFront,ResetInd]=FrontDetector(f,NoiseSet,ResetInd,eVperCounts);
% detects fronts of pulses from the shape of their derivatives
% Normalized derivative of the front of standard pulse at 20 ns tact
% SP - standard pulse and convolutiion

global MinimalGap NoiseBool ResetBool SignalBool StandardPulse StandardConvPulse Tact Kernel1 Kernel2 Kern1N Kern2N...
       K1 K2 K ShiftKernel1 ShiftKernel2 TailCoeff TailSmoothN SmoothN ConvPeakAmplitude ConvPeakArea TopDelay FlatTop StartDelay FlatStart;

% Kernel1=[0.0025,0.0069,0.0101,0.0136,0.0201,0.0313,0.0456,0.0585,0.0659,...
%          0.0699,0.0802,0.1072,0.1538,0.2098,0.2522,0.2622,0.2542,0.2815,...
%          0.3987,0.6187,0.8759,1,0.8178,0.4057,0.0821,0.009,0.001];
% 
% Kernel2=[-0.0198,-0.0216,-0.0242,-0.0298,-0.0389,-0.0484,-0.054,-0.0547,-0.0559,...
%          -0.0682,-0.0988,-0.1415,-0.1773,-0.187,-0.1709,-0.1628,-0.2201,-0.3721,...
%          -0.5626,-0.6557,-0.5095,-0.0746,0.5131,0.9363,0.96,0.6865,0.3956];

ConvPulseHalfWidth=3;
FineStep=0.1;
ThrehsholdCoeff=1.2;
StdNumb=50; 

fN=length(f);

df=[0;diff(f)]; 
Conv1=conv(Kernel1,df);
Conv1(1:(Kern1N-1)/2)=[]; Conv1(end-(Kern1N-3)/2:end)=[]; 
Conv1=circshift(Conv1,-ShiftKernel1); 
Df=smooth(f,SmoothN); Df=Df-f; 
Conv2=conv(Kernel2,Df);
Conv2(1:(Kern2N-1)/2)=[]; Conv2(end-(Kern2N-3)/2:end)=[]; 
Conv2=circshift(Conv2,-ShiftKernel2); 
Conv=2*(K1*Conv1+K2*Conv2)*K; 
Conv=Conv+TailCoeff*smooth(f(:,1),TailSmoothN); 
f(:,2)=Conv;


StdConv=std(Conv(NoiseBool)); 
StdConv=std(Conv(NoiseBool&abs(Conv)<3*StdConv));
NoiseBool=NoiseBool&abs(Conv)<5*StdConv;

 

ConvRight=circshift(Conv,1); ConvLeft=circshift(Conv,-1);
PeakBool=Conv>=ConvRight&Conv>ConvLeft;
ValleyBool=Conv<ConvRight&Conv<=ConvLeft;
PeakInd=find(PeakBool);     
ValleyInd=find(ValleyBool);  
if ValleyInd(1)>PeakInd(1); PeakBool(PeakInd(1))=0; PeakInd(1)=[];  end;  
if ValleyInd(end)>PeakInd(end); ValleyBool(ValleyInd(end))=0;  ValleyInd(end)=[]; end;  
PeakN=length(PeakInd);
ValleyN=length(ValleyInd);
LeftShiftValleyInd=circshift(ValleyInd,-1);

Base=(f(ValleyInd,2)+f(LeftShiftValleyInd,2))/2/ConvPeakAmplitude*eVperCounts;
Base(end)=Base(end-1);
BaseArea=(f(ValleyInd,2)+f(LeftShiftValleyInd,2))/2.*(LeftShiftValleyInd-ValleyInd)/ConvPeakArea*eVperCounts;
BaseArea(end)=BaseArea(end-1);

PeakValley(:,1)=PeakInd;
PeakValley(:,2)=PeakInd-ValleyInd; %Peak Front
PeakValley(:,3)=LeftShiftValleyInd-PeakInd; %Peak Back
PeakValley(end,3)=PeakValley(end-1,3);
PeakValley(:,4)=f(PeakInd,2)/ConvPeakAmplitude*eVperCounts;     % Peak amplitude
PeakValley(:,5)=f(PeakInd,2)-Base;     % Corrected Peak amplitude


if PeakN==ValleyN
    PeakValley(:,6:7)=0;
    for i=1:PeakN-1
        PeakValley(i,6)=sum(f(ValleyInd(i):ValleyInd(i+1),2))/ConvPeakArea*eVperCounts;  % Peak area
        PeakValley(i,7)=PeakValley(i,6)-BaseArea(i);              % Corrected Peak area
    end;
    PeakValley=[PeakValley, NoiseBool(PeakInd),SignalBool(PeakInd)];
else
    error('PeakN~=ValleyN');
end;

PeakValley(PeakValley(:,1)+TopDelay>fN,:)=[]; 
PeakN=length(PeakValley(:,1));

PeakSignalBool=PeakBool&SignalBool;
%PeakSignal=f(PeakSignalBool,2);   % Conv signal in peaks

clear PeakInd ValleyInd PeakBool ValleyBool BaseArea Base; 

PeakNoiseInd =find(PeakValley(:,end-1)==1);
PeakSignalInd=find(PeakValley(:,end  )==1);

% Histogram and threshold of peak amplitudes: 
PeakNoiseAmpl=PeakValley(PeakNoiseInd,4);  
PeakNoiseAmplN=length(PeakNoiseAmpl);
PeakNoiseAmplSet=NormalNoise(PeakNoiseAmpl,1:PeakNoiseAmplN);

PeakSignalAmpl=PeakValley(PeakSignalInd,4);  
PeakSignalAmplN=length(PeakSignalAmpl);

HistRange=[-(PeakNoiseAmplSet.MeanVal+3*PeakNoiseAmplSet.StdVal):0.1*PeakNoiseAmplSet.StdVal:...
            (PeakNoiseAmplSet.MeanVal+StdNumb*PeakNoiseAmplSet.StdVal)]';
HistNoiseAmpl=HistOnNetMK(PeakNoiseAmpl,HistRange);
HistSignalAmpl=HistOnNetMK(PeakSignalAmpl,HistRange);

figure; 
subplot(2,2,1); hold on; 
x1= HistNoiseAmpl(HistNoiseAmpl(:,2)>0,1); 
y1= log10(HistNoiseAmpl(HistNoiseAmpl(:,2)>0,2));
x2= HistSignalAmpl(HistSignalAmpl(:,2)>0,1); 
y2= log10(HistSignalAmpl(HistSignalAmpl(:,2)>0,2));

plot(x1,y1,'b','Linewidth',2); 
plot(x2,y2,'r','Linewidth',2);
ThrehsholdAmplInd=find(HistNoiseAmpl(:,1)>PeakNoiseAmplSet.MeanVal&...
                        HistSignalAmpl(:,2)>ThrehsholdCoeff*HistNoiseAmpl(:,2),3,'first');
ThrehsholdAmpl=HistSignalAmpl(ThrehsholdAmplInd(end),1);
plot(ThrehsholdAmpl*[1,1],log10([1,max(HistSignalAmpl(:,2))]),'k','Linewidth',2);
ind=find(HistSignalAmpl(:,1)>ThrehsholdAmpl);
[MaxAmplDistr,MaxAmplDistrInd]=max(HistSignalAmpl(ind,2));
MaxAmplDistrInd=ind(MaxAmplDistrInd);
ind=find(HistSignalAmpl(:,1)>=ThrehsholdAmpl&HistSignalAmpl(:,1)<HistSignalAmpl(MaxAmplDistrInd,1));
[Min,MinAmplLevelInd]=min(HistSignalAmpl(ind,2));
MinAmplLevelInd=ind(MinAmplLevelInd);
DetectAmplLevel=HistSignalAmpl(MinAmplLevelInd,1);  
plot(DetectAmplLevel*[1,1],log10([1,MaxAmplDistr]),'k','Linewidth',2);
grid on;                        
axis([min(min(x1),min(x2)),max(max(x1),max(x2)),0,max(max(y1),max(y2))]);
  
FrontAmplBool=PeakValley(:,end)&PeakValley(:,4)>DetectAmplLevel;
FrontAmplInd0=PeakValley(FrontAmplBool,1);
FrontAmplBool=FrontAmplBool&f(PeakValley(:,1)+TopDelay,1)>NoiseSet.StdVal;%&mean(df(PeakValley(:,1)+[-2:2]))>0;
FrontAmplInd=PeakValley(FrontAmplBool,1); 
AmplSXRN=length(FrontAmplInd);
title(['Ampl (N/std): ',num2str(AmplSXRN),'/',num2str(round(PeakNoiseAmplSet.StdVal))]);      

% Histogram and threshold of correcetd peak amplitudes: 
PeakNoiseCorrAmpl=PeakValley(PeakNoiseInd,5);  
PeakNoiseCorrAmplN=length(PeakNoiseCorrAmpl);
PeakNoiseCorrAmplSet=NormalNoise(PeakNoiseCorrAmpl,1:PeakNoiseCorrAmplN);

PeakSignalCorrAmpl=PeakValley(PeakSignalInd,5);  
PeakSignalCorrAmplN=length(PeakSignalCorrAmpl);

HistHistRange=[-(PeakNoiseCorrAmplSet.MeanVal+3*PeakNoiseCorrAmplSet.StdVal):0.1*PeakNoiseCorrAmplSet.StdVal:...
            (PeakNoiseCorrAmplSet.MeanVal+StdNumb*PeakNoiseCorrAmplSet.StdVal)]';
HistNoiseCorrAmpl=HistOnNetMK(PeakNoiseCorrAmpl,HistRange);
HistSignalCorrAmpl=HistOnNetMK(PeakSignalCorrAmpl,HistRange);


subplot(2,2,2); hold on;
x1= HistNoiseCorrAmpl(HistNoiseCorrAmpl(:,2)>0,1); 
y1= log10(HistNoiseCorrAmpl(HistNoiseCorrAmpl(:,2)>0,2));
x2= HistSignalCorrAmpl(HistSignalCorrAmpl(:,2)>0,1); 
y2= log10(HistSignalCorrAmpl(HistSignalCorrAmpl(:,2)>0,2));

plot(x1,y1,'b','Linewidth',2); 
plot(x2,y2,'r','Linewidth',2);
ThrehsholdCorrAmplInd=find(HistNoiseCorrAmpl(:,1)>PeakNoiseCorrAmplSet.MeanVal&...
                        HistSignalCorrAmpl(:,2)>ThrehsholdCoeff*HistNoiseCorrAmpl(:,2),3,'first');
ThrehsholdCorrAmpl=HistSignalCorrAmpl(ThrehsholdCorrAmplInd(end),1);
plot(ThrehsholdCorrAmpl*[1,1],log10([1,max(HistSignalCorrAmpl(:,2))]),'k','Linewidth',2);
ind=find(HistSignalCorrAmpl(:,1)>ThrehsholdCorrAmpl);
[MaxCorrAmplDistr,MaxCorrAmplDistrInd]=max(HistSignalCorrAmpl(ind,2));
MaxCorrAmplDistrInd=ind(MaxCorrAmplDistrInd);
ind=find(HistSignalCorrAmpl(:,1)>=ThrehsholdCorrAmpl&HistSignalCorrAmpl(:,1)<HistSignalCorrAmpl(MaxCorrAmplDistrInd,1));
[Min,MinCorrAmplLevelInd]=min(HistSignalCorrAmpl(ind,2));
MinCorrAmplLevelInd=ind(MinCorrAmplLevelInd);
DetectCorrAmplLevel=HistSignalCorrAmpl(MinCorrAmplLevelInd,1);  
plot(DetectCorrAmplLevel*[1,1],log10([1,MaxCorrAmplDistr]),'k','Linewidth',2);
grid on;                        
axis([min(min(x1),min(x2)),max(max(x1),max(x2)),0,max(max(y1),max(y2))]);

FrontCorrAmplBool=PeakValley(:,end)&PeakValley(:,5)>DetectCorrAmplLevel;
FrontCorrAmplInd0=PeakValley(FrontCorrAmplBool,1);
FrontCorrAmplBool=FrontCorrAmplBool&f(PeakValley(:,1)+TopDelay,1)>NoiseSet.StdVal;%&mean(df(PeakValley(:,1)+[-2:2]))>0;
FrontCorrAmplInd=PeakValley(FrontCorrAmplBool,1); 
CorrAmplSXRN=length(FrontCorrAmplInd);
title(['Corr Ampl (N/std): ',num2str(CorrAmplSXRN),'/',num2str(round(PeakNoiseCorrAmplSet.StdVal))]); 

% Histogram and threshold of peak area: 
PeakNoiseArea=PeakValley(PeakNoiseInd,6);  
PeakNoiseAreaN=length(PeakNoiseArea);
PeakNoiseAreaSet=NormalNoise(PeakNoiseArea,1:PeakNoiseAreaN);

PeakSignalArea=PeakValley(PeakSignalInd,6);  
PeakSignalAreaN=length(PeakSignalArea);

HistRange=[-(PeakNoiseAreaSet.MeanVal+3*PeakNoiseAreaSet.StdVal):0.1*PeakNoiseAreaSet.StdVal:...
            (PeakNoiseAreaSet.MeanVal+StdNumb*PeakNoiseAreaSet.StdVal)]';
HistNoiseArea=HistOnNetMK(PeakNoiseArea,HistRange);
HistSignalArea=HistOnNetMK(PeakSignalArea,HistRange);

subplot(2,2,3); hold on;
x1= HistNoiseArea(HistNoiseArea(:,2)>0,1); 
y1= log10(HistNoiseArea(HistNoiseArea(:,2)>0,2));
x2= HistSignalArea(HistSignalArea(:,2)>0,1); 
y2= log10(HistSignalArea(HistSignalArea(:,2)>0,2));

plot(x1,y1,'b','Linewidth',2); 
plot(x2,y2,'r','Linewidth',2);
ThrehsholdAreaInd=find(HistNoiseArea(:,1)>PeakNoiseAreaSet.MeanVal&...
                        HistSignalArea(:,2)>ThrehsholdCoeff*HistNoiseArea(:,2),3,'first');
ThrehsholdArea=HistSignalArea(ThrehsholdAreaInd(end),1);
plot(ThrehsholdArea*[1,1],log10([1,max(HistSignalArea(:,2))]),'k','Linewidth',2);
ind=find(HistSignalArea(:,1)>ThrehsholdArea);
[MaxAreaDistr,MaxAreaDistrInd]=max(HistSignalArea(ind,2));
MaxAreaDistrInd=ind(MaxAreaDistrInd);
ind=find(HistSignalArea(:,1)>=ThrehsholdArea&HistSignalArea(:,1)<HistSignalArea(MaxAreaDistrInd,1));
[Min,MinAreaLevelInd]=min(HistSignalArea(ind,2));
MinAreaLevelInd=ind(MinAreaLevelInd);
DetectAreaLevel=HistSignalArea(MinAreaLevelInd,1);  
plot(DetectAreaLevel*[1,1],log10([1,MaxAreaDistr]),'k','Linewidth',2);
grid on;           
axis([min(min(x1),min(x2)),max(max(x1),max(x2)),0,max(max(y1),max(y2))]);

FrontAreaBool=PeakValley(:,end)&PeakValley(:,6)>DetectAreaLevel;
FrontAreaInd0=PeakValley(FrontAreaBool,1);
FrontAreaBool=FrontAreaBool&f(PeakValley(:,1)+TopDelay,1)>NoiseSet.StdVal;%&mean(df(PeakValley(:,1)+[-2:2]))>0;
FrontAreaInd=PeakValley(FrontAreaBool,1); 
AreaSXRN=length(FrontAreaInd);
title(['Area (N/std): ',num2str(AreaSXRN),'/',num2str(round(PeakNoiseAreaSet.StdVal))]);  

% Histogram and threshold of corrected peak area: 
PeakNoiseCorrArea=PeakValley(PeakNoiseInd,7);  
PeakNoiseCorrAreaN=length(PeakNoiseCorrArea);
PeakNoiseCorrAreaSet=NormalNoise(PeakNoiseCorrArea,1:PeakNoiseCorrAreaN);

PeakSignalCorrArea=PeakValley(PeakSignalInd,7);  
PeakSignalCorrAreaN=length(PeakSignalCorrArea);

HistRange=[-(PeakNoiseCorrAreaSet.MeanVal+3*PeakNoiseCorrAreaSet.StdVal):0.1*PeakNoiseCorrAreaSet.StdVal:...
            (PeakNoiseCorrAreaSet.MeanVal+StdNumb*PeakNoiseCorrAreaSet.StdVal)]';
HistNoiseCorrArea=HistOnNetMK(PeakNoiseCorrArea,HistRange);
HistSignalCorrArea=HistOnNetMK(PeakSignalCorrArea,HistRange);

subplot(2,2,4); hold on;
x1= HistNoiseCorrArea(HistNoiseCorrArea(:,2)>0,1); 
y1= log10(HistNoiseCorrArea(HistNoiseCorrArea(:,2)>0,2));
x2= HistSignalCorrArea(HistSignalCorrArea(:,2)>0,1); 
y2= log10(HistSignalCorrArea(HistSignalCorrArea(:,2)>0,2));

plot(x1,y1,'b','Linewidth',2); 
plot(x2,y2,'r','Linewidth',2);
ThrehsholdCorrAreaInd=find(HistNoiseCorrArea(:,1)>PeakNoiseCorrAreaSet.MeanVal&...
                        HistSignalCorrArea(:,2)>ThrehsholdCoeff*HistNoiseCorrArea(:,2),3,'first');
ThrehsholdCorrArea=HistSignalCorrArea(ThrehsholdCorrAreaInd(end),1);
plot(ThrehsholdCorrArea*[1,1],log10([1,max(HistSignalCorrArea(:,2))]),'k','Linewidth',2);
ind=find(HistSignalCorrArea(:,1)>ThrehsholdCorrArea);
[MaxCorrAreaDistr,MaxCorrAreaDistrInd]=max(HistSignalCorrArea(ind,2));
MaxCorrAreaDistrInd=ind(MaxCorrAreaDistrInd);
ind=find(HistSignalCorrArea(:,1)>=ThrehsholdCorrArea&HistSignalCorrArea(:,1)<HistSignalCorrArea(MaxCorrAreaDistrInd,1));
[Min,MinCorrAreaLevelInd]=min(HistSignalCorrArea(ind,2));
MinCorrAreaLevelInd=ind(MinCorrAreaLevelInd);
DetectCorrAreaLevel=HistSignalCorrArea(MinCorrAreaLevelInd,1);  
plot(DetectCorrAreaLevel*[1,1],log10([1,MaxCorrAreaDistr]),'k','Linewidth',2);
grid on;                   
axis([min(min(x1),min(x2)),max(max(x1),max(x2)),0,max(max(y1),max(y2))]);

FrontCorrAreaBool=PeakValley(:,end)&PeakValley(:,7)>DetectCorrAreaLevel;
FrontCorrAreaInd0=PeakValley(FrontCorrAreaBool,1);
FrontCorrAreaBool=FrontCorrAreaBool&f(PeakValley(:,1)+TopDelay,1)>NoiseSet.StdVal;%&mean(df(PeakValley(:,1)+[-2:2]))>0;
FrontCorrAreaInd=PeakValley(FrontCorrAreaBool,1);    
CorrAreaSXRN=length(FrontCorrAreaInd);
title(['Corr Area (N/std): ',num2str(CorrAreaSXRN),'/',num2str(round(PeakNoiseCorrAreaSet.StdVal))]);

Gap=diff(PeakValley(:,1));
ShortGap=[]; 
for i=1:PeakN-1
     if Gap(i)<MinimalGap
        [Min,Ind]=min(f(PeakValley(i:i+1),2)); 
        ShortGap=[ShortGap;i+Ind-1];
     end; 
end;     


PeakValley(ShortGap,:)=[]; 
PeakN=length(PeakValley);

ThrehsholdFront=ThrehsholdArea;

FrontInd(:,1)=PeakValley(FrontAreaBool,1);
FrontInd(:,2)=FrontInd(:,1);
FrontInd(:,3)=PeakValley(FrontAreaBool,6);
FrontInd(:,4)=f(FrontInd(:,1),2);
FrontInd(:,5)=0;
FrontInd(:,6)=FrontInd(:,1)-PeakValley(FrontAreaBool,2); % preceeing (left) valley
FrontInd(:,7)=FrontInd(:,1)+PeakValley(FrontAreaBool,3); % next (right) valley  
FrontInd(end,7)=2*MinimalGap; 
FrontIndN=length(FrontInd(:,1));
AroundPeakInd=[-ConvPulseHalfWidth:ConvPulseHalfWidth]';
for i=1:FrontIndN
    x=FrontInd(i,1)+AroundPeakInd;
    x(x>=FrontInd(i,7))=[]; 
    x(x<=FrontInd(i,6))=[]; 
    y=f(x,2);
    dy=diff(y);
    xN=length(x);
    Power=1; 
    if xN>2; Power=xN-1; end;
    Power=min(Power,4);
    if Power>1
        P=polyfit(x-FrontInd(i,1),y,Power);
        [SortValues,SortInd]=sort(y,'descend');
        SortInd=SortInd(1:2);
        xFine=x(min(SortInd)):FineStep:x(max(SortInd));
        yFine=polyval(P,xFine-FrontInd(i,1));
        [Max,MaxInd]=max(yFine);
        FrontInd(i,2)=xFine(MaxInd);
        FrontInd(i,4)=Max;
        FrontInd(i,5)=Power; 
    end;
end;



clear Conv1 Conv2 Conv;

%================================================
function [f,NoiseSet]=MergeSignals(f1,f2,f3,f4);
   global UpperRange NoiseSet1 NoiseSet2 NoiseSet3 NoiseSet4 NoiseBool ExcessNoise...
          ResetPulseInd  ResetMergeTailInd OverloadPulseTopInd BaseTrek Tact StartPlasma EndPlasma 
    Power=1; 
    PlotOn=1; 
    
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
    UpperRangeBool1=(f1<UpperRange)&(f2<UpperRange)&(f3<UpperRange)&(f4<UpperRange);
    UpperRangeBool3=(f3<UpperRange)&(f4<UpperRange);

    % three ranges of signals:
    % noise range:

    NoiseBool=NoiseBool&not(AboveNoiseBool)&not(UnderNoiseBool);
    % Positive signals range:
    SignalBool=true(size(f1));
    SignalBool(NoiseSet1.Ind)=false;
    SignalBool(ResetMergeTailInd)=false;
    for i=1:size(OverloadPulseTopInd,1)
        SignalBool(OverloadPulseTopInd(i,1):OverloadPulseTopInd(i,4))=false;
    end; 
    OverloadPulseMergeTailBool=false(size(f1));
    OverloadPulsesN=size(OverloadPulseTopInd,1);
    for i=1:OverloadPulsesN
        OverloadPulseMergeTailBool(OverloadPulseTopInd(i,3):OverloadPulseTopInd(i,4))=true;
    end;    
    
    RangeMergeTailInd1=(OverloadPulseMergeTailBool&UpperRangeBool1); 
    RangeMergeTailInd1(ResetMergeTailInd)=false;
    for i=1:size(ResetPulseInd,1)
        RangeMergeTailInd1(ResetPulseInd(i,1):ResetPulseInd(i,2))=false;
    end;
    RangeMergeTailInd1=find(RangeMergeTailInd1);
    RangeMergeTailInd3=(OverloadPulseMergeTailBool&UpperRangeBool3); 
    RangeMergeTailInd3(ResetMergeTailInd)=false;
    for i=1:size(ResetPulseInd,1)
        RangeMergeTailInd3(ResetPulseInd(i,1):ResetPulseInd(i,2))=false;
    end;
    RangeMergeTailInd3=find(RangeMergeTailInd3);
    
    
    LowerLevel=max([min(f1(SignalBool)),min(f2(SignalBool)),min(f3(SignalBool)),min(f4(SignalBool))]); % the level of reset pulses
    SignalBool=SignalBool&AboveNoiseBool&UpperRangeBool1;
    SignalBool(1:round(1e6*StartPlasma/Tact))=false;
    SignalBool(round(1e6*EndPlasma/Tact):end)=false;  
    % Negative signals (reset pulses) range:
    LowerRangeBool=(f1>LowerLevel)&(f2>LowerLevel)&(f3>LowerLevel)&(f4>LowerLevel);
    ResetBool=true(size(f1));
    ResetBool(NoiseSet1.Ind)=false;
    ResetBool(ResetMergeTailInd)=false;
    ResetBool=ResetBool&UnderNoiseBool&LowerRangeBool;

    % MergeInd=find(SignalBool);
    % MergeIndN=length(MergeInd);
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
    MergeIntervalsN=9; 
    MergeInd=find(SignalBool);
    MergeIndN=length(MergeInd); 
    MergeItervalIndN=round(MergeIndN/MergeIntervalsN);
    MergeIndBorders=MergeInd([0:MergeIntervalsN-1]*MergeItervalIndN+1); 
    MergeIndBorders(end+1)=MergeInd(MergeIndN);
    MergeIndBorders(1)=1; 
    MergeIndBorders(end)=length(f1);
    if PlotOn; 
       figure; 
       subplot(2,2,3:4); hold on; grid on; 
    end;    
    MergePart=zeros(MergeIntervalsN,1);   
    Delta21=zeros(MergeItervalIndN,MergeIntervalsN); 
    Delta31=zeros(MergeItervalIndN,MergeIntervalsN); 
    Delta41=zeros(MergeItervalIndN,MergeIntervalsN);     
    TailP21=zeros(OverloadPulsesN,2);
    TailP31=zeros(OverloadPulsesN,2);
    TailP41=zeros(OverloadPulsesN,2);    
    for i=1:MergeIntervalsN
        if i==MergeIntervalsN; 
            Ind=(i-1)*MergeItervalIndN+[1:MergeItervalIndN];
            Ind(Ind>MergeIndN)=[]; 
            Ind=MergeInd(Ind); 
        else 
            Ind=MergeInd((i-1)*MergeItervalIndN+[1:MergeItervalIndN]);   
        end;
        MergePart(i)=length(Ind)/(Ind(end)-Ind(1));                
        P21Merge(i,:)=polyfit(f2(Ind)-NoiseSet2.MeanVal,f1(Ind)-NoiseSet1.MeanVal,Power);
        P12Merge(i,:)=polyfit(f1(Ind)-NoiseSet1.MeanVal,f2(Ind)-NoiseSet2.MeanVal,Power);
        P31Merge(i,:)=polyfit(f3(Ind)-NoiseSet3.MeanVal,f1(Ind)-NoiseSet1.MeanVal,Power);
        P41Merge(i,:)=polyfit(f4(Ind)-NoiseSet4.MeanVal,f1(Ind)-NoiseSet1.MeanVal,Power);
        P32Merge(i,:)=polyfit(f3(Ind)-NoiseSet3.MeanVal,f2(Ind)-NoiseSet2.MeanVal,Power);
        P42Merge(i,:)=polyfit(f4(Ind)-NoiseSet4.MeanVal,f2(Ind)-NoiseSet2.MeanVal,Power);
        P43Merge(i,:)=polyfit(f4(Ind)-NoiseSet4.MeanVal,f3(Ind)-NoiseSet3.MeanVal,Power);    
        
        Delta21(:,i)=f1(Ind)-(polyval(P21Merge(i,:),f2(Ind)-NoiseSet2.MeanVal)+NoiseSet1.MeanVal);
        StdDelta21(i,1)=std(Delta21(i,:)); 
        Delta31(:,i)=f1(Ind)-(polyval(P31Merge(i,:),f3(Ind)-NoiseSet3.MeanVal)+NoiseSet1.MeanVal);
        StdDelta31(i,1)=std(Delta21(i,:)); 
        Delta41(:,i)=f1(Ind)-(polyval(P41Merge(i,:),f4(Ind)-NoiseSet4.MeanVal)+NoiseSet1.MeanVal);
        StdDelta41(i,1)=std(Delta21(i,:));         
        if PlotOn
           plot(Ind(1):Ind(end),polyval(P41Merge(i,:),f4(Ind(1):Ind(end))-NoiseSet4.MeanVal)+NoiseSet1.MeanVal,'r');             
           plot(Ind(1):Ind(end),polyval(P31Merge(i,:),f3(Ind(1):Ind(end))-NoiseSet3.MeanVal)+NoiseSet1.MeanVal,'g'); 
           plot(Ind(1):Ind(end),f1(Ind(1):Ind(end)));
           plot(Ind,Delta31(:,i),'m.'); 
           plot(Ind(1)*[1,1],max(f1(Ind))*[0,1],'k','Linewidth',2); 
           plot(Ind(end)*[1,1],max(f1(Ind))*[0,1],'k','Linewidth',2);         
        end;
        
        % fitting of tails after overload paulses: 
        if not(isempty(OverloadPulseTopInd))
            OverloadTailsInd=find(OverloadPulseTopInd(:,3)>=Ind(1)&OverloadPulseTopInd(:,3)<Ind(end));
            for m=1:length(OverloadTailsInd);
                k=OverloadTailsInd(m);
                ind=[OverloadPulseTopInd(k,3):OverloadPulseTopInd(k,4)]'; % tail of overload pulses
                ind= OverloadPulseTopInd(k,3)+find(UpperRangeBool1(ind));
                indN=length(ind);
                D21=f1(ind)-(polyval(P21Merge(i,:),f2(ind)-NoiseSet2.MeanVal)+NoiseSet1.MeanVal);
                D31=f1(ind)-(polyval(P31Merge(i,:),f3(ind)-NoiseSet3.MeanVal)+NoiseSet1.MeanVal);
                D41=f1(ind)-(polyval(P41Merge(i,:),f4(ind)-NoiseSet4.MeanVal)+NoiseSet1.MeanVal);
                ind2=ind(D21>2*StdDelta21(i)); D21(D21<=2*StdDelta21(i))=[];
                ind3=ind(D31>2*StdDelta31(i)); D31(D31<=2*StdDelta31(i))=[];
                ind4=ind(D41>2*StdDelta41(i)); D41(D41<=2*StdDelta41(i))=[];
                if length(ind2)>10;  TailP21(k,:)=polyfit(-ind2+OverloadPulseTopInd(k,2),log(D21),1);  end;
                if length(ind3)>10;  TailP31(k,:)=polyfit(-ind3+OverloadPulseTopInd(k,2),log(D31),1);  end;
                if length(ind4)>10;  TailP41(k,:)=polyfit(-ind4+OverloadPulseTopInd(k,2),log(D41),1);  end;
                ind=[OverloadPulseTopInd(k,1):OverloadPulseTopInd(k,4)]';
                ind=OverloadPulseTopInd(k,1)+find(UpperRangeBool1(ind));
                if PlotOn
                    plot(ind,f1(ind)-(polyval(P21Merge(i,:),f2(ind)-NoiseSet2.MeanVal)+NoiseSet1.MeanVal),'y.');
                    plot(ind,exp(polyval(TailP21(k,:),-ind+OverloadPulseTopInd(k,2))),'k');

                    plot(ind,f1(ind)-(polyval(P31Merge(i,:),f3(ind)-NoiseSet3.MeanVal)+NoiseSet1.MeanVal),'g.');
                    plot(ind,exp(polyval(TailP31(k,:),-ind+OverloadPulseTopInd(k,2))),'k');

                    plot(ind,f1(ind)-(polyval(P41Merge(i,:),f4(ind)-NoiseSet4.MeanVal)+NoiseSet1.MeanVal),'r.');
                    plot(ind,exp(polyval(TailP41(k,:),-ind+OverloadPulseTopInd(k,2))),'k');
                end;
            end;
        end;
    end;
    MeanTailP21=mean(TailP21(TailP21(:,1)~=0,:),1);
    StdTailP21=std(TailP21(TailP21(:,1)~=0,:),1,1);
    TailP21(abs(TailP21(:,1)-MeanTailP21(1))>3*MeanTailP21(2),2)=MeanTailP21(2);
    TailP21(abs(TailP21(:,1)-MeanTailP21(1))>3*MeanTailP21(2),1)=MeanTailP21(1);
    
    MeanTailP31=mean(TailP31(TailP31(:,1)~=0,:),1);
    StdTailP31=std(TailP31(TailP31(:,1)~=0,:),1,1);
    TailP31(TailP31(:,1)==0,2)=MeanTailP31(2);
    TailP31(TailP31(:,1)==0,1)=MeanTailP31(1);    
    
    MeanTailP41=mean(TailP41(TailP41(:,1)~=0,:),1);
    StdTailP41=std(TailP41(TailP41(:,1)~=0,:),1,1);
    TailP41(TailP41(:,1)==0,2)=MeanTailP41(2);
    TailP41(TailP41(:,1)==0,1)=MeanTailP41(1);
    
    
    
    if PlotOn; 
        subplot(2,2,1); hold on; grid on;  
        plot(P21Merge(:,end),'Linewidth',2); plot(P31Merge(:,end),'r','Linewidth',2); plot(P41Merge(:,end),'g','Linewidth',2);
        legend('P21','P31','P41');
        title('free terms of polyfits');
        subplot(2,2,2); hold on; grid on;  
        plot(P21Merge(:,end-1),'Linewidth',2); plot(P31Merge(:,end-1),'r','Linewidth',2); plot(P41Merge(:,end-1),'g','Linewidth',2);
        legend('P21','P31','P41');
        title('linear coeff of polyfits');                     
    end;   
    figure; 
    for i=1:MergeIntervalsN
        if i==MergeIntervalsN
            Ind=(i-1)*MergeItervalIndN+[1:MergeItervalIndN];
            Ind(Ind>MergeIndN)=[]; 
            Ind=MergeInd(Ind); 
        else
            Ind=MergeInd((i-1)*MergeItervalIndN+[1:MergeItervalIndN]);            
        end;
        subplot(fix(MergeIntervalsN^0.5),fix(MergeIntervalsN^0.5),i); hold on; 
        plot(f1(Ind),f3(Ind),'.');
        [Min,IndMin]=min(f3(Ind));
        [Max,IndMax]=max(f3(Ind));
        plot(polyval(P31Merge(i,:),f3([Ind(IndMin),Ind(IndMax)])-NoiseSet3.MeanVal)+NoiseSet1.MeanVal,...
                     f3([Ind(IndMin),Ind(IndMax)]),'r','Linewidth',2);
        grid on; title(['fraction ',num2str(MergePart(i))]); axis tight; 
    end;
    
%     P21Merge=polyfit(f2(MergeInd)-NoiseSet2.MeanVal,f1(MergeInd)-NoiseSet1.MeanVal,Power);
%     P12Merge=polyfit(f1(MergeInd)-NoiseSet1.MeanVal,f2(MergeInd)-NoiseSet2.MeanVal,Power);
%     P31Merge=polyfit(f3(MergeInd)-NoiseSet3.MeanVal,f1(MergeInd)-NoiseSet1.MeanVal,Power);
%     P41Merge=polyfit(f4(MergeInd)-NoiseSet4.MeanVal,f1(MergeInd)-NoiseSet1.MeanVal,Power);
%     P32Merge=polyfit(f3(MergeInd)-NoiseSet3.MeanVal,f2(MergeInd)-NoiseSet2.MeanVal,Power);
%     P42Merge=polyfit(f4(MergeInd)-NoiseSet4.MeanVal,f2(MergeInd)-NoiseSet2.MeanVal,Power);
%     P43Merge=polyfit(f4(MergeInd)-NoiseSet4.MeanVal,f3(MergeInd)-NoiseSet3.MeanVal,Power);
    % polyfit of negative signals
    MergeInd=find(ResetBool);
    M21Merge=polyfit(f2(MergeInd)-NoiseSet2.MeanVal,f1(MergeInd)-NoiseSet1.MeanVal,Power);
    M31Merge=polyfit(f3(MergeInd)-NoiseSet3.MeanVal,f1(MergeInd)-NoiseSet1.MeanVal,Power);
    M41Merge=polyfit(f4(MergeInd)-NoiseSet4.MeanVal,f1(MergeInd)-NoiseSet1.MeanVal,Power);
    M32Merge=polyfit(f3(MergeInd)-NoiseSet3.MeanVal,f2(MergeInd)-NoiseSet2.MeanVal,Power);
    M42Merge=polyfit(f4(MergeInd)-NoiseSet4.MeanVal,f2(MergeInd)-NoiseSet2.MeanVal,Power);
    M43Merge=polyfit(f4(MergeInd)-NoiseSet4.MeanVal,f3(MergeInd)-NoiseSet3.MeanVal,Power);
    % polyfit of noise signals
    MergeInd=find(NoiseBool);
    N21Merge=polyfit(f2(MergeInd)-NoiseSet2.MeanVal,f1(MergeInd)-NoiseSet1.MeanVal,Power);
    N31Merge=polyfit(f3(MergeInd)-NoiseSet3.MeanVal,f1(MergeInd)-NoiseSet1.MeanVal,Power);
    N41Merge=polyfit(f4(MergeInd)-NoiseSet4.MeanVal,f1(MergeInd)-NoiseSet1.MeanVal,Power);
    N32Merge=polyfit(f3(MergeInd)-NoiseSet3.MeanVal,f2(MergeInd)-NoiseSet2.MeanVal,Power);
    N42Merge=polyfit(f4(MergeInd)-NoiseSet4.MeanVal,f2(MergeInd)-NoiseSet2.MeanVal,Power);
    N43Merge=polyfit(f4(MergeInd)-NoiseSet4.MeanVal,f3(MergeInd)-NoiseSet3.MeanVal,Power);



    %f(:,2)=polyval(P21Merge,f2-NoiseSet2.MeanVal)+NoiseSet1.MeanVal; f(f(:,2)<LowerLevel,2)=LowerLevel;
    %f(:,3)=polyval(P31Merge,f3-NoiseSet3.MeanVal)+NoiseSet1.MeanVal; f(f(:,3)<LowerLevel,3)=LowerLevel;
    %f(:,4)=polyval(P41Merge,f4-NoiseSet4.MeanVal)+NoiseSet1.MeanVal; f(f(:,4)<LowerLevel,4)=LowerLevel;

    % fm=repmat(f1,[1,4]);
    % PositiveBool=AboveNoiseBool&UpperRangeBool1;
    % fm(PositiveBool,2)=polyval(P21Merge,f2(PositiveBool)-NoiseSet2.MeanVal)+NoiseSet1.MeanVal;
    % fm(PositiveBool,3)=polyval(P31Merge,f3(PositiveBool)-NoiseSet3.MeanVal)+NoiseSet1.MeanVal;
    % fm(PositiveBool,4)=polyval(P41Merge,f4(PositiveBool)-NoiseSet4.MeanVal)+NoiseSet1.MeanVal;
    % NegativeBool=UnderNoiseBool&LowerRangeBool;
    % fm(NegativeBool,2) =polyval(M21Merge,f2(NegativeBool)-NoiseSet2.MeanVal)+NoiseSet1.MeanVal;
    % fm(NegativeBool,3) =polyval(M31Merge,f3(NegativeBool)-NoiseSet3.MeanVal)+NoiseSet1.MeanVal;
    % fm(NegativeBool,4) =polyval(M41Merge,f4(NegativeBool)-NoiseSet4.MeanVal)+NoiseSet1.MeanVal;
    % NoiseBool=not(AboveNoiseBool)&not(UnderNoiseBool);
    % fm(NoiseBool,2)
    % =polyval(N21Merge,f2(NoiseBool)-NoiseSet2.MeanVal)+NoiseSet1.MeanVal;z`
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
            for i=1:MergeIntervalsN
                Ind=MergeIndBorders(i):MergeIndBorders(i+1); 
                OverBool=(f1(Ind)==UpperRange);
                f(Ind(OverBool))=polyval(P21Merge(i,:),f2(Ind(OverBool))-NoiseSet2.MeanVal)+NoiseSet1.MeanVal;                
                OverBool=(f1(Ind)==0);
                f(Ind(OverBool))=polyval(P21Merge(i,:),f2(Ind(OverBool))-NoiseSet2.MeanVal)+NoiseSet1.MeanVal;                                                
            end;
            
           for i=1:MergeIntervalsN
                Ind=MergeIndBorders(i):MergeIndBorders(i+1); 
                OverBool=(f2(Ind)==UpperRange);
                % OverBool=(f1(Ind)>0);
                f(Ind(OverBool))=polyval(P31Merge(i,:),f3(Ind(OverBool))-NoiseSet3.MeanVal)+NoiseSet1.MeanVal;                
                OverBool=(f2(Ind)==0);
                f(Ind(OverBool))=polyval(P31Merge(i,:),f3(Ind(OverBool))-NoiseSet3.MeanVal)+NoiseSet1.MeanVal;                                                
            end;
            
           for i=1:MergeIntervalsN
                Ind=MergeIndBorders(i):MergeIndBorders(i+1); 
                OverBool=(f3(Ind)==UpperRange);
                % OverBool=(f1(Ind)>0);
                f(Ind(OverBool))=polyval(P41Merge(i,:),f4(Ind(OverBool))-NoiseSet4.MeanVal)+NoiseSet1.MeanVal;                
                OverBool=(f3(Ind)==0);
                f(Ind(OverBool))=polyval(P41Merge(i,:),f4(Ind(OverBool))-NoiseSet4.MeanVal)+NoiseSet1.MeanVal;                                                
            end;  
           
           NoiseSet=NormalNoise(f,NoiseSet4.Ind); 
           
           for i=1:size(OverloadPulseTopInd,1); 
               ind=[OverloadPulseTopInd(i,2):OverloadPulseTopInd(i,4)]'; 
               OverBool=(f1(ind)==UpperRange&f2(ind)<UpperRange); 
               f(ind(OverBool))=f(ind(OverBool))-NoiseSet.MeanVal+NoiseSet1.MeanVal+exp(polyval(TailP21(i,:),-ind(OverBool)+OverloadPulseTopInd(i,2))); 
               OverBool=(f2(ind)==UpperRange&f3(ind)<UpperRange);
         %      OverBool=(f1(ind)>0);
               f(ind(OverBool))=f(ind(OverBool))-NoiseSet.MeanVal+NoiseSet1.MeanVal+exp(polyval(TailP31(i,:),-ind(OverBool)+OverloadPulseTopInd(i,2)));
               OverBool=(f3(ind)==UpperRange); 
               f(ind(OverBool))=f(ind(OverBool))-NoiseSet.MeanVal+NoiseSet1.MeanVal+exp(polyval(TailP41(i,:),-ind(OverBool)+OverloadPulseTopInd(i,2)));                                            
           end; 
            
%             OverBool=(f1==UpperRange);
%             f(OverBool)=polyval(P21Merge,f2(OverBool)-NoiseSet2.MeanVal)+NoiseSet1.MeanVal;
%             OverBool=(f1==0);
%             f(OverBool)=polyval(P21Merge,f2(OverBool)-NoiseSet2.MeanVal)+NoiseSet1.MeanVal;
% 
%             OverBool=(f2==UpperRange);
%             f(OverBool)=polyval(P31Merge,f3(OverBool)-NoiseSet3.MeanVal)+NoiseSet1.MeanVal;
%             OverBool=(f2==0);
%             f(OverBool)=polyval(P31Merge,f3(OverBool)-NoiseSet3.MeanVal)+NoiseSet1.MeanVal;
% 
%             OverBool=(f3==UpperRange);
%             f(OverBool)=polyval(P41Merge,f4(OverBool)-NoiseSet4.MeanVal)+NoiseSet1.MeanVal;
%             OverBool=(f3==0);
%             f(OverBool)=polyval(P41Merge,f4(OverBool)-NoiseSet4.MeanVal)+NoiseSet1.MeanVal;
            
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
    disp(['Merging treks: ', num2str(Time),' s']);






