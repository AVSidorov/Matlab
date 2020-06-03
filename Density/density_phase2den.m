function [den,den0]=density_phase2den(ph,OMEGA)
% converts dPhase[rad/2/pi]/dL [meters]  to density 1/cm-3
%% const in CGS
ELECTRONCHARGE = 4.8027E-10;
LIGHTVELOS     = 2.9979E10; 
ELECTRONMASS   = 9.1083E-28;

LAMBDA         = 0.22;%2.15E-1;%wavelength of the interferometer
if nargin<2||isempty(freq)
    LAMBDA         = 0.22;%2.15E-1;%wavelength of the interferometer
    OMEGA          = 2*pi*LIGHTVELOS/LAMBDA;
%     OMEGA=2*pi*135e9; %
end;

DENSCOEFF      = (ELECTRONCHARGE)^2/OMEGA/LIGHTVELOS/ELECTRONMASS;%*2*pi;
denCR            =  ELECTRONMASS*OMEGA^2/(4*pi*ELECTRONCHARGE^2);

den=ph/(DENSCOEFF*100); %*100 because working in meters
den0=ph/(DENSCOEFF); %*100 because working in meters
den=denCR*(1-(1-ph*2*pi*LIGHTVELOS/OMEGA/100).^2);
den=denCR*(1-(1-ph*2*pi*LIGHTVELOS/OMEGA).^2);