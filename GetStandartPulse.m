function [StandardPulse,FitSet]=GetStandartPulse(Pulses);
tic;
[Max,MaxInd]=max(Pulses(1,:));
NPulse=size(Pulses,1);%number of peaks
PulseN=size(Pulses,2);%number of points
%works bed imho pulse top is not symmetrical (tact too large)
% for i=1:NPulse
% p(i,1:3)=polyfit([MaxInd-1:MaxInd+1],Pulses(i,[MaxInd-1:MaxInd+1]),2);
% end;
% MaxI=-p(:,2)./(2*p(:,1));
% Shift=MaxI-11;
% for i=1:NPulse
% Pulses(i,:)=interp1([1:PulseN],Pulses(i,:),[1:PulseN]+Shift(i),'spline',0);
% end;
StandardPulse=Pulses(1,:);
for i=2:NPulse
    FitSet(i-1)=ShortFit(StandardPulse,Pulses(i,:));
    StandardPulse=((i-1)*StandardPulse+FitSet(i-1).Fitted)/i;

%     bool=Pulses(i,:)/max(Pulses(i,:))>=0.2;
%     FitSet(i-1)=ShortFit(StandardPulse(bool),Pulses(i,bool));
%     Pulse=interp([1:PulseN],Pulses(i,:),[1:PulseN]+FitSet(i-1).Shift,'spline','extrap');
%     Pulse=FitSet(i-1).A*Pulse+FitSet(i-1).B;
%     StandardPulse=((i-1)*StandardPulse+Pulse)/i;
end;
toc;