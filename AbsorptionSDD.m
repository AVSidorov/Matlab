function [A,TBe,TSi]=AbsorptionSDD(FilterThikness,E)
r0=2.817940289458e-15;%m
h=4.13566751691e-15; %eV*s
c=299792458;%m/s
roBe=1.848; %g/cm3
mmolBe=9.012182; %g/mol;
Na=6.0221412927e23; %Avogadro number
nBe=roBe/mmolBe*Na; % 1/cm3
nBe=nBe*1e6; %1/m3
mmolSi=28.0856;%g/mol
roSi=2.33;%g/cm3
nSi=roSi/mmolSi*Na; % 1/cm3
nSi=nSi*1e6; %1/m3

d=FilterThikness;
dSi=450;

ffBe=load('d:\!scn\efield\be\be.dat','-ascii');
if nargin<2
 E=ffBe(:,1);
end;
ffSi=load('d:\!scn\efield\be\si.dat','-ascii');

f=E/h;
l=c./f;

fBe=interp1(ffBe(:,1),ffBe(:,3),E,'linear');
muBe=2*r0*l.*fBe;
TBe(:,1)=E;
TBe(:,2)=exp(-nBe*muBe*d*1e-6);

fSi=interp1(ffSi(:,1),ffSi(:,3),E,'linear');
muSi=2*r0*l.*fSi;
TSi(:,1)=E;
TSi(:,2)=exp(-nSi*muSi*dSi*1e-6);
A(:,1)=E;
A(:,2)=TBe(:,2).*(1-TSi(:,2));