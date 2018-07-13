function tokamak
%Function calculates main plasma parameters in tokamak
%suck as plasma frequency gyro frequencies and so on
%not completed

% CGS system
 me=9.1e-28; 
 mp=1.6726485e-24; %proton mass in gramm
 mn=1.6749543e-24; %neutron mass in gramm
 
 
 c=2.99792458e10;
 e=1.6021892e-19/(10/c); %1 franklin = 1/(3*c)Coulomb
 %1eV=1.6021892e-19J 1erg=1e-7J
 eV=1.6021892e-12;
 T=5e2;
 esu=10/c; %statkulon=franklin in Coulombs
 C=1/esu;  %C Coulomb in esu;
 
 R=55;
 a=8;
 B=2e4; %in Gauss
 I=25e3*C; %in esu/s
 Uloop=4;
 Bp=(4*pi/c)*I/(2*pi*a); %poloidal field at plasma edge
 Te=400*eV;
 Ti=100*eV;
 
 we=e*B/(me*c); %electron cyclotron round frequency
 wp=e*B/(mp*c); %ion cyclotron round frequency
 ve=we/(2*pi);  %electron cyclotron frequency
 vp=wp/(2*pi);  %ion cyclotron frequency
 Vte=sqrt(2*Te/me); % electron thermal velocity
 Vtp=sqrt(2*Ti/mp); % ion thermal velocity
 re=me*Vte*c/(e*B); % electron larmour radius
 rp=mp*Vtp*c/(e*B); % ion larmour radius