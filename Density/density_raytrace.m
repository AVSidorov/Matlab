function [curX,curY,curKx,curKy,curL,curPhase,curPhase1,vacPhase,L,curAx,curAy]=density_raytrace(x,y,n,x0,y0,kx0,ky0,freq)
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
    
%% preallocation
    Nstep=2*max(nx+1,ny+1);
    curX=zeros(Nstep,1);
    curY=zeros(Nstep,1);
    curKx=zeros(Nstep,1);
    curKy=zeros(Nstep,1);
    curL=zeros(Nstep,1);
    curPhase=zeros(Nstep,1);
    curPhase1=zeros(Nstep,1);
    vacPhase=zeros(Nstep,1);
    curAx=zeros(Nstep,1);
    curAy=zeros(Nstep,1);
    
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
        kX=fix(curX(i));
        kY=fix(curY(i));
        
        gradNx=dNx(kY,kX);
        gradNy=dNy(kY,kX);

        k=sqrt(curKx(i).^2+curKy(i).^2);

	curAx(i)=-gradNx/2/nc/2;
	curAy(i)=-gradNy/2/nc/2;

        
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

        %% determination distance to nearest cell border in grid units  
        x2left(2)=kX-curX(i); %moving inside shifted grid cell
        x2right(1)=1+kX-curX(i);
        
        y2down(2)=kY-curY(i);
        y2up(1)=1+kY-curY(i);
        
        
        %% founding shortest path length till cell border in physical units 
        l=zeros(0,1);
        
        l=[l;roots([-gradNx/2/nc/2*w^2/c^2/k^2,curKx(i)/k,-max(x2left(x2left<0))*hx])];
        l=[l;roots([-gradNx/2/nc/2*w^2/c^2/k^2,curKx(i)/k,-min(x2right(x2right>0))*hx])];
            
        l=[l;roots([-gradNy/2/nc/2*w^2/c^2/k^2,curKy(i)/k,-max(y2down(y2down<0))*hy])];
        l=[l;roots([-gradNy/2/nc/2*w^2/c^2/k^2,curKy(i)/k,-min(y2up(y2up>0))*hy])];
        
        l=l(~imag(l(:)));
        l=l(l>0);
        if isempty(l)
            i=i-1;
            break;
        else
            i=i+1;
            curL(i)=min(l);
            curKx(i)=curKx(i-1)-gradNx/2/nc*w^2/c^2/k*curL(i);
            curKy(i)=curKy(i-1)-gradNy/2/nc*w^2/c^2/k*curL(i);
            
            %convert physical length to grid coordinates
            %in main grid 
            
            dx=polyval([-gradNx/2/nc/2*w^2/c^2/k^2,curKx(i-1)/k,0],curL(i));
            dy=polyval([-gradNy/2/nc/2*w^2/c^2/k^2,curKy(i-1)/k,0],curL(i));

            curX(i)=curX(i-1)+dx/hx; 
            curY(i)=curY(i-1)+dy/hy;
            
            
            curPhase(i)=curPhase(i-1)+curL(i)*(k+sqrt(curKx(i)^2+curKy(i)^2))/2;
            curPhase1(i)=curPhase1(i-1)+dx*curKx(i-1)+dy*curKy(i-1);
            vacPhase(i)=vacPhase(i-1)+curL(i)*w/c;
            
            %snaprounding to shifted grid first time at step 2
             if abs(curX(i)-fix(curX(i)))<abs(curY(i)-fix(curY(i)))
                 curX(i)=round(curX(i));
             else
                 curY(i)=round(curY(i));
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
    curPhase=curPhase(1:i);
    curPhase1=curPhase1(1:i);
    vacPhase=vacPhase(1:i);
    curAx=curAx(1:i);
    curAy=curAy(1:i);

    L=cumsum(curL);
end