function Response=GaussResponse(InputPulse,fwhm)
% input pulse must contain time and value columns
sigma=fwhm/(2*sqrt(2*log(2)));
bool=InputPulse(:,2)>0;
Ind=find(bool);
[M,MI]=max(InputPulse(:,2));
timeMax=InputPulse(MI,1);
timeMaxResp=InputPulse(Ind(1),1)+sqrt(-2*sigma^2*log(InputPulse(Ind(1),2)))+sigma;
timeMax=max([timeMax,timeMaxResp]);
Response=InputPulse;
Response(:,2)=exp(-(Response(:,1)-timeMax).^2/(2*sigma^2));
Response(1:Ind(1)-1,2)=0;

