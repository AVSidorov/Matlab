function ph=density_beamtrace(x,y,n,rays,antx_TX,anty_TX,antx_RX,anty_RX,freq)
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

%% Gauss beam parameters
    % in meters
    focus=0.0009; %distanse of Gauss beam waist from antenna surface
    
%%  initialization of the rays
    curX=interp1(x,1:nx,rays(:,1)*100+antx_TX,'linear',1);
    curY=interp1(y,1:ny,rays(:,2)*100+anty_TX,'linear',1);
    curKx=rays(:,3)*w/c;
    curKy=rays(:,4)*w/c;
    

%% preallocation
    Nr=size(rays,1);
    
    curPhase=zeros(Nr,1);    
    ssignal=zeros(Nr,1);
    xpos=zeros(Nr,1);
    out=false(Nr,1);
    amp=ones(Nr,1);
    distbase=zeros(Nr,1);
    distnew=distbase;

%% initial rays "widths"  
    distbase(1:end-1)=sqrt(diff(curX).^2 + diff(curY).^2);
    distbase(end)=distbase(end-1);
    distbase(2:end-1)=(distbase(1:end-2)+distbase(2:end-1))/2;
    distold=distbase;    

    
%% actual ray tracing for each ray step by step
    i=1;
    %%%calculate not ray by ray 
    %%%calculate time step by step (beam front)
    while not(all(out))&&i<=Nsteps
        i=i+1;
        %%% make beam front 
        for j=1:Nr
            
            dx=curKy(j)*dt*c.^2/w;
            dy=curKx(j)*dt*c.^2/w;
        
            if curX(j)>1 && curX(j)<nx && curY(j)>1 && curY(j)<ny
                dkx=dMx(round(curY(j)),round(curX(j)))*dt*w/2/nc;
                dky=dMy(round(curY(j)),round(curX(j)))*dt*w/2/nc;
            else
                if ~out(j) && curX(j)>1 && curX(j)<nx && ((curY(j)-dy/gridstepx)-ny)*(curY(j)-ny)<=0
                    xpos(j)=curX(j);                  
                    ssignal(j)=amp(j)*rays(j,5)*exp(-1i*curPhase(j));
                end
                out(j)=true;
                dkx=0;
                dky=0;                

            end
            
            %new phasse
            curPhase(j)=curPhase(j)+dx*curKy(j)+dy*curKx(j);
            
            %new end of ray
            curX(j)=curX(j)+dx/gridstepx;
            curY(j)=curY(j)+dy/gridstepy;            

            %new wave vector
            curKx(j)=curKx(j)-dkx;
            curKy(j)=curKy(j)-dky;
                                                           
        end;
        %%% calculate beam width
        distnew(1:end-1)=sqrt(diff(curX).^2 + diff(curY).^2);
        distnew(end)=distnew(end-1);
        distnew(2:end-1)=(distnew(1:end-2)+distnew(2:end-1))/2;        
        amp=amp.*distold./distnew;
        distold=distnew;
    end;

%% result phase calculation
    %convert xpos from grid to real coordinates
    xpos=interp1(1:nx,x,xpos,'linear',NaN);
    ssignal(isnan(xpos))=[];
    xpos(isnan(xpos))=[];
    
    [~,~,~,rayGauss]=Gauss_beam(xpos/100,antx_RX/100,-focus,f);
    rayGauss=rayGauss'; % Gauss beam in general case returns array where row is z coordinate number column is x coordinate 
                        % so we get row vector. but we need column one
    distint=sqrt(diff(xpos).^2);
    distint(end+1)=distint(end);
    distint(2:end-1)=(distint(1:end-2)+distint(2:end-1))/2;
    
    total=sum(rayGauss.*ssignal.*distint*0.7);  
    
    ph=angle(total);
end