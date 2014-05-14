function Phase=DensityPhaseFromVideo(trek,nStp,nWin,NFFT)
  
tau=20e-9;
Fs=1/tau;
StartPlasmaTime=14e-3;
Plot=true;
Fbase=421752;

if nargin<2
    nStp=round(1/Fbase/tau);
end;
if nargin<3
    nWin=pow2(nextpow2(nStp));
end
if nargin<4
    NFFT=nWin;
end;


N=fix((numel(trek)-nWin)/nStp);
f = Fs/2*linspace(0,1,NFFT/2+1);
IndLeft=find(f<=Fbase,1,'last');
IndRight=find(f>=Fbase,1,'first');
Ph=zeros(N,3);
Freq=zeros(N,1);
Ycombine=zeros(NFFT,1);
Y=zeros(NFFT,1);
hWin=hamming(nWin);
for i=1:N
Y=fft(trek((i-1)*nStp+1:(i-1)*nStp+nWin).*hWin,NFFT)/nWin;
Yamp=abs(Y);
Yph=angle(Y);
Ycombine=Ycombine+Yamp;
[m,mi]=max(Yamp(2:fix(NFFT/2)));
mi=mi+1;
Freq(i)=Fs/NFFT*(mi-1);
Ph(i,1)=Yph(mi);
Ph(i,2)=Yph(IndLeft);
Ph(i,3)=Yph(IndRight);
% Ph(i)=interp1(f,angle(Y(1:fix(NFFT/2)+1)),Fbase);
end;
Ycombine=Ycombine/N;
if Plot
    figure;
    subplot(2,2,1);
    grid on; hold on;
    plot(Freq);
    plot([1,N],[Fbase,Fbase],'r');
    subplot(2,2,2);
    grid on; hold on;
    plot(f,abs(Ycombine(1:fix(NFFT/2)+1)),'k');
end;
dPhase=(nStp*tau*Fbase-round(nStp*tau*Fbase))*2*pi;
IndBase=round(((StartPlasmaTime-1e-3)/tau)/nStp);
for i=1:3
    Ph(:,i)=unwrap(Ph(:,i));
    Ph(:,i)=Ph(:,i)-Ph(IndBase,i);
    Ph(:,i)=Ph(:,i)-[0:N-1]'*dPhase;
end;
% Ph=unwrapSid(Ph,1);
% EndI=fix(StartPlasmaTime/tau/n);
% fit=polyfit([1:EndI]',Ph(1:EndI),1);
% Ph=Ph-polyval(fit,[1:N]');
% % Ph=Ph-min(Ph);
Ph=Ph/2/pi;
Phase(1:N,1)=[1:N]*nStp*tau-tau*nStp/2;
Phase(:,2)=Ph(:,1);
if Plot
    subplot(2,2,3:4);
    grid on; hold on;
    plot(Phase(:,1),Phase(:,2),'r');
    plot(Phase(:,1),Ph(:,2),'b');
    plot(Phase(:,1),Ph(:,3),'k');    
end;