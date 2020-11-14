function astra_gsef_analyze(gsef)
Nintrp=360;
theta=linspace(0,2*pi,Nintrp)';
R_Aintrp=interp1([gsef.thetap;gsef.thetap(1)+2*pi],[gsef.r_a(end,:),gsef.r_a(end,1)]',theta,'pchip');
Rb=gsef.XX(1,1)+cos(theta).*R_Aintrp;
Zb=gsef.YY(1,1)+sin(theta).*R_Aintrp;
[R,Z]=meshgrid(linspace(min(Rb),max(Rb),Nintrp),linspace(min(Zb),max(Zb),Nintrp));
PSI=griddata(gsef.XX,gsef.YY,gsef.PSI/2/pi,R,Z,'cubic'); % /2/pi because in geqdsk  flux is in Weber/rad

dr=R(1,3)-R(1,2);
dz=Z-Z(1,1);
[psiDR,psiDZ]=gradient(gsef.PSI,dr,dz);
Br=-psiDZ./gsef.XX;
Bz=psiDR./gsef.XX;
Br_bnd=griddata(r,z,Br,rbdry,zbdry,'cubic');
Bz_bnd=griddata(r,z,Bz,rbdry,zbdry,'cubic');
Bpol=sqrt(Br_bnd.^2+Bz_bnd.^2);
