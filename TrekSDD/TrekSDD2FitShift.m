function [Y,F,FIT]=TrekSDD2FitShift(Y,F,YInd,FInd,YBaseInd,FBaseInd,shift)

%% indexes normalizing

YIndNorm=YInd-YBaseInd;
FIndNorm=FInd-FBaseInd;
[Ind,iY,iF]=intersect(YIndNorm,FIndNorm);
%% shifting F

Sh=fix(shift);
sh=shift-fix(shift);

% Fitting window is binded with F original form
% so we shift only not integer part and determine
% new intersection (shift indexes);

FIndShNorm=FInd-(FBaseInd-Sh);
IndSh=intersect(YIndNorm,FIndShNorm);

Pulse=TrekSDDGetFitPulse(F,-sh);

%% output
FIT.MaxInd=YBaseInd;
FIT.FitInd=IndSh+YBaseInd;
FIT.FitIndPulse=IndSh+(FBaseInd-Sh);
FIT.FitPulse=Pulse;
FIT.FitPulseN=numel(Pulse);

Y=Y(IndSh+YBaseInd);
F=Pulse(IndSh+(FBaseInd-Sh));

