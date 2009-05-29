function Spectr=MaxwByAngelTime(alpha,Time,T,N,MaxwTab);
a=8;
%NeBase=1E13;
NeBase=1;
L=1000;
dr=0.1;

f1=figure;

SpectrSum=zeros(size(MaxwTab,1)-1,2);
SpectrSum(:,1)=MaxwTab(2:end,1);

TeMax=0;

for Angl=(alpha-0.5):dr/1.15:alpha+0.5
rmin=abs(1.15*Angl);
figure(f1);
subplot(3,1,1);
title(['Time is ', num2str(Time,'%4.2f ms'),' Angel is ', num2str(Angl,'%2.1f deg'),' Rmin is ', num2str(rmin,'%4.2f cm')]);
hold on; grid on;
tic;
TeProfile(:,1)=T(:,1);
TeProfile(:,2)=T(:,find(Time>=T(1,:),1,'last'));
TeProfile(:,3)=T(:,find(Time<=T(1,:),1,'first'));
TeProfile(1,4)=Time;
for i=2:size(TeProfile,1)
    TeProfile(i,4)=interp1(TeProfile(1,2:3),TeProfile(i,2:3),Time);
end;
fprintf('Te profile calculation time is %4.2f sec\n',toc);
plot(TeProfile(2:end,1),TeProfile(2:end,2:4),'.-');
subplot(3,1,2);
hold on; grid on;
tic;
NeProfile(:,1)=N(:,1);
NeProfile(:,2)=N(:,find(Time>=N(1,:),1,'last'));
NeProfile(:,3)=N(:,find(Time<=N(1,:),1,'first'));
NeProfile(1,4)=Time;
for i=2:size(NeProfile,1)
    NeProfile(i,4)=interp1(NeProfile(1,2:3),NeProfile(i,2:3),Time);
end;
fprintf('Ne profile calculation time is %4.2f sec\n',toc);
plot(NeProfile(2:end,1),NeProfile(2:end,2:4),'.-');

tic;
TeMaxChord=0;
MaxwSp(:,1)=MaxwTab(2:end,1);
Spectr=zeros(size(MaxwSp,1),2);
Spectr(:,1)=MaxwSp(:,1);
l(1)=sqrt((rmin+dr)^2-rmin^2);
dl(1)=l(1);
r(1)=rmin+dr;
a=min([max(TeProfile(:,1)),max(NeProfile(:,1))]);
for i=2:(a-rmin)/dr
    r(i)=rmin+i*dr;

    R(1)=find(r(i)>=TeProfile(:,1),1,'last');
    R(2)=find(r(i)<=TeProfile(:,1),1,'first');
    Te=interp1(TeProfile(R,1),TeProfile(R,4),r(i));
    TeMax=max([TeMax,Te]);
    TeMaxChord=max([TeMaxChord,Te]);
    R(1)=find(r(i)>=NeProfile(:,1),1,'last');
    R(2)=find(r(i)<=NeProfile(:,1),1,'first');
    Ne=interp1(NeProfile(R,1),NeProfile(R,4),r(i));

    l(i)=sqrt(r(i)^2-rmin^2);
    dl(i)=l(i)-l(i-1);

    MaxwSp=MaxwSpByTe(Te,MaxwTab);
    Spectr(:,2)=Spectr(:,2)+MaxwSp(:,2)*dl(i)*(Ne/NeBase)^2;
    %Spectr(find(MaxwSp(:,2)>1e-5),2)=Spectr(find(MaxwSp(:,2)>1e-5),2)+MaxwSp(find(MaxwSp(:,2)>1e-5),2)*dl(i)*(Ne/NeBase)^2;
end;
fprintf('Spectr  calculation time is %4.2f sec\n',toc);
fprintf('Maximal Te at this Chord is %4.3f keV\n',TeMaxChord);
MaxwSpMaxTe=MaxwSpByTe(TeMax,MaxwTab);
SpectrSum(:,2)=SpectrSum(:,2)+Spectr(:,2)*0.1;
MaxA1=max(MaxwSpMaxTe(:,2));
MaxA2=max(Spectr(:,2));
MaxA3=max(SpectrSum(:,2));
subplot(3,1,3);
hold on; grid on;
        plot(r(:),dl(:),'.-r');
        axis([0,a,dr,8]);
figure;
title(['Time is ', num2str(Time,'%4.2f ms'),' Angel is ', num2str(Angl,'%4.2f deg'),' Rmin is ', num2str(rmin,'%4.3f cm'),' TeMax is ', num2str(TeMax,'%4.3f keV')]);
hold on; grid on;
        plot(Spectr(:,1),Spectr(:,2)*MaxA1/MaxA2,'.-r');
        plot(Spectr(:,1),MaxwSpMaxTe(:,2)*MaxA1/MaxA1,'-b');
        plot(SpectrSum(:,1),SpectrSum(:,2)*MaxA1/MaxA3,'*-g');
        set(gca,'YScale','log');
end;
