function [khi,FIT]= FitDoubleA(Y,F1,F2)
% Fit function calculates proportional coefficent Y=A1F1+A2F2 and khi
% Y,F must be same size
N=numel(Y);

Sf1f2=sum(F1.*F2);
Sf12=sum(F1.^2);
Sf22=sum(F2.^2);
Syf1=sum(Y.*F1);
Syf2=sum(Y.*F2);

A1=(Syf1*Sf22-Syf2*Sf1f2)/(Sf12*Sf22-Sf1f2^2);
A2=(Syf2*Sf12-Syf1*Sf1f2)/(Sf12*Sf22-Sf1f2^2);

khi=sum((Y-A1*F1-A2*F2).^2)/N;
FIT.Khi=khi;
FIT.A1=A1;
FIT.A2=A2;
FIT.B=0;
end

