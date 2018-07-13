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
for i=1:numel(shift)
    Pulse(:,i)=TrekSDDGetFitPulse(F,-shift(i));
    FitIndPulse(:,i)=Ind+(FBaseInd-Sh(i));
end;

%% output
Y=Y(Ind+YBaseInd);
F=Pulse(Ind+FBaseInd,:);

FIT.MaxInd=YBaseInd;
FIT.FitInd=Ind+YBaseInd; % window in trek is constant
FIT.FitIndPulse=FitIndPulse; % window in Stp moves
FIT.FitPulse=Pulse;
FIT.FitPulseN=size(Pulse,1);
FIT.Y=Y;
FIT.F=F;
FIT.N=numel(Y);
FIT.Shift=shift;



