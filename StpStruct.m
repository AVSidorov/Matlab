function STP=StpStruct(StandardPulseFile)
%This function makes Standart pulse struct
%that contains StandartPulse and its parameters
%length, maximum position etc.
% TODO Change later to choosing standart pulse by Amp in TrekSet

tic;
disp('>>>>>>>>StpStruct started');

if nargin<1
    StandardPulseFile='D:\!SCN\StandPeakAnalys\StPeakAmp4_20ns_9.dat';
end;
if isstr(StandardPulseFile) 
 if exist(StandardPulseFile,'file');
         StandardPulse=load(StandardPulseFile);
 else     
     disp('Standart pulse file not found');
     STP=[];
     return;
 end;
else
    StandardPulse=StandardPulseFile;
end;

if size(StandardPulse,2)>size(StandardPulse,1)
    StandardPulse=StandardPulse'; %make vertical
end;


Plot=false;

%MaxInd=find(StandardPulse==max(StandardPulse));
if size(StandardPulse,2)==2
    TimeInd=StandardPulse(:,1);
    TimeStep=mean(diff(TimeInd));
    FinePulse=StandardPulse(:,2);
    [M,MaxInd]=max(FinePulse);
    %shift pulse to make maximum in integer point    
    sh=round(TimeInd(MaxInd))-TimeInd(MaxInd);
    sh=round(sh/TimeStep);
    FinePulse=circshift(FinePulse,sh); % it must work good soo zeros are in start/end
    
    StandardPulse=interp1(TimeInd,FinePulse,[1:fix(max(TimeInd))],'PCHIP',0)';
%     StandardPulse=StandardPulse/max(StandardPulse);
else
    TimeInd=[1:numel(StandardPulse)]';
    TimeStep=1;
    FinePulse=StandardPulse;
end;
[M,MaxInd]=max(StandardPulse); 
FirstNotZero=find(abs(StandardPulse),1,'first');%Standard Pulse must have several zero point at front end and las zero point
BckgFitN=FirstNotZero-1; 
FrontN=MaxInd-BckgFitN;
TailInd=find(StandardPulse<=0);
TailInd(TailInd<MaxInd)=[];
if ~isempty(TailInd)
    TailInd=TailInd(1);
end;
LastNotZero=find(abs(StandardPulse),1,'last');
ZeroTailN=numel(StandardPulse)-LastNotZero;

Stp=StandardPulse;
StpR=circshift(StandardPulse,1);
StpL=circshift(StandardPulse,-1);
maxI=find(Stp>StpR&Stp>StpL);
maxI(maxI>=MaxInd+2)=[];
maxN=numel(maxI); 

IndNegativeTail=find(Stp<0);

IndPositiveTail=find(Stp>0);
if ~isempty(IndNegativeTail)
    IndPositiveTail(IndPositiveTail<IndNegativeTail(1))=[];
    IndPulse=1:IndNegativeTail(1)-1;
else
    IndPulse=IndPositiveTail;
end;

STP.Stp=StandardPulse;
STP.size=numel(StandardPulse);
STP.Max=1;
STP.MaxInd=MaxInd;
STP.BckgFitN=BckgFitN;
STP.FrontN=FrontN;
STP.maxN=1;
STP.maxI=MaxInd;
STP.max=1;
STP.TailInd=TailInd;
STP.ZeroTailN=ZeroTailN;
STP.StandardPulseFile=StandardPulse;
STP.IndNegativeTail=IndNegativeTail;
STP.IndPositiveTail=IndPositiveTail;
STP.IndPulse=IndPulse;
STP.TimeInd=TimeInd;
STP.FinePulse=FinePulse;
STP.TimeStep=TimeStep;


SPSetStpD=SpecialTreks(diff(FinePulse));
TimeIndD=STP.TimeInd(1:end-1);
[m,MaxIndD]=max(diff(FinePulse));
MaxIndD=round(TimeIndD(MaxIndD));
MinFitPoint=round(TimeIndD(SPSetStpD.MinInd(find(TimeIndD(SPSetStpD.MinInd)>MaxIndD,1,'first'))));
if isempty(MinFitPoint)||MinFitPoint>=STP.MaxInd
    MinFitPoint=round((MaxIndD+STP.MaxInd)/2);
end;
STP.MinFitPoint=MinFitPoint;
%%
toc;
%%
if Plot
    figure;
        plot(STP.Stp);
        grid on; hold on;
        plot(STP.MaxInd,STP.Max,'*r');
        plot(STP.BckgFitN,0,'ok');
        plot(STP.TailInd,STP.Stp(STP.TailInd),'om');
        
    pause;
    close(gcf);       
end;