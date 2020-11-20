function Out=geqdsk_gsef2geqdsk(In)
Out.Desc=cell(6,1);
Out.idum=3;
Out.nxefit=65;
Out.nyefit=65;

Out.xdim=range(In.XX(:));
Out.zdim=range(In.YY(:));
Out.rcentr=0;
Out.rgrid1=min(In.XX(:));
Out.zmid=0.5*(max(In.YY(:))+min(In.YY(:)));
Out.rmagx=In.XX(1,1);
Out.zmagx=In.YY(1,1);
Out.simagx=In.PSI(1,1)/2/pi;    % /2/pi because in geqdsk  flux is in Weber/rad
Out.sibdry=In.PSI(end,1)/2/pi;  % /2/pi because in geqdsk  flux is in Weber/rad
Out.bcentr=0;
Out.cpasma=0;
Out.xdum=0;
% Make efit grid
[R,Z]=meshgrid(linspace(Out.rgrid1,Out.rgrid1+Out.xdim,Out.nxefit),linspace(Out.zmid-Out.zdim/2,Out.zmid+Out.zdim/2,Out.nyefit));
rho=linspace(0,1,Out.nxefit);

Out.fpol=interp1(In.PSIn_grid,In.ipol_grid,rho,'pchip');
Out.pres=interp1(In.PSIn_grid,In.pressure,rho,'pchip');
Out.ffprim=interp1(In.PSIn_grid,In.dum2,rho,'pchip');
Out.pprime=interp1(In.PSIn_grid,In.dum1,rho,'pchip');
Out.psi=griddata(In.XX,In.YY,In.PSI/2/pi,R,Z,'cubic'); % /2/pi because in geqdsk  flux is in Weber/rad
Out.psi(isnan(Out.psi(:)))=max(Out.psi(:));
Out.qpsi=interp1(In.PSIn_grid,In.qprof,rho,'pchip');

Out.nbdry=length(In.Rb)+1;
Out.nlim=0;
Out.rbdry=[In.Rb;In.Rb(1)];
Out.zbdry=[In.Zb;In.Zb(1)];
Out.xlim=[];
Out.ylim=[];

