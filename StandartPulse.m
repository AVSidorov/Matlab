function V1=StandartPulse;
a=0.0050; %in cm wire radius
b=0.9;    %in cm counter radius  
Eps0=8.85e-12/1e2; % 8.85pF/m in F/cm
mu=1.7;          %mobility cm^2/sec/atm/V
P=1;             %pressure atm
HV=1700;        %counter voltage Volts
Cr=0.01e-6; %differentiation circut Capacity
R1=0;       %differentiation circut charge resistor
R2=1;       %differentiation circut discharge resistor

C=2*pi*Eps0/log(b/a); %counter capacity
t0=a^2*pi*Eps0*P/(mu*C*HV);
t0=t0*0.5;

dt=1e-9;
t=[0:dt:1e-6];
tsize=max(size(t));
V1(:,1)=t';

Q=0;
for i=1:tsize
 Vo=log(1+t(i)/t0);
 V=Vo-Q/Cr;
 I=V/(R1+R2);
 V1(i,2)=V-I*R1;
 Q=Q+dt*I;
end;
plot(V1(:,1)*1e6,V1(:,2)/max(V1(:,2)),'.-','Color',[rand,rand,rand]);