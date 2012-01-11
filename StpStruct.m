function STP=StpStruct(StandardPulse);

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