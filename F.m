function y=F(E,T)
Ne=10E+13; %electron density
Ni=10E+13; %ion density
Zeff=1.2;  %Zeff effective ion charge
KHIn=0.015;   % Hydrogen ionization potential
y=Ne*Ni*Zeff^2*(KHIn/T)^0.5*exp(-E/T)*exp(-0.12*50./(E.^3.12))*(1-exp(-345.55./(E.^2.7)));

