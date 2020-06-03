function [x,y,n]=density_rxyn2grid(rxyn,nx,ny,xdim,ydim)
if nargin<2
    nx=size(rxyn,1);
end;
if nargin<3
    ny=nx;    
end;
if nargin<3
    xdim=2*max(rxyn(:,1)+sqrt(rxyn(:,2).^2+rxyn(:,3).^2));
end;
if nargin<4
    ydim=xdim;
end
x=linspace(-xdim/2,xdim/2,nx);
y=linspace(-ydim/2,ydim/2,ny);
[X,Y]=meshgrid(x,y);
n=zeros(size(X));
gridstep=min([diff(x),diff(y)]);
Ntheta=round(2*pi*max(rxyn(:,1))/gridstep);
Nr=size(rxyn,1);
theta=linspace(0,2*pi,Ntheta+1);
theta(end)=[];

xx=zeros(Nr,Ntheta);
yy=xx;
nn=xx;

for nr=1:Nr
    nn(nr,:)=rxyn(nr,4);
    xx(nr,:)=rxyn(nr,2)+rxyn(nr,1)*cos(theta);
    yy(nr,:)=rxyn(nr,3)+rxyn(nr,1)*sin(theta);
end
n=griddata(xx,yy,nn,X,Y);
