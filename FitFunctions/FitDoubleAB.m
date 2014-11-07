function [khi,FIT]= FitDoubleAB(Y,F1,F2)
% Fit function calculates proportional coefficent Y=A1F1+A2F2 and khi
% Y,F must be same size
n=numel(Y);

Sf1f2=sum(F1.*F2);
Sf12=sum(F1.^2);
Sf22=sum(F2.^2);
Syf1=sum(Y.*F1);
Syf2=sum(Y.*F2);
Sy=sum(Y);
Sf1=sum(F1);
Sf2=sum(F2);

A1=(Sf2^2*Syf1 + Sf1*Sf22*Sy - Sf2*Sf1f2*Sy - Sf1*Sf2*Syf2 - Sf22*Syf1*n + Sf1f2*Syf2*n)/(Sf22*Sf1^2 - 2*Sf1*Sf2*Sf1f2 + Sf12*Sf2^2 + n*Sf1f2^2 - Sf12*Sf22*n);
A2=(Sf1^2*Syf2 + Sf2*Sf12*Sy - Sf1*Sf1f2*Sy - Sf1*Sf2*Syf1 - Sf12*Syf2*n + Sf1f2*Syf1*n)/(Sf22*Sf1^2 - 2*Sf1*Sf2*Sf1f2 + Sf12*Sf2^2 + n*Sf1f2^2 - Sf12*Sf22*n);
B=(Sf1f2^2*Sy - Sf12*Sf22*Sy + Sf2*Sf12*Syf2 + Sf1*Sf22*Syf1 - Sf1*Sf1f2*Syf2 - Sf2*Sf1f2*Syf1)/(Sf22*Sf1^2 - 2*Sf1*Sf2*Sf1f2 + Sf12*Sf2^2 + n*Sf1f2^2 - Sf12*Sf22*n);

khi=sum((Y-A1*F1-A2*F2-B).^2)/n;
FIT.Khi=khi;
FIT.A1=A1;
FIT.A2=A2;
FIT.B=B;
end

