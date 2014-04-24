function Phase=DensityPhaseZeroCross(trek)
tau=20e-9;
Plot=true;

Fbase=421748;
Tbase=1/Fbase;
WinWidth=pi/2; % window for reducing point in noise case



IndPreCross=find(trek.*circshift(trek,-1)<0|trek==0); %<= gives double indexing
if IndPreCross(end)==numel(trek) IndPreCross(end)=[]; end;
i=find(trek(IndPreCross)<0&trek(IndPreCross+1)>0,1,'first');
IndPreCross=IndPreCross(i:end);
IndCross=IndPreCross-trek(IndPreCross)./(trek(IndPreCross+1)-trek(IndPreCross));

i=1;
while i<numel(IndCross)
    ind=find(IndCross>=IndCross(i)&IndCross<IndCross(i)+Tbase*WinWidth/(2*pi)/tau);
    if numel(ind)>1
        IndCross(i)=mean(IndCross(ind));
        IndCross(ind(2:end))=[];
    end;
    i=i+1;
end;

TimeCross=(IndCross-1)*tau;

TimeCrossBase=[0:Tbase/2:(numel(trek)-1)*tau]';

N=min([numel(TimeCross),numel(TimeCrossBase)]);
Ph=(TimeCrossBase(1:N)-TimeCross(1:N));
Ph=Ph/Tbase*2*pi;

Ph=Ph-Ph(1);
[m,mi]=max(abs(Ph));
Ph=Ph*sign(Ph(mi));

Phase(1:N,1)=[0:N-1]*Tbase/2;
Phase(:,2)=Ph/(2*pi);
if Plot
    figure;
    plot(Phase(:,1),Phase(:,2),'r');
    grid on; hold on;
end;
