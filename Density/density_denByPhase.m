function [rxyn,prof,ph,phU,khi,niter]=density_denByPhase(antSet,Ph,rays,rxyn,ph,freq)
Rdia=7.79;
Rlcs=7.57;
xdim=20;
nx=2200;
ydim=20;
ny=2200;
k=0.1;

if nargin<5
    ph=[];
end
if nargin<6
    freq=[];
end;

%% prepare rxyn
if nargin<4||isempty(rxyn)
    rxyn=zeros(200,4);
    rxyn(:,1)=linspace(0,Rdia,200);
    rxyn(1,1)=1e-4;
else
    rxyn=sortrows(rxyn);    
end  
%% determine Rlcs
if isempty(Rlcs)
    Rlcs=rxyn(find(rxyn(:,1)+sqrt(rxyn(:,2).^2+rxyn(:,3).^2)>=Rdia,1,'first'),1);
    if isempty(Rlcs)
        Rlcs=Rdia-sqrt(rxyn(end,2)^2+rxyn(end,3)^2);
    end
end;
rxyn(rxyn(:,1)>Rlcs,:)=[];
if rxyn(end,1)~=Rlcs
    rxyn(end+1,:)=rxyn(end,:);
    rxyn(end,1)=Rlcs;
    rxyn(end,2)=Rdia-Rlcs;
end;  

%% get phases from measured points
x=linspace(-xdim/2,xdim/2,nx);
ph0=csaps([rxyn(end,2)-Rlcs;Ph(:,1);rxyn(end,2)+Rlcs],[0;Ph(:,2);0],1,x);
ph0(x<=rxyn(end,2)-Rlcs)=0;
ph0(x>=rxyn(end,2)+Rlcs)=0;

%% make initial densities by pancakes if isempty
   if all(rxyn(:,4)<1e10)
        rxynOld=rxyn;
        [rxyten,R,C,~,~,Den]=density_pancake(x,ph0,freq);
        rxyn=rxyten(:,[1:3,end]);
%         rxyn=zeros(size(R,1),4);
%         rxyn(:,[1,2,4])=[R,C,Den];
         rxyn(rxyn(:,1)>Rlcs,:)=[];
         rxyn=sortrows(rxyn);
         rxyn(:,3)=interp1(rxynOld(:,1),rxynOld(:,3),rxyn(:,1));
   end
%% fit
nr=size(antSet,1); % number of beams

niter=3;
while niter>2
    khi=NaN(11,1);
    khi(1)=inf;
    rxynOld=rxyn;
    for i=1:100
        %% make grid
        [x,y,n]=density_rxyn2grid(rxyn,nx,ny,xdim,ydim);
        n(isnan(n(:)))=0;

        %% get phases line integration
        ph1=density_phase_by_grid(y,n,freq);

        %% get phases beam tracing
        [prof,ph,phU]=density_phase_by_beamtrace(x,y,n,rays,antSet,ph,[],[],freq);

        khi(i+1)=sum((Ph(:,2)-prof).^2);
        if khi(i+1)>khi(i)
            rxyn=rxynOld;
            break;
        end;
        phB=csaps([rxyn(end,2)-Rlcs;Ph(1:nr,1);rxyn(end,2)+Rlcs],[0;prof;0],1,x);
        phB(x<=rxyn(end,2)-Rlcs)=0;
        phB(x>=rxyn(end,2)+Rlcs)=0;

        %% make dPh
         dPh=ph0-phB;
        % dPh=csaps([rxyn(end,2)-Rlcs;Ph(1:nr,1);rxyn(end,2)+Rlcs],[0;Ph(:,2)-prof;0],1,x); % gives same result               
        %% change ph1 and make new rxyn;
        ph1=reshape(ph1,1,[]);
        ph1=ph1+k*dPh;
        ph1(ph1<0)=0;

        [rxyten,R,C,~,~,Den]=density_pancake(x,ph1,freq);
        rxynOld=rxyn;
        rxyn=rxyten(:,[1:3,end]);
%         rxyn=zeros(size(R,1),4);
%         rxyn(:,[1,2,4])=[R,C,Den];
        rxyn(:,3)=interp1(rxynOld(:,1),rxynOld(:,3),rxyn(:,1),'linear',mean(rxynOld(:,3)));
        rxyn(rxyn(:,1)>Rlcs,:)=[];
        rxyn=sortrows(rxyn);
        if rxyn(end,1)~=Rlcs
            rxyn(end+1,:)=rxyn(end,:);
            rxyn(end,1)=Rlcs;
        end;
        save('tmp.mat','rxyn');
    end
    niter=i;
    if niter~=2
        ph=[];
    end;
end