function [ph,Amp,curX,curY,curPhase,E,Eant]=density_beamtrace_(x,y,n,rays,antx_TX,anty_TX,antx_RX,anty_RX,freq)
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
    focus=0.0095; %in meters

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
    
    curPhase=zeros(Nr,Nsteps);    
    out=false(Nr,1);
    
    
    
%%  initialization of the rays
    
    curX(:,1)=interp1(x,1:nx,rays(:,1)*100+antx_TX,'linear',1);
    curY(:,1)=interp1(y,1:ny,(rays(:,2)-focus)*100+anty_TX,'linear',1);
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
            curPhase(j,i+1)=curPhase(j,i)+dx*curKy(j)+dy*curKx(j);
            
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
Nstep=ind-1;
curX=curX(:,1:Nstep);
curY=curY(:,1:Nstep);
curPhase=curPhase(:,1:Nstep);

curX=interp1(1:nx,x,curX,'linear','extrap');
 curY=interp1(1:ny,y,curY,'linear','extrap');

%% Amplitude relative change of field & Full (complex) Field
 ray_dist=sqrt(diff(curX).^2 + diff(curY).^2);
 ray_dist(end+1,:)=ray_dist(end,:);
 ray_dist(2:end-1,:)=(ray_dist(1:end-2,:)+ray_dist(2:end-1,:))/2;
 amp=ray_dist;
 E=amp;
for i=1:Nstep
    amp(:,i)=ray_dist(:,1)./ray_dist(:,i);
    E(:,i)=rays(:,5).*amp(:,i).*exp(-1i*curPhase(:,i));
end;

[~,~,~,rayGauss]=Gauss_beam(x/100,antx_RX/100,-focus,f);

Eant=griddata(curX(:),curY(:),E(:),x,anty_RX*ones(size(x)));
Eant(isnan(Eant))=0;

distint=sqrt(diff(x).^2);
distint(end+1)=distint(end);
distint(2:end-1)=(distint(1:end-2)+distint(2:end-1))/2;

total=sum(rayGauss.*Eant.*distint*0.7);  

ph=angle(total);
Amp=abs(total);

end