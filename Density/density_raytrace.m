function [curX,curY,curKx,curKy,curL,curPhase]=density_raytrace(x,y,n,x0,y0,kx0,ky0,freq)
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
%% gradient
    [dNx,dNy]=gradient(n,x,y);
    
%% step grid
    x=reshape(x,1,[]); %vectors to row
    y=reshape(y,1,[]);
    dX=diff(x);
    dY=diff(y);
    
    xx=[x(1) (x(1:end-1)+x(2:end))/2 x(end)]; %shifted grid with constant gradient in cell
    yy=[y(1) (y(1:end-1)+y(2:end))/2 y(end)];

    dXX=diff(xx);
    %dX=[dX(1),dX];
    dYY=diff(yy);
    %dY=[dY(1),dY];

%% preallocation
    Nstep=2*max(nx+1,ny+1);
    curX=zeros(Nstep,1);
    curY=zeros(Nstep,1);
    curKx=zeros(Nstep,1);
    curKy=zeros(Nstep,1);
    curL=zeros(Nstep,1);
    curPhase=zeros(Nstep,1);
    
    x2left=[-1 0];
    x2right=[0 1];
    
    y2down=[-1 0];
    y2up=[0,1];
%%  initialization of the rays
    curX(1)=interp1(x,1:nx,x0,'linear',1);
    curY(1)=interp1(y,1:ny,y0,'linear',1);
    curKx(1)=kx0*w/c;
    curKy(1)=ky0*w/c;    

    
%% actual raytracing from cell to cell
    i=1;
    while 1<curX(i)&&curX(i)<nx&&1<curY(i)&&curY(i)<ny %coordinates in grid units
        %% current values 
        gradNx=dNx(round(curY(i)),round(curX(i)));
        gradNy=dNy(round(curY(i)),round(curX(i)));
        
        kX=fix(curX(i));
        kY=fix(curY(i));
        %get number of cell in shifted grid
        kXX=round(curX(i));
        kYY=round(curY(i));
        
        curXX=kXX+(x(kX)+dX(kX)*(curX(i)-kX)-xx(kXX))/dXX(kX);
        curYY=kYY+(y(kY)+dY(kY)*(curY(i)-kY)-yy(kYY))/dYY(kY);
        
        hx=dX(kX); 
        hy=dY(kY);

        hxx=dXX(kXX); 
        hyy=dYY(kYY);
        %% determination distance to nearest cell border in grid units  
        x2left(2)=kXX-curXX; %moving inside shifted grid cell
        x2right(1)=1+kXX-curXX;
        
        y2down(2)=kYY-curYY;
        y2up(1)=1+kYY-curYY;
        
        
        %% founding shortest path length till cell border in physical units 
        l=zeros(0,1);
        
        l=[l;roots([-gradNx/2/nc/2,curKx(i)*c/w,-max(x2left(x2left<0))*hxx])];
        l=[l;roots([-gradNx/2/nc/2,curKx(i)*c/w,-min(x2right(x2right>0))*hxx])];
            
        l=[l;roots([-gradNy/2/nc/2,curKy(i)*c/w,-max(y2down(y2down<0))*hyy])];
        l=[l;roots([-gradNy/2/nc/2,curKy(i)*c/w,-min(y2up(y2up>0))*hyy])];
        
        l=l(~imag(l(:)));
        l=l(l>0);
        if isempty(l)
            break;
        else
            curL(i)=min(l);
            curKx(i+1)=curKx(i)-gradNx*w/2/nc/c*curL(i);
            curKy(i+1)=curKy(i)-gradNy*w/2/nc/c*curL(i);
            
            %convert physical length to grid coordinates
            %in main grid 
            curX(i+1)=curX(i)+polyval([-gradNx/2/nc/2,curKx(i)*c/w,0],curL(i))/hx; 
            curY(i+1)=curY(i)+polyval([-gradNy/2/nc/2,curKy(i)*c/w,0],curL(i))/hy;
            
            
            curPhase(i+1)=curPhase(i)+curL(i)*w/c;
            i=i+1;
            %snaprounding to shifted grid first time at step 2
             if abs(curX(i)-fix(curX(i))-0.5)<abs(curY(i)-fix(curY(i))-0.5)
                 curX(i)=fix(curX(i))+0.5;
             else
                 curY(i)=fix(curY(i))+0.5;
             end;

        end;
    end;
    curX=curX(1:i);
    curY=curY(1:i);
    curX=interp1(1:nx,x,curX,'linear','extrap');
    curY=interp1(1:ny,y,curY,'linear','extrap');
    curKx=curKx(1:i);
    curKy=curKy(1:i);
    curL=curL(1:i);
end