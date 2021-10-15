function [curX,curY,curKx,curKy,curL,curAx,curAy,curPhase]=density_raytrace(x,y,n,x0,y0,kx0,ky0,freq)
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
    curL=inf(Nstep,1);

    curAx=zeros(Nstep,1);
    curAy=zeros(Nstep,1);

    curPhase=zeros(Nstep,1);
    curPhase1=zeros(Nstep,1);
    kByDen=zeros(Nstep,1);

    
    x2left=[-1 0];
    x2right=[0 1];
    
    y2down=[-1 0];
    y2up=[0,1];
%%  initialization of the rays
    curX(1)=interp1(x,1:nx,x0,'linear',1);
    curY(1)=interp1(y,1:ny,y0,'linear',1);
    [X,Y]=meshgrid(x,y);
    n0=interp2(X,Y,n,x0,y0); %interpolated ("exact") density in starting point
    N=sqrt(1-n0/nc);         %refractive index in starting point
    curKx(1)=kx0*w/c*N;
    curKy(1)=ky0*w/c*N;
    kByDen(1)=N*w/c;

    
%% actual raytracing from cell to cell
    i=1;
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

        %% determination distance to nearest cell border in grid units  
        x2left(2)=kX-curX(i); %moving inside shifted grid cell
        x2right(1)=1+kX-curX(i);
        
        y2down(2)=kY-curY(i);
        y2up(1)=1+kY-curY(i);     
                
        %% determination new state by iteration over directions of moving
        
        xy=[]; %variable to store direction of move

        newState([curAx(i)/2,curKx(i),-max(x2left(x2left<0))*hx],1);
        newState([curAx(i)/2,curKx(i),-min(x2right(x2right>0))*hx],2);
            
        newState([curAy(i),curKy(i),-max(y2down(y2down<0))*hy],3);
        newState([curAy(i),curKy(i),-min(y2up(y2up>0))*hy],4);
        
        i=i+1;
        %% exit from cycle or snaprounding to grid 
        % first time at i=2 (after first step, which can start inside cell)
        if  isempty(xy)
            i=i-1;
            break;
        else
             if xy<3
                 curX(i)=round(curX(i));
             else
                 curY(i)=round(curY(i));
             end;
        end           
    end;
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
    
function newState(coeff,xyMark)   
    if coeff(1)==0
        t=-coeff(3)/coeff(2);
    else
        t=roots(coeff);
    end;
    t=t(~imag(t));
    t=t(t~=0);
    for ii=1:numel(t)
        kx=curKx(i)+curAx(i)*t(ii);
        ky=curKy(i)+curAy(i)*t(ii);
        k1=sqrt(kx^2+ky^2);
        if abs(k1-curK)<1e2*eps
            l=t(ii)*(k1+curK)/2;
        else
            l=t(ii)*(k1-curK)/(log(k1)-log(curK));
        end;
        if l>0&&l<curL(i+1)
            xy=xyMark;
            curKx(i+1)=kx;
            curKy(i+1)=ky;

            %convert physical length to grid coordinates           
            dx=curAx(i)*t(ii)^2/2+curKx(i)*t(ii);
            dy=curAy(i)*t(ii)^2/2+curKy(i)*t(ii);

            curX(i+1)=curX(i)+dx/hx; 
            curY(i+1)=curY(i)+dy/hy;

            curL(i+1)=l;
            
            % additional values that can be calculated later
            curPhase(i+1)=curPhase(i)+l*(k1+curK)/2;
        end
    end
end
end

