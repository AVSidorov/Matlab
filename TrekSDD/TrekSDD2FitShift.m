function [Y,F,FIT]=TrekSDD2FitShift(Y,F,YInd,FInd,YBaseInd,FBaseInd,shift)

%% indexes normalizing

YIndNorm=YInd-YBaseInd;
FIndNorm=FInd-FBaseInd;
[Ind,iY,iF]=intersect(YIndNorm,FIndNorm);
%% Determination available shifts
L1=FIndNorm(1)-YIndNorm(1);
L2=YIndNorm(end)-FIndNorm(end);
MaxShiftL=min([-L1,L2]);
MaxShiftR=-min([L1,-L2]);

%% shifting F

Sh=fix(shift);
sh=shift-fix(shift);

% Fitting window is binded with F original form
% so we shift only not integer part and determine
% new intersection (shift indexes);
FIndShNorm=FInd-(FBaseInd-Sh);
IndSh=intersect(YIndNorm,FIndShNorm);

Pulse=TrekSDDGetFitPulse(F,-sh);
%% expansion FitPulse
if shift>MaxShiftR
    Pulse=[zeros(Sh-MaxShiftR,1);Pulse];
end;    
if shift<MaxShiftL
    Pulse=[Pulse;zeros(MaxShiftL-Sh,1)];
end;    
%% output
FIT.MaxInd=YBaseInd;
FIT.FitInd=IndSh+YBaseInd;
FIT.FitIndPulse=IndSh+(FBaseInd-Sh);
FIT.FitPulse=circshift(Pulse,Sh);
FIT.FitPulseN=numel(Pulse);

Y=Y(IndSh+YBaseInd);
F=Pulse(IndSh+(FBaseInd-Sh));

