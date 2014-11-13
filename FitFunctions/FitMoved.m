function [khi,FIT]=FitMoved(Y,F,YInd,FInd,YBaseInd,FBaseInd,shift,ShiftFcn,FitFcn)
% Wrapper for using various shift and fit functions
FIT=[];
khi=inf;
[Yfit,Ffit]=ShiftFcn(Y,F,YInd,FInd,YBaseInd,FBaseInd,shift);
%% fitting
[khi,FIT]=FitFcn(Yfit,Ffit);