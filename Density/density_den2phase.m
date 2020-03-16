function ph=density_den2phase(den)
%% const in CGS
ELECTRONCHARGE = 4.8027E-10;
LIGHTVELOS     = 2.9979E10; 
ELECTRONMASS   = 9.1083E-28;

LAMBDA         = 0.22;%2.15E-1;%wavelength of the interferometer
OMEGA          = 2*pi*LIGHTVELOS/LAMBDA;
OMEGA=2*pi*136e9; %
DENSCOEFF      = (ELECTRONCHARGE)^2/OMEGA/LIGHTVELOS/ELECTRONMASS;%*2*pi;

ph=den*(DENSCOEFF*100); %*100 because working in meters