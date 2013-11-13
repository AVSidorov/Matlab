function T=AbsorptionSDD(FilterThikness,E)
r0=2.817940289458e-15;%m
h=4.13566751691e-15; %eV*s
c=299792458;%m/s
roBe=1.848; %g/cm3
mmolBe=9.012182; %g/mol;
n=roBe/mmolBe*6.0221412927e23; % 1/cm3
n=n*1e6; %1/m3
d=FilterThikness;
ffBe=load('d:\!scn\efield\be\be.dat','-ascii');
% ffSi=load('si.dat','-ascii');
if nargin<2
 E=ffBe(:,1);
end;
f=E/h;
l=c./f;
f2=interp1(ffBe(:,1),ffBe(:,3),E,'linear');
mu=2*r0*l.*f2;
T(:,1)=E;
T(:,2)=exp(-n*mu*d*1e-6);