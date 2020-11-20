function Out=geqdsk_by_arxyteNTq(arxyteNT,In)
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

Out.rmagx=Out.rcentr+arxyteNTq(1,3);
Out.zmagx=arxyteNTq(1,4);

%now B~1/R so fpol is const
Out.fpol=Out.rcentr*Out.bcentr*ones(Out.nxefit,1);
Out.pres=arxyteNTq(:,7).*arxyteNTq(:,8);
Out.qpsi=arxyteNTq(:,9);


%% Construct R-Z mesh
r=linspace(Out.rgrid1,Out.rgrid1+Out.xdim,nxefit);
z=linspace(Out.zmid-Out.zdim/2,Out.zmid+Out.zdim/2,nyefit);
[r,z]=meshgrid(r,z);

%% Construct toroidal field on r-z mesh
B=Out.bcentr*Out.rcentr/r(1,:);
B=repmat(B,nyefit,1);
