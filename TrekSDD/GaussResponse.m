function Response=GaussResponse(InputPulse,fwhm)
% input pulse must contain time and value columns
sigma=fwhm/(2*sqrt(2*log(2)));
bool=InputPulse(:,2)>0;
Ind=find(bool);
[M,MI]=max(InputPulse(:,2));
timeMax=InputPulse(MI,1);
timeStep=mean(diff(InputPulse(:,1)));

timeMaxResp=InputPulse(Ind(1),1)+sqrt(-2*sigma^2*log(InputPulse(Ind(1),2)))+sigma;
timeMiddle=min(InputPulse(:,1))+range(InputPulse(:,1))/2;
%try to change maximum position
%second version (by MK) in the middle of Input pulse
timeMaxResp=max([timeMaxResp,timeMiddle,InputPulse(Ind(round(numel(Ind)/2)),1)]);

timeMax=max([timeMax,timeMaxResp]);
timeMax=round(timeMax/timeStep)*timeStep;

Response=InputPulse;
Response(:,2)=exp(-(Response(:,1)-timeMax).^2/(2*sigma^2));
Response(1:Ind(1)-1,2)=0;

