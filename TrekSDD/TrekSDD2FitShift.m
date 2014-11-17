function [Y,F,FIT]=TrekSDD2FitShift(Y,F,YInd,FInd,YBaseInd,FBaseInd,shift)

%% indexes normalizing

YIndNorm=YInd-YBaseInd;
FIndNorm=FInd-FBaseInd;
[Ind,iY,iF]=intersect(YIndNorm,FIndNorm);

%% shifting F

Sh=fix(shift);
sh=shift-fix(shift);

% in case TrekSet IndSh is necessary for determenation used part of
% original StandardPulse
FIndShNorm=FInd-(FBaseInd-Sh);
IndSh=intersect(YIndNorm,FIndShNorm);

Pulse=TrekSDDGetFitPulse(F,-shift);

%% output
FIT.MaxInd=YBaseInd;
FIT.FitInd=Ind+YBaseInd; % window in trek is constant
FIT.FitIndPulse=IndSh+(FBaseInd-Sh); % window in Stp moves
FIT.FitPulse=Pulse;
FIT.FitPulseN=numel(Pulse);

Y=Y(Ind+YBaseInd);
F=Pulse(Ind+FBaseInd);

