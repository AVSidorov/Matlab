function [K,G]=Gseries(V,P);
% V in volts P in atm
% Eo in V/cm Po in torr
% log(G)/K=(A00+F*A01+F^2*A02)+(A10+F*A11)*Xo+A20*Xo.^2+A30*Xo.^3+A40*Xo.^4+%B00*Xo./So;
% where
% K=Eo*a
% S=Po*a
% F is fraction of CH4 P10(Ar 90%,CH4 10%) => F=0.1
% X=Eo/Po
% E=Vo/log(b/a)/a
A00=-0.017*1e-1;
A01=-0.513*1e-1;
A02=0.517*1e-1;
A10=0.371*1e-3;
A11=-0.0827*1e-3;
A20=-0.102*1e-5;
A30=0.167*1e-8;
A40=-0.998*1e-12;
B00=-0.626*1e-5;
F=0.1;
k=628;


a=0.0025;
b=0.9;
E=V/log(b/a)/a;
P=P*760;

A0=(A00+F*A01+F^2*A02);
A1=(A10+F*A11);
A2=A20;
A3=A30;
A4=A40;
B=B00;

X=E/P;
S=P*a;
K=E*a;
G=exp(K*(A0+A1*X+A2*X^2+A3*X^3+A4*X^4+B*X/S))/k;
P1=a*A0+2*a*A1*X+3*a*A2*X^2+4*a*A3*X^3+5*a*A4*X^4+2*B*E/P^2;
P2=2*(10*a*A4*E^3/P^4+6*a*A3*E^2/P^3+3*a*A2*E/P^2+a*A1/P+B/P^2);
P3=6*a*(20*A4*E^2/P^4+4*A3*E/P^3+A2/P^2);
P4=24*a*(5*A4*E/P^4+A3/P^3);
P5=120*a*A4/P^4;
K=[(P1^5+5*P1*P4+10*P1^2*P3+9*P1^3*P2+15*P1*P2^2+10*P2*P3+P5)/120;(P1^4+6*P1^2*P2+4*P1*P3+3*P2^2+P4)/24;(P1^3+3*P1*P2+P3)/6;(P1^2+P2)/2;P1;1];