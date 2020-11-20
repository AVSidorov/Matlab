function Out=geqdsk_ft2
% function makes empty geqdsk struct with FT-2 tokamak geometry
% Default current and toroidal magnetic field values are added as well.
%% ft-2 constants
rlim=0.0785; %in meters
a=rlim;     
R=0.55;     %in meters
Bt=2;       %in Tesla
Ip=22e3;    %in Amps

%% define domain and initialize values in geqdsk terms
idum=3;
nxefit=50;     
nyefit=nxefit;

xdim=1.01*rlim*2;    %X Size of domain in meters
zdim=1.01*rlim*2;    %Z Size of domain in meters
rcentr=R;  %Reference vacuum toroidal field meters
rgrid1=R-xdim/2;  %R of left side of domain
zmid=0;    %Z at the middle of the domain

rmagx=rcentr;   %R Location of magnetic axis
zmagx=0;   %Z Location of magnetic axis
simagx=0;  %Poloidal flux at the axis (Weber / rad)
sibdry=1;  %Poloidal flux at plasma boundary (Weber / rad)
bcentr=Bt; %Reference vacuum toroidal field T

cpasma=Ip;   %Plasma current in Amps
xdum=0;

fpol=zeros(nxefit,1);       %Poloidal current function in m-T, F = RBt on uniform flux grid
pres=zeros(nxefit,1);        %Plasma pressure in nt/m^2 on uniform flux grid
ffprim=zeros(nxefit,1);     %FF’(y) in (mT)2 / (Weber /rad) on uniform flux grid
pprime=zeros(nxefit,1);     %P’(y) in (nt /m2) / (Weber /rad) on uniform flux grid
psi=zeros(nyefit,nxefit);   %Poloidal flux in Weber/rad on the rectangular grid points
qpsi=zeros(nxefit,1);                %q values on uniform flux grid from axis to boundary

%The toroidal current JT related to P’(y) and FF’(y) through
% JT (Amp/m2) = R P’(y) + FF’(y) / R


%% Boundary and limiters
nbdry=51;
nlim=49 ;
rcore=rcentr; %center of plasma core(boundary)
% Plasma boundary
    angl=2*pi*linspace(0,1,nbdry)';
    rbdry=a*cos(angl)+rcore; 
    zbdry=a*sin(angl)+zmagx; 
    bdry=reshape([rbdry,zbdry]',1,[]);
% Wall boundary
    angl=2*pi*linspace(0,1,nlim)';
    xlim=rlim*cos(angl)+rcentr; 
    ylim=rlim*sin(angl)+zmid;
    limiter=reshape([xlim,ylim]',1,[]);
 
Out.Desc=cell(6,1);
Out.idum = idum;
Out.nxefit = nxefit;
Out.nyefit = nyefit;
        
Out.xdim= xdim;
Out.zdim= zdim;
Out.rcentr=rcentr;
Out.rgrid1=rgrid1;
Out.zmid=zmid;
        
Out.rmagx=rmagx;
Out.zmagx=zmagx;
Out.simagx=simagx;
Out.sibdry=sibdry;
Out.bcentr=bcentr;
        
Out.cpasma=cpasma;
Out.xdum=xdum;
  
        
Out.fpol=fpol;
Out.pres=pres;
Out.ffprim=ffprim;
Out.pprime=pprime;
Out.psi=psi;
Out.qpsi=qpsi;
        
Out.nbdry=nbdry;
Out.nlim=nlim;
Out.rbdry=rbdry;
Out.zbdry=zbdry;
Out.xlim=xlim;
Out.ylim=ylim;    
