function [curX,curY]=density_beamtrace_(x,y,n,rays,antx_TX,anty_TX,antx_RX,anty_RX,freq)
% function 
% x,y in cm

%% input check
    if nargin<9||isempty(freq)
        f=135e9;    
    else
        f=freq;
    end;

%% settings
    Nsteps=10000;
    dt=1e-13;

%% constants
    w=2*pi*f;
    c=299792458*100;
    e=4.803e-10;
    me=9.10938356e-28;
    nc=me*w^2/(4*pi*e^2);

%% adjust grid by ant
    Ind=find(y<anty_TX);
    y(Ind)=[];
    n(Ind,:)=[];

    Ind=find(y>anty_RX);
    y(Ind)=[];
    n(Ind,:)=[];

    nx=size(n,2);
    ny=size(n,1);

    gridstepx=x(2)-x(1);
    gridstepy=y(2)-y(1);
    [dMy,dMx]=gradient(n,gridstepx);
%% preallocation
    Nr=size(rays,1);
    curX=zeros(Nr,Nsteps);
    curY=zeros(Nr,Nsteps);
    
    curPhase=zeros(Nr,1);    
    out=false(Nr,1);
    
    
    
%%  initialization of the rays
    
    curX(:,1)=interp1(x,1:nx,rays(:,1)*100+antx_TX,'linear',1);
    curY(:,1)=interp1(y,1:ny,rays(:,2)*100+anty_TX,'linear',1);
    curKx=rays(:,3)*w/c;
    curKy=rays(:,4)*w/c;
    


     
%% actual ray tracing for each ray step by step
    i=1;
    %%%calculate not ray by ray 
    %%%calculate time step by step (beam front)
    while not(all(out))&&i<=Nsteps
        %%% make beam front 
        for j=1:Nr
            
            dx=curKy(j)*dt*c.^2/w;
            dy=curKx(j)*dt*c.^2/w;
        
            if curX(j,i)>1 && curX(j,i)<nx && curY(j,i)>1 && curY(j,i)<ny
                dkx=dMx(round(curY(j,i)),round(curX(j,i)))*dt*w/2/nc;
                dky=dMy(round(curY(j,i)),round(curX(j,i)))*dt*w/2/nc;
            else
                out(j)=true;
                dkx=0;
                dky=0;                

            end
            
            %new phasse
            curPhase(j,i)=curPhase(j)+dx*curKy(j)+dy*curKx(j);
            
            %new end of ray
            curX(j,i+1)=curX(j,i)+dx/gridstepx;
            curY(j,i+1)=curY(j,i)+dy/gridstepy;            

            %new wave vector
            curKx(j)=curKx(j)-dkx;
            curKy(j)=curKy(j)-dky;
                                                           
        end;
        i=i+1;
    end;
%% convert from greed to meters
ind=find(all(curX==0),1,'first');
curX=curX(:,1:ind-1);
curY=curY(:,1:ind-1);
 curX=interp1(1:nx,x,curX,'linear',NaN);
 curY=interp1(1:ny,y,curY,'linear',NaN);
    
end