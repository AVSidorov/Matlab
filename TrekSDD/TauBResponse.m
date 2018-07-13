function Response=TauBResponse(InputPulse,tau,b)
% input pulse must contain time and value columns
bool=InputPulse(:,2)>0;
Ind=find(bool);
[M,MI]=max(InputPulse(:,2));
timeMax=InputPulse(MI,1);
time=InputPulse(:,1)-timeMax;

Response=InputPulse;
Response(:,2)=(time/tau).^b.*exp(-time/tau)/tau/gamma(b+1);

Response(1:MI,2)=0;
Response(:,2)=Response(:,2)/max(Response(:,2));