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

if any(shift>MaxShiftR)||any(shift<MaxShiftL)
    warning('Bad Shift');
    return;
end;

%% shifting F

Sh=fix(shift);
sh=shift-fix(shift);

% Fitting window is binded with F original form
% so we shift only not integer part and determine
% new intersection (shift indexes);


for i=1:numel(shift)
    FIndShNorm(:,i)=FInd-(FBaseInd-Sh(i));
    IndSh(:,i)=intersect(YIndNorm,FIndShNorm(:,i));

    Pulse(:,i)=interp1([1:numel(F)],F,IndSh(:,i)+(FBaseInd-Sh(i))-sh(i),'linear','extrap');
end;

%% output
Y=Y(IndSh(:,1)+YBaseInd);
F=Pulse;
FIT.MaxShiftL=MaxShiftL;
FIT.MaxShiftR=MaxShiftR;
FIT.ShiftInt=Sh;
FIT.ShiftFloat=sh;
FIT.FitInd=IndSh+YBaseInd;
