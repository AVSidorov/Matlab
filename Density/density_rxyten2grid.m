function [x,y,n,X,Y]=density_rxyten2grid(rxyten,nx,ny,xdim,ydim)
NthetaMax=1000;
if size(rxyten,2)==4
    rxyten(:,[1:3,6])=rxyten;
    rxyten(:,4)=0;
    rxyten(:,5)=1;
end
if nargin<2
    nx=size(rxyten,1);
end;
if nargin<3
    ny=nx;    
end;

rxyten=sortrows(rxyten);
gridstep=min(diff(rxyten(:,1)));
Ntheta=round(2*pi*max(rxyten(:,1))/gridstep);
Ntheta=min([Ntheta,NthetaMax]);
Nr=size(rxyten,1);
theta=linspace(0,2*pi,Ntheta+1);
theta(end)=[];

xx=zeros(Nr,Ntheta);
yy=xx;
nn=xx;

for nr=1:Nr
    nn(nr,:)=rxyten(nr,6);
    xx(nr,:)=rxyten(nr,2)+rxyten(nr,1)*(cos(theta)-rxyten(nr,4)*sin(theta).^2);
    yy(nr,:)=rxyten(nr,3)+rxyten(nr,1)*rxyten(nr,5)*sin(theta);  
end


if nargin<3
    x=[rxyten(:,2)-rxyten(:,1);rxyten(:,2)+rxyten(:,1)];
    x=sortrows(x);
    y=[rxyten(:,3)+rxyten(:,1).*rxyten(:,5);rxyten(:,3)-rxyten(:,1).*rxyten(:,5)];
    y=sortrows(y);
else
    if nargin<4
        ydim=xdim;
    end    
    x=linspace(-xdim/2,xdim/2,nx);
    y=linspace(-ydim/2,ydim/2,ny);
end
[X,Y]=meshgrid(x,y);
n=griddata(xx,yy,nn,X,Y);
%n(isnan(n(:)))=0; %removed because this function can be used for
%laserChord mapping and r outside core is not zero
