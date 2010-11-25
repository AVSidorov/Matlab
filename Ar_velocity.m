function V=Ar_velocity(E,P);
% E in V/cm, P in Atm
% dependence V from E/P is proportional only at low fields
% at very high fields V is ~sqrt(E/P)
% Near the counter wire we have intermidiate fields
% Smirnov B.M. UFN 95,1,p.75 (1965) review
% Hornbeck J.A. Phys. Rev. 84,4,p.615 (1951) measurements
T=295/11604.5; % 22C in eV
% Srez=Srez(1ev)[1+A*ln(1eV/E)]^2 in e-16cm^2 A=0.0543 Srez(1ev=55.3 or 44.2 spr. Fiz.Velitch)
% crossection of resonance charge exchange
% approximation Maiorov Zvenigorod 2007
% E- kinetic energy of ion if atom is still E~3/2*T
% beta=e*E/2*T*N*Srez
% N(1atm)=2.686774(47)e25/m^3 or e19/cm^3 Loshmidt konst N~P
% if T in eV then e elementary charge isn't neccesary
% 1eV=11604.5K=1.6021892e-19J=2.4179696e14Hz
% M atom of Ar is 6.635e-26 kg or e-23g
% J/kg is m^2/sek^2
M=6.635e-26;                                %in kg
Srez=55.3e-16*(1+0.0543*log(1/(1.5*T)))^2;  %cm^2
N=2.686774e19*P;                            %1/cm^3
beta=E./(2*T*N*Srez);
V=sqrt(2*T*1.6021892e-19/M)*1e2*0.48*beta.*(1+0.13*beta.^2).^-0.25;  %in cm/sek