function [curX,curY,curKx,curKy,curL,curAx,curAy,curPhase]=density_raytrace1(x,y,n,x0,y0,kx0,ky0,freq)
% x,y in cm
%% input check
    if nargin<8||isempty(freq)
        f=135e9;    
    else
        f=freq;
    end;
%% k normalization
 k=norm([kx0 ky0]);
 kx0=kx0/k;
 ky0=ky0/k;
%% constants
    w=2*pi*f;
    c=299792458*100;
    e=4.803e-10;
    me=9.10938356e-28;
    nc=me*w^2/(4*pi*e^2);
%% grid size
    nx=length(x);
    ny=length(y);
    
%% step grid
    x=reshape(x,1,[]); %vectors to row
    y=reshape(y,1,[]);
    dX=diff(x);
    dY=diff(y);
    [DX,DY]=meshgrid(dX,dY);
    
%% gradient
    %[dNx,dNy]=gradient(n,x,y);
    dNx=(n(1:end-1,2:end)-n(1:end-1,1:end-1))./DX;
    dNy=(n(2:end,1:end-1)-n(1:end-1,1:end-1))./DY;
%% determination of step
dXYmin=min([dX dY])*(sqrt(5)-1)/2; %min cell size divided to gold section
Amax=max(max(abs(dNx(:))),max(abs(dNy(:))))/2/nc*w^2/c^2;
Bmax=w/c;
t=(-Bmax+sqrt(Bmax^2+4*Amax*dXYmin))/2/Amax;
t=min(t,dXYmin*c/w);
%% preallocation
    Nstep=round((range(x)/dXYmin+range(y)/dXYmin)*2/(sqrt(5)-1));
    curX=zeros(Nstep,1);
    curY=zeros(Nstep,1);
    curKx=zeros(Nstep,1);
    curKy=zeros(Nstep,1);
    curL=inf(Nstep,1);

    curAx=zeros(Nstep,1);
    curAy=zeros(Nstep,1);

    curPhase=zeros(Nstep,1);   
    kByDen=zeros(Nstep,1);

    

%%  initialization of the rays
    curX(1)=interp1(x,1:nx,x0,'linear',1);
    curY(1)=interp1(y,1:ny,y0,'linear',1);
    [X,Y]=meshgrid(x,y);
    n0=interp2(X,Y,n,x0,y0); %interpolated ("exact") density in starting point
    N=sqrt(1-n0/nc);         %refractive index in starting point
    curKx(1)=kx0*w/c*N;
    curKy(1)=ky0*w/c*N;
    kByDen(1)=N*w/c;

    
%% actual raytracing 
    i=1;
    dx=0;
    dy=0;
    while 1<curX(i)&&curX(i)<nx&&1<curY(i)&&curY(i)<ny %coordinates in grid units
        %% current values         
        kX=fix(curX(i));
        kY=fix(curY(i));
        
        gradNx=dNx(kY,kX);
        gradNy=dNy(kY,kX);

        N=sqrt(1-n(round(curY(i)),round(curX(i)))/nc);
        kByDen(i)=N*w/c;

        curK=sqrt(curKx(i).^2+curKy(i).^2);
        
        curAx(i)=-gradNx/2/nc*w^2/c^2;
        curAy(i)=-gradNy/2/nc*w^2/c^2;

        
        if curX(i)-kX==0&&curKx(i)<0
            hx=dX(kX-1);
        else            
            hx=dX(kX); 
        end    
        if curY(i)-kY==0&&curKy(i)<0
            hy=dY(kY-1);
        else            
            hy=dY(kY);
        end
        %moving from previous step
        curX(i)=curX(i)+dx/hx;
        curY(i)=curY(i)+dy/hy;
        
        kx=curKx(i)+curAx(i)*t;
        ky=curKy(i)+curAy(i)*t;
        k1=sqrt(kx^2+ky^2);
        if abs(k1-curK)<1e2*eps
            l=t*(k1+curK)/2;
        else
            l=t*(k1-curK)/(log(k1)-log(curK));
        end;
        
        curKx(i+1)=kx;
        curKy(i+1)=ky;

        dx=curAx(i)*t^2/2+curKx(i)*t;
        dy=curAy(i)*t^2/2+curKy(i)*t;

        %convert physical length to grid coordinates           
        curX(i+1)=curX(i)+dx/hx; 
        curY(i+1)=curY(i)+dy/hy;

        % cross cell step
        % snap to cell border
        if fix(curX(i+1))~=kX
            curX(i+1)=round(curX(i+1));
        end
        
        if fix(curY(i+1))~=kY
            curY(i+1)=round(curY(i+1));
        end
        
        % store residual distance
        dx=dx-hx*(curX(i+1)-curX(i));
        dy=dy-hy*(curY(i+1)-curY(i));
        if abs(dx)<10*eps
            dx=0;
        end
        if abs(dy)<10*eps
            dy=0;
        end
        
        
        curL(i+1)=l;
            
      % additional values that can be calculated later
        curPhase(i+1)=curPhase(i)+l*(k1+curK)/2;

        i=i+1;
    end;
    curAx(i)=0;
    curAy(i)=0;
    
    curL(1)=0;
    
    curX=curX(1:i);
    curY=curY(1:i);
    curX=interp1(1:nx,x,curX,'linear','extrap');
    curY=interp1(1:ny,y,curY,'linear','extrap');
    curKx=curKx(1:i);
    curKy=curKy(1:i);
    curL=curL(1:i);
    curPhase=curPhase(1:i);
    curAx=curAx(1:i);
    curAy=curAy(1:i);
    
    kByDen=kByDen(1:i);   
end

