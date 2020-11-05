function Out=geqdsk_by_astraTab(astraTab,In)
% input array a - flux surface numer [0-1]  1
% r radius of flux surface                  2
% x of center flux surface                  3
% y of center flux surface                  4
% t triangularity of flux surface           5
% e elongation of flux surface              6
% N electron density on flux surface        7
% T electron temperature on flux surface    8
% q safety factor on flux surface           9
if nargin<2
    In=geqdsk_ft2;
end;

Out=In;

Out.nxefit=height(astraTab);
Out.nyefit=Out.nxefit;
Out.rmagx=Out.rcentr+astraTab.shif(1);
Out.zmagx=astraTab.shiv(1);
Out.simagx=astraTab.psi(1)/2/pi;
Out.sibdry=astraTab.psi(end)/2/pi;

% fpol - Poloidal current function in m-T, F = RBt on uniform flux grid 
%now B~1/R so fpol is const
Out.fpol=Out.rcentr*Out.bcentr*ones(Out.nxefit,1);
Out.pres=astraTab.PRt;
Out.ffprim=astraTab.ff*Out.rcentr;
Out.pprime=astraTab.pf/Out.rcentr;
Out.qpsi=astraTab.q;


%% Construct R-Z mesh
r=linspace(Out.rgrid1,Out.rgrid1+Out.xdim,Out.nxefit);
z=linspace(Out.zmid-Out.zdim/2,Out.zmid+Out.zdim/2,Out.nyefit);
[r,z]=meshgrid(r,z);

%% construct points in polar coordinates
theta=linspace(0,2*pi,361);
theta(end)=[];
n=Out.nxefit;
x=zeros(n,360);
y=zeros(n,360);
psi=zeros(n,360);
for i=1:n
    x(i,:)=astraTab.shif(i)+astraTab.a(i)*(cos(theta)-astraTab.tria(i)*sin(theta).^2);
    y(i,:)=astraTab.shiv(i)+astraTab.a(i)*astraTab.elon(i)*sin(theta);
    psi(i,:)=astraTab.psi(i)/2/pi;
end
x=x+Out.rcentr;
Out.psi=griddata(x,y,psi,r,z,'cubic');
Out.psi(isnan(Out.psi(:)))=astraTab.psi(end)/2/pi;