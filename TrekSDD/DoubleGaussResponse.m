function Response=DoubleGaussResponse(InputPulse,fwhm)
% input pulse must contain time and value columns
A=(fwhm/2)^4/log(2);
sigma=fwhm/(2*sqrt(2*log(2))); % to determine sigma for gauss pulse with same width. Sigma is used for pulse shifting
bool=InputPulse(:,2)>0;
Ind=find(bool);
[M,MI]=max(InputPulse(:,2));
timeMax=InputPulse(MI,1);
timeStep=mean(diff(InputPulse(:,1)));

timeMaxResp=InputPulse(Ind(1),1)+sqrt(-2*sigma^2*log(InputPulse(Ind(1),2)))+sigma;
timeMax=max([timeMax,timeMaxResp]);
timeMax=round(timeMax/timeStep)*timeStep;

Response=InputPulse;
Response(:,2)=exp(-(Response(:,1)-timeMax).^4/A);
Response(1:Ind(1)-1,2)=0;

