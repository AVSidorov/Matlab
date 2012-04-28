function STP=StpStruct(StandardPulseFile)
%This function makes Standart pulse sruct
%that contains StandartPulse and its parameters
%length, maximum position etc.
% TODO Change later to choosing standart pulse by Amp in TrekSet

tic;
disp('>>>>>>>>StpStruct started');

if nargin<1
    StandardPulseFile='D:\!SCN\StandPeakAnalys\StPeakAmp4_20ns_1.dat';
end;
 if exist(StandardPulseFile,'file');
         StandardPulse=load(StandardPulseFile);
 else
     disp('Standart pulse file not found\n');
     STP=[];
     return;
 end;

Plot=false;

%MaxInd=find(StandardPulse==max(StandardPulse));
MaxInd=find(StandardPulse==1); %Standard Pulse must be normalized by Amp s
BckgFitInd=find(StandardPulse==0);%Standard Pulse must have several zero point at front end and las zero point
BckgFitInd(end)=[];
BckgFitN=numel(BckgFitInd); 
FrontN=MaxInd-BckgFitN;
TailInd=find(StandardPulse<=0);
TailInd(TailInd<MaxInd)=[];
TailInd=TailInd(1);

Stp=StandardPulse;
StpR=circshift(StandardPulse,1);
StpL=circshift(StandardPulse,-1);
maxI=find(Stp>StpR&Stp>StpL);
maxI(maxI>=MaxInd+2)=[];
maxN=numel(maxI); 

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
STP.StandardPulseFile=StandardPulse;
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