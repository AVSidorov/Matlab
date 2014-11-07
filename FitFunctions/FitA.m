function [khi,FIT]= FitA(Y,F)
% Fit function calculates proportional coefficent Y=AF and khi
% Y,F must be same size
N=numel(Y);
A=sum(Y.*F)/sum(F.^2);
khi=sum((Y-A*F).^2)/N;
FIT.Khi=khi;
FIT.A=A;
FIT.B=0;
end

