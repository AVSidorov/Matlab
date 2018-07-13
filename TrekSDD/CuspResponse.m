function Response=CuspResponse(InputPulse,fwhm)
% input pulse must contain time and value columns
tau=fwhm/(2*log(2));
bool=InputPulse(:,2)>0;
Ind=find(bool);
[M,MI]=max(InputPulse(:,2));
timeMax=InputPulse(MI,1);
timeStep=mean(diff(InputPulse(:,1)));
timeMaxResp=InputPulse(Ind(1),1)-tau*log(InputPulse(Ind(1),2))+tau;
timeMaxResp=round(timeMaxResp/timeStep)*timeStep;
timeMax=max([timeMax,timeMaxResp]);
Response=InputPulse;
Response(:,2)=exp(-abs(Response(:,1)-timeMax)/tau);

Response(1:Ind(1)-1,2)=0;

