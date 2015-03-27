function K=KbyDelayIntegral(delay,Pulse,WindowWidth)
% Calculates intersected part of pulses in case of integration in winwow
% with certain width in dependence of delay
% window assumes symetric with center in max of pulse
% window must be odd
n=fix((WindowWidth)/2);
[m,mi]=max(Pulse);
BaseSum=sum(Pulse(mi-n:mi+n));
Ind=[mi-delay-n:mi-delay+n]';
K=0;
Ind=Ind(Ind>0&Ind<=numel(Pulse));
if ~isempty(Ind)
    K=sum(Pulse(Ind))/BaseSum;
end;
    