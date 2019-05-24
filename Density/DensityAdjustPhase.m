function [phase,timeBase,timeTail]=DensityAdjustPhase(phase,tau,timeBase,timeTail)

indBaseTrek=round(timeBase/tau)+1;
indTailTrek=round(timeTail/tau)+1;

if numel(indBaseTrek)==1 
    indBaseTrek=1:indBaseTrek;
end
timeBase=([indBaseTrek(1) indBaseTrek(end)]-1)*tau;

if numel(indTailTrek)==1
    indTailTrek=indTailTrek:length(trek);
end
timeTail=([indTailTrek(1) indTailTrek(end)]-1)*tau;

indBasePhase=find(phase(:,1)>=timeBase(1)&phase(:,1)<=timeBase(end));
indTailPhase=find(phase(:,1)>=timeTail(1)&phase(:,1)<=timeTail(end));

phase(:,2)=phase(:,2)-mean(phase(indBasePhase,2));

end