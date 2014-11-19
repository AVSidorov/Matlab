function [khi,FIT]= FitAB(Y,F,FIT)
% Fit function calculates linear coupling Y=AF+B and khi
% Y,F must be same size
N=numel(Y);
A=(N*sum(Y.*F)-sum(F)*sum(Y))/(N*sum(F.^2)-sum(F)^2);
B=(sum(Y)-A*sum(F))/N;
khi=sum((Y-A*F-B).^2)/N;
FIT.Khi=khi;
FIT.A=A;
FIT.B=B;


