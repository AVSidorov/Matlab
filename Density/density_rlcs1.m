function [Rlcs,ld,xmax,xmin,ymax,ymin,thetaMax]=density_rlcs1(shiftX,shiftY,trian,el,Plot)
N=200;
Rdia=7.85;
lx=1.5;
thetaMax=0;
if nargin<5
    Plot=true;
end

Rlcs=fminbnd(@Rmax,0,Rdia);
theta=linspace(thetaMax-pi,thetaMax+pi,N+1)';
theta(end)=[];
x=shiftX+Rlcs*(cos(theta)-trian*sin(theta).^2);
y=shiftY+Rlcs*el*sin(theta);
[xmin,xi1]=min(x);
[xmax,xi2]=max(x);
sh=min([xi1 xi2])-1;
x=circshift(x,-sh);
y=circshift(y,-sh);
ymin=min(y);
ymax=max(y);
yl1=interp1(x(1:fix(N/2)),y(1:fix(N/2)),lx);
yl2=interp1(x(ceil(N/2)+1:end),y(ceil(N/2)+1:end),lx,'spline');
ld=abs(yl1-yl2);
if Plot
    figure;
    grid on; hold on;
    axis equal;
    plot(Rdia*cos(theta),Rdia*sin(theta),'k','LineWidth',2);
    plot(x,y,'r','LineWidth',2);
    plot(lx*[1 1],[yl1 yl2],'k');
end
function dR=Rmax(a)
    theta=linspace(thetaMax-pi,thetaMax+pi,N+1);
    theta(end)=[];
    

    x=shiftX+a*(cos(theta)-trian*sin(theta).^2);
    y=shiftY+a*el*sin(theta);
    R=sqrt(x.^2+y.^2);
    [Rm,thetaI]=max(R);
    if thetaI>1&&thetaI<N
        fit=polyfit(theta(thetaI-1:thetaI+1),R(thetaI-1:thetaI+1),2);
        thetaMax=-fit(2)/2/fit(1);
        xx=shiftX+a*(cos(thetaMax)-trian*sin(thetaMax).^2);
        yy=shiftY+a*el*sin(thetaMax);
        Rm=sqrt(xx.^2+yy.^2);
        dR=abs(Rm-Rdia);
    else
        thetaMax=theta(thetaI);
        dR=Rmax(a);
    end
        
end
end