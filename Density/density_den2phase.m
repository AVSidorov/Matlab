function ph=density_den2phase(den,freq)
% ph is phase addition per length unit  dPhase[rad/2/pi]/dL [meters] 
%% const in CGS
ELECTRONCHARGE = 4.8027E-10;
LIGHTVELOS     = 2.9979E10; 
LIGHTVELOS     = 299792458*100;
ELECTRONMASS   = 9.10938356E-28;

if nargin<2||isempty(freq)
    LAMBDA         = 0.22;%2.15E-1;%wavelength of the interferometer
    OMEGA          = 2*pi*LIGHTVELOS/LAMBDA;
    OMEGA=2*pi*135e9; %
end;

DENSCOEFF      = (ELECTRONCHARGE)^2/OMEGA/LIGHTVELOS/ELECTRONMASS;%*2*pi;

denCR            =  ELECTRONMASS*OMEGA^2/(4*pi*ELECTRONCHARGE^2);


ph=den*(DENSCOEFF*100); %*100 because working in meters
ph=-OMEGA/LIGHTVELOS*(sqrt(1-den/denCR)-1)*100/2/pi;
