function [khi,FIT]= FitNoFit(Y,F)
% Empty fit function calculates Y=F only khi
% Y,F must be same size
N=numel(F);
khi=sum((Y-F).^2)/N;
FIT.Khi=khi;
end

