function Spectr=MaxwByAngelTime(alpha,Time,T,N,MaxwTab);
a=8;
NeBase=1E13;
L=1000;
rmin=1.15*alpha;
dr=0.1;

TeProfile(:,1)=T(:,1);
TeProfile(:,2)=T(:,find(Time>=T(1,:),1,'last'));
TeProfile(:,3)=T(:,find(Time<=T(1,:),1,'first'));
TeProfile(1,4)=Time;
for i=2:size(TeProfile,1)
    TeProfile(i,4)=interp1(TeProfile(1,2:3),TeProfile(i,2:3),Time);
end;

NeProfile(:,1)=N(:,1);
NeProfile(:,2)=N(:,find(Time>=N(1,:),1,'last'));
NeProfile(:,3)=N(:,find(Time<=N(1,:),1,'first'));
NeProfile(1,4)=Time;
for i=2:size(NeProfile,1)
    NeProfile(i,4)=interp1(NeProfile(1,2:3),NeProfile(i,2:3),Time);
end;

MaxwSp(:,1)=MaxwTab(2:end,1);
Spectr=zeros(size(MaxwSp,1),2);
Spectr(:,1)=MaxwSp(:,1);
TeMax=0;
ln=sqrt((rmin+dr)^2-rmin^2);
dl(1)=ln;
a=min([max(TeProfile(:,1)),max(NeProfile(:,1))]);
for i=2:(a-rmin)/dr
    lnn=ln;
    rn=rmin+i*dr;

    R(1)=find(rn>=TeProfile(:,1),1,'last');
    R(2)=find(rn<=TeProfile(:,1),1,'first');
    Te=interp1(TeProfile(R,1),TeProfile(R,4),rn);
    TeMax=max([TeMax,Te]);
    R(1)=find(rn>=NeProfile(:,1),1,'last');
    R(2)=find(rn<=NeProfile(:,1),1,'first');
    Ne=interp1(NeProfile(R,1),NeProfile(R,4),rn);

    ln=sqrt(rn^2-rmin^2);
    dl(i)=ln-lnn;

    MaxwSp=MaxwSpByTe(Te,MaxwTab);
    Spectr(:,2)=Spectr(:,2)+MaxwSp(:,2)*dl(i)*(Ne/NeBase)^2;
end;
MaxwSpMaxTe=MaxwSpByTe(TeMax,MaxwTab);
MaxA1=max(MaxwSpMaxTe(:,2));
MaxA2=max(Spectr(:,2));
    figure;
        hold on; grid on;
        set(gca,'YScale','log');
        plot(Spectr(:,1),Spectr(:,2),'.-r');
        plot(Spectr(:,1),MaxwSpMaxTe(:,2)*MaxA2/MaxA1,'-b');
