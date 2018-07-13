function [khi,FIT]=FitMovedDouble(Y,F,YInd,FInd,YBaseInd,FBaseInd,shift,ShiftFcn,FitFcn)
% Wrapper for using various shift and fit functions 
% This function is used for one fiting for to different shifted pulses in one way 
FIT=[];
khi=inf;
[Yfit,F1fit]=ShiftFcn(Y,F,YInd,FInd,YBaseInd,FBaseInd,shift(1));
[Yfit,F2fit]=ShiftFcn(Y,F,YInd,FInd,YBaseInd,FBaseInd,shift(2));
%% fitting
[khi,FIT]=FitFcn(Yfit,F1fit,F2fit);
