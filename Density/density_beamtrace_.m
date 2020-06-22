function [ph,amp,phCTx,phCRx,phCRxM,phaseAlong,curX,curY]=density_beamtrace_(x,y,n,rays,antx,anty,freq)
% x,y in cm
if nargin<7||isempty(freq)
    f=135e9;    
else
    f=freq;
end;

%% constants
    w=2*pi*f;
    c=299792458*100;
    e=4.803e-10;
    me=9.10938356e-28;
    nc=me*w^2/(4*pi*e^2);


%% Grid 
    %adjust grid by ant
    Ind=find(abs(y)>abs(anty));
    y(Ind)=[];
    n(Ind,:)=[];

    %find central ray
    [~,cRi]=min(abs(rays(:,1)));

    nx=size(n,2);
    ny=size(n,1);

    Nr=size(rays,1);
    Nsteps=10000;
    dt=1e-13;
    gridstepx=x(2)-x(1);
    gridstepy=y(2)-y(1);

    [dMy,dMx]=gradient(n,gridstepx);

%% Gauss beam parameters
    waist=0.0035;
    focus=0.09+x(1)/100;
    lambd  = 299792458.0/f;
    z_R = pi * waist^2 / lambd;
    z=-focus;
    ypos=round(interp1(x,1:length(x),antx,'linear',1));

    dz=z-(1-1)*0.0002;
    wa=waist*sqrt(1.+(dz^2/z_R^2));
    R=(dz)*(1.+z_R^2/dz^2);

%% initialization of the rays
    curX=NaN(Nr,Nsteps);
    curY=NaN(Nr,Nsteps);
    curX(:,1)=round(interp1(x,1:length(x),rays(:,1)*100+antx,'linear',1));
    curY(:,1)=round(interp1(y,1:length(y),rays(:,2)*100+anty,'linear',1));
    curKx=rays(:,3)*w/c;
    curKy=rays(:,4)*w/c;

    distbase=sum(sqrt(diff(curX(:,1)).^2 + diff(curY(:,1)).^2 ));

%% preallocation
    curPhase=zeros(Nr,1);    
    ssignal=zeros(Nr,1);
    xpos=ones(Nr,1)*x(end);
    out=false(Nr,1);
    amp=zeros(Nsteps,1);
    phaseAlong=zeros(Nr,1);

%% actual ray tracing for each ray step by step
    amp(1)=1;
    distold=distbase;
    i=0;
    %%%calculate not ray by ray 
    %%%calculate time step by step (beam front)
    while not(all(out))&&i<=Nsteps
        i=i+1;
        %%% make beam front 
        for j=1:Nr
            dx=curKy(j)*dt*c.^2/w;
            dy=curKx(j)*dt*c.^2/w;
            if curX(j,i)>1 && curX(j,i)<nx && curY(j,i)>1 && curY(j,i)<ny
                curN=n(round(curY(j,i)),round(curX(j,i)));
                dkx=dMx(round(curY(j,i)),round(curX(j,i)))*dt*w/2/nc;
                dky=dMy(round(curY(j,i)),round(curX(j,i)))*dt*w/2/nc;
                dl=sqrt(dx^2+dy^2);                
                phaseAlong(j)=phaseAlong(j)-w/c*(sqrt(1-curN/nc)-1)*dl;
            else
                out(j)=true;
                dkx=0;
                dky=0;
                curN=0;
            end
            
            curX(j,i+1)=curX(j,i)+dx/gridstepx;
            curY(j,i+1)=curY(j,i)+dy/gridstepy;            

            curKx(j)=curKx(j)-dkx;
            curKy(j)=curKy(j)-dky;
            curPhase(j)=curPhase(j)+dx*curKy(j)+dy*curKx(j);

            if curX(j,i+1)>1 && curX(j,i+1)<nx&&((curY(j,i)-ny)*(curY(j,i+1)-ny))<=0                
                xpos(j)=interp1(1:nx,x,curX(j,i));
                ssignal(j)=amp(i)*rays(j,5)*exp(-1i*curPhase(j));
            end                        
        end;
        %%% calculate beam width
        distnew=sum(sqrt(diff(curX(:,i+1)).^2 + diff(curY(:,i+1)).^2 ));
        amp(i+1)=amp(i)*distold/distnew;
        distold=distnew;
    end;

%% Result calculation
    rayGBeam_Amplitude=waist/wa*exp(-(xpos/100-x(ypos)/100).^2/(wa*1)^2);
    rayGauss=rayGBeam_Amplitude.*exp(1i*(2*pi*dz/lambd+pi*(xpos/100-x(ypos)/100).^2/(R*lambd)));
    total=sum(rayGauss.*ssignal*0.7);  

    ph=angle(total);
    amp=abs(total);
%% convert curX curY from grid values;
     curX=interp1(1:nx,x,curX);
     curY=interp1(1:ny,y,curY);

%% phases in rays on Rx antena
    % pick rays in getting Rx antena
    bool=abs(xpos-antx)<1;
    phaseAlong(~bool)=0;

    phCTx=phaseAlong(cRi);
    [~,cRi]=min(abs(antx-xpos));
    phCRx=phaseAlong(cRi);
    phCRxM=mean(phaseAlong(find(phaseAlong)));
end   
