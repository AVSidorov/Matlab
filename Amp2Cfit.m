function [C,dVPVQ]=Amp2Cfit(Amp);
A=0.00023088005376
B=0.005852816303349;
a=0.005; %So A&B is fitted for this value of a, but correct is 0.0025
b=0.9;

Date=Amp(1,1);
Po=Amp(:,2)+1;
Vo=Amp(:,3);
Qo=Amp(:,4);


figure;
plot(Qo,Amp(:,5),'*r-');
grid on; hold on;

p1=polyfit(Qo,log(Amp(:,5)),2);
p2=polyfit(Qo,log(Amp(:,5)),1);
p3=polyfit(Qo,Amp(:,5),1);
p4=polyfit(Qo,Amp(:,5),2);

plot([0;Qo],exp(polyval(p1,[0;Qo])),'b');
plot([0;Qo],exp(polyval(p2,[0;Qo])),'m');
plot([0;Qo],polyval(p3,[0;Qo]),'k');
plot([0;Qo],polyval(p4,[0;Qo]),'g');

fprintf('Blue       is %6.3f\n',exp(polyval(p1,0)));
fprintf('Magenta    is %6.3f\n',exp(polyval(p2,0)));
fprintf('Black      is %6.3f\n',polyval(p3,0));
fprintf('Green      is %6.3f\n',polyval(p4,0));

Go=input('Input Go. Default is blue \n');
if isempty(Go) Go=exp(polyval(p1,0)); end;
close(gcf);


E=Vo/log(b/a)/a;
K=E*a;
G=Amp(:,5)*5e2;

P=E(1)*A./(log(Go*5e2)./K(1)-B)/760; %this is value of P

dP=Po(1)-P;
P=Po-dP;

fprintf('dP is %7.4f\n',dP);

X=E./(P*760);

k1=A./(log(b/a)^2*a*P*760);
k2=B/log(b/a);

V=(-k2+sqrt(k2^2+4*k1.*log(G)))./(2*k1);
dV=Vo-V;

figure;
plot(Qo,dV,'*r-');
grid on; hold on;
Cfit=sum(dV)/sum(Qo);
plot([0;Qo],[0;Cfit*Qo],'b');
C(1,1)=Date;
C(1,2)=Po(1);
C(1,3)=Vo(1);
C(1,4)=Cfit;

dVPVQ(:,2)=Po;
dVPVQ(:,1)=Date;
dVPVQ(:,3)=Vo;
dVPVQ(:,4)=Qo;
dVPVQ(:,5)=dV;

assignin('base','C1',C);
evalin('base','C=[C;C1];');

assignin('base','dVPVQ1',dVPVQ);
evalin('base','dVPVQ=[dVPVQ;dVPVQ1];');
pause;
close(gcf);


















