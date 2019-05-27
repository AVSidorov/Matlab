function [Phase,freq,trekF]=DensityAdjustFreq(phaseFunc,trek,tau,bandwidth,timeBase,timeTail,freq)
Fs=1/tau;
if nargin<7||isempty(freq)
    freq=getMaxFreq(trek);
end
indBaseTrek=round(timeBase/tau)+1;
indTailTrek=round(timeTail/tau)+1;
if numel(indBaseTrek)==1 
    indBaseTrek=1:indBaseTrek;
    timeBase=indBaseTrek*tau;
end
if numel(indTailTrek)==1 
    indTailTrek=indTailTrek:length(trek);
    timeTail=indTailTrek*tau;
end
trek=trek-mean(trek(indBaseTrek));
trekF=BandFFT(trek,freq,bandwidth);
ph=phaseFunc(trekF,tau,freq*Fs/2,false);
indBasePhase=find(ph(:,1)>=timeBase(1)&ph(:,1)<=timeBase(end));
indTailPhase=find(ph(:,1)>=timeTail(1)&ph(:,1)<=timeTail(end));
ph(:,2)=ph(:,2)-mean(ph(indBasePhase,2));

khibase=sqrt(sum(ph(indTailPhase,2).^2))/length(indTailPhase);

[freq,fval,exitflag,output]=fminbnd(@f,freq*(1-1e-5),freq*(1+1e-5),optimset('TolX',1/Fs/10,'Display','off'));
trekF=BandFFT(trek,freq,bandwidth);
Phase=phaseFunc(trekF,tau,freq*Fs/2,false);
Phase(:,2)=Phase(:,2)-mean(Phase(indBasePhase,2));


    function   khi=f(freq1)
        trekF=BandFFT(trek,freq1,bandwidth);
        ph=phaseFunc(trekF,tau,freq1*Fs/2,false);
        indBasePhase=find(ph(:,1)>=timeBase(1)&ph(:,1)<=timeBase(end));
        indTailPhase=find(ph(:,1)>=timeTail(1)&ph(:,1)<=timeTail(end));
        ph(:,2)=ph(:,2)-mean(ph(indBasePhase,2));
        khi=sqrt(sum(ph(indTailPhase,2).^2))/length(indTailPhase);
    end
end