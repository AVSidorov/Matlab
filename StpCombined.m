function STP=StpCombined(StpStruct,R,S);
tic;
disp('>>>>>>>>StpCombined started');
STP=StpStruct;

Plot=false;

MaxInd=STP.MaxInd;
PulseN=STP.size;
BckgFitN=STP.BckgFitN;

%%  make Stp
PulseShifted=R*interp1([1:PulseN],STP.Stp,[1:PulseN]-(S-fix(S)),'spline',0)';
PulseShifted(find(PulseShifted(1:MaxInd)<0))=0;
PulseShifted(end)=0;
Stp=zeros(PulseN+fix(S),1);
StpN=PulseN+fix(S);
Stp(1:PulseN)=STP.Stp;
Stp([1:PulseN]+fix(S))=Stp([1:PulseN]+fix(S))+PulseShifted;
StpR=circshift(Stp,1);
StpL=circshift(Stp,-1);
maxI=find(Stp>StpR&Stp>StpL);
maxI(maxI>=MaxInd+S+2)=[];
maxN=numel(maxI);           

FrontN=maxI(1)-BckgFitN;
TailInd=find(Stp<=0);
TailInd(TailInd<maxI(1))=[];
TailInd=TailInd(1);

[Max,MaxInd]=max(Stp);

STP.Stp=Stp;
STP.size=numel(Stp);
STP.Max=Max;
STP.MaxInd=MaxInd;
STP.BckgFitN=BckgFitN;
STP.FrontN=FrontN;
STP.maxN=maxN;
STP.maxI=maxI;
STP.max=Stp(maxI);
STP.TailInd=TailInd;
%%
toc;
%%
if Plot
    figure;
        plot(StpStruct.Stp);
        grid on; hold on;
        plot([1:PulseN]+fix(S),PulseShifted,'k');
        plot(STP.Stp,'r');
        plot(STP.MaxInd,STP.Max,'*r');
        plot(STP.BckgFitN,0,'ok');
        plot(STP.TailInd,STP.Stp(STP.TailInd),'om');
        plot(STP.maxI,STP.max,'.r');
    pause;
    close(gcf);       
end;