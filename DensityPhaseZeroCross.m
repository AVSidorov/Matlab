function Phase=DensityPhaseZeroCross(trek)
tau=20e-9;
Plot=true;

Fbase=421748;
Tbase=1/Fbase;
TbaseTact=Tbase/tau;


Base=sin(2*pi*Fbase*[0:tau:(numel(trek)-1)*tau]');

Ind1=find(trek.*circshift(trek,-1)<=0);
i=find(trek(Ind1)<0&trek(Ind1+1)>0,1,'first');
Ind1=Ind1(i:end);


Ind2=find(Base.*circshift(Base,-1)<=0);

N=min([numel(Ind1),numel(Ind2)]);
Ph=(Ind1(1:N)-Ind2(1:N));
Ph=Ph-Ph(1);
[m,mi]=max(abs(Ph));
Ph=Ph*sign(Ph(mi));
Ph=Ph/TbaseTact*2*pi;
Ph=Ph/2/pi;
Phase(1:N,1)=[0:N-1]*Tbase/2;
Phase(:,2)=Ph;
if Plot
    figure;
    plot(Phase(:,1),Phase(:,2),'r');
    grid on; hold on;
end;
