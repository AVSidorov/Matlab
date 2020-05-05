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
n(:)=interp1(rxyn(:,1),rxyn(:,4),density_xy2r(X(:),Y(:),rxyn),'pchip',0);
%