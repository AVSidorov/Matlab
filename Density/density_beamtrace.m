function [ph,ph1,ph0]=density_beamtrace(x,y,n,rays,antx,anty,freq)
% x,y in cm

if nargin<7||isempty(freq)
    f=135e9;    
else
    f=freq;
end;


Nsteps=10000;
dt=1e-13;

w=2*pi*f;
c=299792458*100;
e=4.803e-10;
me=9.10938356e-28;
nc=me*w^2/(4*pi*e^2);


% adjust grid by ant
Ind=find(abs(y)>abs(anty));
y(Ind)=[];
n(Ind,:)=[];

nx=size(n,2);
ny=size(n,1);


gridstepx=x(2)-x(1);
gridstepy=y(2)-y(1);
[dMy,dMx]=gradient(n,gridstepx);

%Gauss beam parameters
% in meters
waist=0.0035;
focus=0.0009; %distanse of Gauss beam waist from antenna surface

lambd  = 299792458.0/f;
z_R = pi * waist^2 / lambd; % Rayleigh length
z=-focus;
dz=z;
wa=waist*sqrt(1.+(dz^2/z_R^2));
R=(dz)*(1.+z_R^2/dz^2);

% %% make rays by gauss beam
%     [rays,F]=density_beam_rays(165,5e-2,[],focus,f);
    Nr=size(rays,1);
    %phase0=angle(F);

    
    %%  initialization of the rays
    curX=interp1(x,1:nx,rays(:,1)*100+antx,'linear',1);
    curY=interp1(y,1:ny,rays(:,2)*100+anty,'linear',1);
    curKx=rays(:,3)*w/c;
    curKy=rays(:,4)*w/c;
    

    % preallocation
    curPhase=zeros(Nr,1);    
    ssignal=zeros(Nr,1);
    xpos=ones(Nr,1)*x(end);
    out=false(Nr,1);
    amp=ones(Nr,1);
    distbase=zeros(Nr,1);
    distnew=distbase;

    % initial rays "widths"  
    distbase(1:end-1)=sqrt(diff(curX).^2 + diff(curY).^2);
    distbase(end)=distbase(end-1);
    distbase(2:end-1)=(distbase(1:end-2)+distbase(2:end-1))/2;
    distold=distbase;    

    
    %%%actual ray tracing for each ray step by step
    i=1;
    %%%calculate not ray by ray 
    %%%calculate time step by step (beam front)
    while not(all(out))&&i<=Nsteps
%         plot(x(1)+curX*gridstepx,y(1)+curY*gridstepx,'.k','MarkerSize',1);
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
                    xpos(j)=x(round(curX(j))); %faster
                    %xpos(j)=interp1(1:nx,x,curX(j));
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

    rayGBeam_Amplitude=waist/wa*exp(-(xpos/100-antx/100).^2/(wa*1)^2);
    rayGauss=rayGBeam_Amplitude.*exp(1i*(2*pi*dz/lambd+pi*(xpos/100-antx/100).^2/(R*lambd)));
    
    distint=sqrt(diff(xpos).^2);
    distint(end+1)=distint(end);
    distint(2:end-1)=(distint(1:end-2)+distint(2:end-1))/2;
    
    total=sum(rayGauss.*ssignal.*distint*0.7);  
    
    ph=angle(total);
    [ph1,ph0]=density_phase_by_grid(y,n,f);
    ph1=interp1(x,ph1,antx);
    ph0=interp1(x,ph0,antx);
end