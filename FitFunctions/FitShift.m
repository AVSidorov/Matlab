function [Y,F,FIT]=FitShift(Y,F,YInd,FInd,YBaseInd,FBaseInd,shift)
%function for shifting f relative Y and choosing FitIndexes
cut='Y';

N=min([numel(YInd),numel(FInd)]);

%% indexes normalizing

YIndNorm=YInd-YBaseInd;
FIndNorm=FInd-FBaseInd;
[Ind,iY,iF]=intersect(YIndNorm,FIndNorm);
if numel(Ind)<N 
    warning('Bad regions. Fit Indexes will be cutted.');
    if strcmpi(cut,'Y')
        YIndNorm=YIndNorm(iY);
    else
        FIndNorm=FIndNorm(iF);
    end;
end;
%% shift range determination and check

L1=FIndNorm(1)-YIndNorm(1);
L2=YIndNorm(end)-FIndNorm(end);
MaxShiftL=min([-L1,L2]);
MaxShiftR=-min([L1,-L2]);

if shift>MaxShiftR||shift<MaxShiftL
    warning('Bad Shift');
    return;
end;

%% shifting F

Sh=fix(shift);
sh=shift-fix(shift);

% Fitting window is binded with F original form
% so we shift only not integer part and determine
% new intersection (shift indexes);

FIndShNorm=FInd-(FBaseInd-Sh);
IndSh=intersect(YIndNorm,FIndShNorm);

Pulse=interp1([1:numel(F)],F,IndSh+(FBaseInd-Sh)-sh,'linear','extrap');

%% output
Y=Y(IndSh+YBaseInd);
F=Pulse;
FIT.MaxShiftL=MaxShiftL;
FIT.MaxShiftR=MaxShiftR;
FIT.ShiftInt=Sh;
FIT.ShiftFloat=sh;
FIT.FitInd=IndSh+YBaseInd;
FIT.FitIndPulse=IndSh+(FBaseInd-Sh);
