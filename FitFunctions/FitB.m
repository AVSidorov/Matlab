function [khi,FIT]= FitB(Y,F)
% Fit function calculates background level Y=F+B and khi
% Y,F must be same size
N=numel(Y);
B=(sum(Y)-sum(F))/N;
khi=sum((Y-F-B).^2)/N;
FIT.Khi=khi;
FIT.A=1;
FIT.B=B;
end

