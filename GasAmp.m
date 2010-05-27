function G=GasAmp(ParamSet);
%Gives AmpLitude of 5.9keV in ADC Counts;
a=0.005;
b=0.9;
Amp=ParamSet.Amp;
C=0.007576780;
%C=0.03111;
Q=ParamSet.charge;
Vo=ParamSet.HV;
P=760*(1+ParamSet.P);

V=Vo-C*Q;
X=V/log(b/a)/a./P;
S=a*P;
K=V/log(b/a);
G=exp(K*(0.685*X-28.8-0.75*X/S)/1.05e3)*Amp;
