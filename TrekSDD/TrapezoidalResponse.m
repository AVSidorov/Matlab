function Response=TrapezoidalResponse(InputPulse,fwhm,tautop)
% input pulse must contain time and value columns
fwhm0=(fwhm-tautop);
sigma=fwhm/(2*sqrt(2*log(2)));

A=1/fwhm0;

bool=InputPulse(:,2)>0;
Ind=find(bool);
[M,MI]=max(InputPulse(:,2));

timeMax=InputPulse(MI,1);
timeStep=mean(diff(InputPulse(:,1)));

% timeMaxResp=timeMax+fwhm0+tautop/2;
% timeMaxResp=InputPulse(Ind(1),1)+sqrt(-2*sigma^2*log(InputPulse(Ind(1),2)))+sigma;

%Make TimeMax same way as in Gauss Response
timeMaxResp=InputPulse(Ind(1),1)+sqrt(-2*sigma^2*log(InputPulse(Ind(1),2)))+sigma;
timeMax=max([timeMax,timeMaxResp]);

timeMax=round(timeMax/timeStep)*timeStep;

Response=InputPulse;
Response(1:MI,2)=0;
Ind1=find(Response(:,1)<=timeMax-tautop/2,1,'last');
Ind2=find(Response(:,1)>=timeMax+tautop/2,1,'first');
Response(1:Ind1,2)=A*(Response(1:Ind1,1)-(timeMax-tautop/2-fwhm0));
Response(Ind1+1:Ind2-1,2)=1;
Response(Ind2:end,2)=-A*(Response(Ind2:end,1)-(timeMax+tautop/2+fwhm0));
Response(Response(:,2)<=0,2)=0;
Response(:,2)=Response(:,2)/max(Response(:,2));